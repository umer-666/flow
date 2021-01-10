import 'package:flutter/material.dart';

///[2:49 PM 12/15/2020]
///[TOGGLE] button inspired by instagram's FOLLOW / UNFOLLOW buttons on profile
///[KNOWN ISSUES]
/// The main text (title) is switched with the morphText if the [filled] property is set to [true]

//ignore: must_be_immutable
class MorphButton extends StatefulWidget {
  Key key;

  ///[don't remember why I did this]
  final Widget child;

  ///sets the [text] to be displayed on the button, SEE [KNOWN ISSUES]
  final String text;

  ///sets the [text] to be displayed when the button is [Tapped], SEE [KNOWN ISSUES]
  final String morphText;

  ///sets the style for the [text] displayed on the button. Applies to both
  ///[text] as well as [morphText]
  TextStyle textStyle;

  /// provide a [callback] to be executed [onTap]
  final Function onClick;

  /// provide a [second callback] to be executed [onTap]
  /// when the button has be morphed
  final Function onMorphClick;

  /// controls whether the button can [morph] defaults to [false]
  final bool morph;

  /// sets the button to have a color fill, like a [Flat button],
  /// defaults to [false]. This prop relys on [initState] and
  /// doesn't display the fill on hot restart.
  final bool filled;

  ///[width] of the morphButton as specified by the [Container] Widget
  final double width;

  ///[height] of the morphButton as specified by the [Container] Widget
  final double height;

  ///[margin] of the morphButton as specified by the [Container] Widget
  final EdgeInsets margin;
  final BorderRadiusGeometry borderRadius;
  Color color;
  Color borderColor;
  Color highlightedBorderColor;
  final Color splashColor;

  MorphButton(
      {this.key,
      this.child,
      this.text,
      this.morphText,
      this.textStyle,
      @required this.onClick,
      this.onMorphClick,
      this.morph = false,
      this.filled = false,
      @required this.width,
      @required this.height,
      this.margin,
      this.borderRadius,
      this.color,
      this.borderColor,
      this.highlightedBorderColor,
      this.splashColor})
      : assert(text != null || child != null),
        assert(width != null),
        assert(height != null);

  @override
  _MorphButtonState createState() => _MorphButtonState();
}

class _MorphButtonState extends State<MorphButton>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool unfilled = true;
  String title;
  Function defaultCallback;

  @override
  void initState() {
    widget.filled ? _createFill() : _createOutline();
    super.initState();
  }

  _createFill() {
    defaultCallback = widget.onMorphClick;
    title = widget.morphText;
    unfilled = false;
    widget.color = Colors.pink[400];
    widget.borderColor = Colors.transparent;
    widget.highlightedBorderColor = Colors.transparent;
  }

  _createOutline() {
    defaultCallback = widget.onClick;
    title = widget.text;
    unfilled = true;
    widget.color = Colors.transparent;
    widget.borderColor = Colors.grey[300];
    widget.highlightedBorderColor = Colors.pink[200];
  }

  void _noMorph() {
    setState(() {
      (defaultCallback == null) ? widget.onClick() : defaultCallback();
      // print('_noMorph');
      widget.filled ? _createFill() : _createOutline();
    });
  }

  void _defaultMorphBehaviour() {
    setState(() {
      (defaultCallback == null) ? widget.onClick() : defaultCallback();
      // print('_defaultMorphBehaviour');
      widget.morph && unfilled ? _createFill() : _createOutline();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      width: widget.width,
      height: widget.height,
      margin: widget.margin ?? EdgeInsets.fromLTRB(2, 2, 2, 2),
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.borderColor ?? Colors.grey[300], width: 0.7),
          color: widget.color ?? Colors.transparent,
          borderRadius:
              widget.borderRadius ?? BorderRadius.all(Radius.circular(4.0))),
      child: OutlineButton(
        textColor: Colors.white,
        splashColor: widget.splashColor ?? Colors.white38,
        color: widget.color ?? Colors.transparent,
        highlightedBorderColor:
            widget.highlightedBorderColor ?? Colors.pink[400],
        onPressed:
            widget.filled && !widget.morph ? _noMorph : _defaultMorphBehaviour,
        child: widget.child ??
            Text(title ?? widget.text,
                style: widget.textStyle ?? TextStyle(color: Colors.white)),
      ),
    );
  }
}
