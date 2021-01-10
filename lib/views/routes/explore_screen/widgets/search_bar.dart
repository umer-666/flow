import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// ignore:must_be_immutable

class SearchBar extends StatefulWidget {
  final FocusNode searchBarFocusNode;
  final GlobalKey searchBarKey;
  final TextEditingController searchController;
  SearchBar(
      {@required this.searchBarFocusNode,
      @required this.searchBarKey,
      @required this.searchController});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // final _searchBarKey = GlobalKey<FormBuilderState>();
  // final _searchController = TextEditingController();
  Color clearIconOpacity = Colors.transparent;
  @override
  void dispose() {
    widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      onChanged: () {
        //print(_controller.text);
        if (widget.searchController.text.isNotEmpty) {
          setState(() {
            clearIconOpacity = Colors.white;
          });
        } else if (widget.searchController.text.isEmpty) {
          setState(() {
            clearIconOpacity = Colors.transparent;
          });
        }
      },
      key: widget.searchBarKey,
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: EdgeInsets.fromLTRB(48, 6, 10, 6),
        child: FormBuilderTextField(
          focusNode: widget.searchBarFocusNode,
          controller:widget.searchController,
          name: 'searchBar',
          cursorColor: Colors.white,
          cursorWidth: 1,
          style: TextStyle(fontSize: 18, color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () => widget.searchController.clear(),
              child: Icon(Icons.clear, color: clearIconOpacity),
            ),
            filled: true,
            fillColor: Colors.grey[800],
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              // borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              // borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: 'Search',
            hintStyle:
                TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
          ),
          valueTransformer: (text) => text.toString().trim(),
          validator: FormBuilderValidators.compose([
            //FormBuilderValidators.required(context),
            //FormBuilderValidators.minLength(context, 4),
            //FormBuilderValidators.maxLength(context, 16),
          ]),
        ),
      ),
    );
  }
}
