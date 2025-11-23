

import 'package:meta/meta.dart';
import 'package:realestate_app/customWidget/general/Callback.dart';

abstract class CanNotifyChange<T>
{
  List<ValueChangedCallback<T>> _listeners = [];

  addListener(ValueChangedCallback<T> listener)
  {
    if(!_listeners.contains(listener))
      _listeners.add(listener);
  }

  removeListener(ValueChangedCallback<T> listener)
  {
    _listeners.remove(listener);
  }

  @protected
  callbackAllListeners(T change)
  {
    _listeners.forEach((l) =>l(change));
  }
}