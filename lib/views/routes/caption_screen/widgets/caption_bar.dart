import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//ignore:must_be_immutable
class CaptionBar extends StatefulWidget {
  FocusNode captionBarFocusNode;
  TextEditingController captionController;
  GlobalKey<FormBuilderState> captionBarKey;
  bool validState;
  CaptionBar({
    Key key,
    @required this.captionBarFocusNode,
    @required this.captionController,
    @required this.captionBarKey,
  })  : assert(captionBarFocusNode != null),
        assert(captionController != null),
        assert(captionBarKey != null);

  @override
  _CaptionBarState createState() => _CaptionBarState();
}

class _CaptionBarState extends State<CaptionBar> {
  Color clearIconOpacity = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      onChanged: () {
        //print(_controller.text);
        if (widget.captionController.text.isNotEmpty) {
          setState(() {
            clearIconOpacity = Colors.white;
          });
        } else if (widget.captionController.text.isEmpty) {
          setState(() {
            clearIconOpacity = Colors.transparent;
          });
        }
      },
      key: widget.captionBarKey,
      child: Container(
        color: Colors.transparent,

        // height: MediaQuery.of(context).size.height / 3,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: FormBuilderTextField(
          keyboardType: TextInputType.multiline,
          maxLines: 2,
          focusNode: widget.captionBarFocusNode,
          controller: widget.captionController,
          name: 'captionBar',
          cursorColor: Colors.white,
          cursorWidth: 1,
          style: TextStyle(fontSize: 18, color: Colors.white),
          decoration: InputDecoration(
            counterStyle: TextStyle(color: Colors.white),
            suffixIcon: GestureDetector(
              onTap: () => widget.captionController.clear(),
              child: Icon(Icons.clear, color: clearIconOpacity),
            ),
            filled: true,
            fillColor: Colors.grey[800],
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              // borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              // borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: 'Write a caption...',
            hintStyle:
                TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
          ),
          maxLength: 128,
          maxLengthEnforced: true,
          inputFormatters: [LengthLimitingTextInputFormatter(128)],
          valueTransformer: (text) => text.toString().trim(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context),
            FormBuilderValidators.minLength(context, 4),
            FormBuilderValidators.maxLength(context, 128),
          ]),
        ),
      ),
    );
  }
}
