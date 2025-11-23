



import 'package:realestate_app/customWidget/pagedListView/PagedContentModel.dart';

import 'BLoCModelBase.dart';

class _ProvidedModel
{
  List activeRequesters = [];
  final BLoCModelBase model;
  final String id;

  _ProvidedModel(this.model, this.id);

  /*weHaveBeenRequestedBy(requesterObject)
  {
    if(!activeRequesters.contains(requesterObject))
      activeRequesters.add(requesterObject);
  }

  weHaveBeenAskedToDisposeBy(requesterObject)
  {
    activeRequesters.remove(requesterObject);
  }*/


}



typedef ModelCreator<M extends BLoCModelBase> = M Function(Type type,String id , Object argument,M lastProvidedModel);

class ModelProvider
{
  static ModelProvider _instance;


  List<_ProvidedModel> _recentlyProvidedModels = [];
  Map<String,dynamic Function()> _alternatives = {};
  ModelCreator creator;

  static ModelProvider get instance{
    if(_instance == null)
      _instance = ModelProvider._();

    return _instance;
  }

  ModelProvider._();



  M provideModelFor<M extends BLoCModelBase>(String id,{dynamic requesterObject , Object argument}) {
    if(creator == null)
      throw Exception("dont know how to create model of $M type with $id id.please initialize the 'creator' interface of ModelProvider class");

    var recentlyProvidedModel = _recentlyProvidedModels.firstWhere((element) => element.id==id && element.model is M,orElse:  ()=>null);

    if(recentlyProvidedModel!=null && recentlyProvidedModel.model.isDisposed) {
      _recentlyProvidedModels.removeWhere((element) => element.id == id && element.model is M);
      recentlyProvidedModel = _createOrProvideFromAlternatives(M, id,argument,recentlyProvidedModel.model);
      _recentlyProvidedModels.add(recentlyProvidedModel);
    }else if (recentlyProvidedModel==null) {
      recentlyProvidedModel = _createOrProvideFromAlternatives(M, id,argument,null);
      _recentlyProvidedModels.add(recentlyProvidedModel);
    }

    recentlyProvidedModel.model.announcingThatWeAreBeingProvidedOnceMore(requesterObject,argument);

    return recentlyProvidedModel.model;
  }

  _ProvidedModel _createOrProvideFromAlternatives(Type type,String id, argument,lastProvidedModel)
  {
    try{
      return _ProvidedModel(creator(type, id,argument,lastProvidedModel), id);
    }catch(e,st)
    {
      if(_alternatives.containsKey(id))
        return _ProvidedModel(_alternatives.remove(id)(), id);

      print(st);
      throw Exception("Model Provider was unable to create and there were no alternatives also.check creator or try providing alternatives.error:$e");
    }
  }

  void provideThisOneTimeAlternativeIfCreatorCouldNotCreate(String id,dynamic Function() modelCreator) {
    _alternatives[id]=modelCreator;
  }

  void announcingModelRequesterDisposal(String modelId,  requester) {
   /* var recentlyProvidedModel = _recentlyProvidedModels.firstWhere((element) => element.id==modelId ,orElse:  ()=>null);

    if(recentlyProvidedModel!=null)
      recentlyProvidedModel.weHaveBeenAskedToDisposeBy(requester);*/
  }

  void disposeAllModels() {
    _recentlyProvidedModels.forEach((element) { element.model.dispose(null);});
    _recentlyProvidedModels=[];
    _alternatives={};
  }

}