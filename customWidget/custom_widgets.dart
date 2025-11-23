
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:realestate_app/customWidget/general/Utils.dart';

import 'package:realestate_app/customWidget/Util.dart';

import 'CustomSliderThumbShape.dart';

typedef ButtonToggleStateListener = void Function(String buttonToggledThisTime,
    bool status, Map<String, bool> allButtonsStatus);

class RowOfToggleButtons extends StatefulWidget {
  final ButtonToggleStateListener listener;
  final bool singleSelect;
  final Map<String,bool> _titlesAndTheirInitialState;

  RowOfToggleButtons(this._titlesAndTheirInitialState, {this.listener,this.singleSelect = false});

  createState() => _RowOfToggleButtonsState();
}

class _RowOfToggleButtonsState extends State<RowOfToggleButtons> {
  Map<String, bool> state = {};

  initState() {
    super.initState();
    _reinitializeState();
  }

  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reinitializeState();
  }

  void _reinitializeState() {
    state = widget._titlesAndTheirInitialState;
    if(widget.singleSelect && state.values.where((element) => element).length>1)
      throw Exception("only a single value can be set in single select mode");
  }

  build(context) {

    return SizedBox(
      height: 25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget._titlesAndTheirInitialState.keys
            .map<Widget>((title) => Padding(
                padding: EdgeInsets.only(right: 10),
                child: _createToggleButton(title)))
            .toList(),
      ),
    );
  }

  _createToggleButton(String title) => createRoundedCornerFlatButton(title,
          shapeColor: state[title] ? Color(0xff4790d5) : Colors.white,
          textColor: state[title] ? Colors.white : Colors.black,
          borderColor: state[title] ? Colors.transparent : Color(0xffededed),
          minWidth: 0,
          height: 0,
          cornerRadius: 5,
          padding: EdgeInsets.only(left: 20, right: 20),
          fontFamily: "Halvetica",
          fontSize: 13, onPress: () {
        setState(() {

          if(widget.singleSelect)
            state.updateAll((key, value) => false);

          state[title] = !state[title];

          if (widget.listener != null)
            widget.listener(title, state[title], state);
        });
      });


}



class CustomSlider extends StatefulWidget {
  final ShowValueIndicator showValueIndicator;
  final RangeValues initialSelectedRange;
  final double rangeStart;
  final double rangeEnd;
  final int divisionsCount;
  final ValueChanged<RangeValues> selectedRangeChangedListener;
  CustomSlider(this.rangeStart, this.rangeEnd, this.divisionsCount,{this.initialSelectedRange,this.selectedRangeChangedListener,this.showValueIndicator = ShowValueIndicator.never});

  createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {

  RangeValues currentSelectedRange;


  initState() {
    super.initState();
    _reinitializeCurrentSelectedRange();
  }

  void _reinitializeCurrentSelectedRange() {
    currentSelectedRange = widget.initialSelectedRange == null ? RangeValues(widget.rangeStart,widget.rangeEnd) : widget.initialSelectedRange;
  }

   didUpdateWidget( oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reinitializeCurrentSelectedRange();
  }

  build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        showValueIndicator: widget.showValueIndicator,
        trackHeight: 3.0,
       rangeTrackShape: CustomTrackShape(),
        rangeThumbShape:CustomSliderThumbShape(),
      ),
      child: RangeSlider(
        values: currentSelectedRange,
        min: widget.rangeStart,
        max: widget.rangeEnd,
        divisions: widget.divisionsCount,
        labels: RangeLabels(
          currentSelectedRange.start.round().toString(),
          currentSelectedRange.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            currentSelectedRange = values;
          });

          if(widget.selectedRangeChangedListener!=null)
            widget.selectedRangeChangedListener(values);
        },
      ),
    );
  }
}


