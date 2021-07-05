import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';

import '../../../../gallery_icons_icons.dart';

class InputTags extends StatefulWidget {
  InputTags({Key key, this.tags}) : super(key: key);
  final List<String> tags;

  @override
  _InputTagsState createState() => _InputTagsState(tags);
}

class _InputTagsState extends State<InputTags> {
  TextEditingController _controller;
  List<String> tags;

  _InputTagsState(this.tags);

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 6.0,
        children: <Widget>[
          for (String tag in tags) _buildInputChips(tag),
          Container(
            margin: EdgeInsets.only(top: 6.0),
            width: 100.0,
            height: 36,
            child: TextField(
              cursorColor: AppColors.mainColorAccent,
              controller: _controller..text = '',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                hintText: 'Add',
                hintStyle: TextStyle(color: AppColors.mainColorAccent,),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppColors.mainColorAccent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: AppColors.decorationColor),
                ),
                prefixIcon: Icon(
                  Icons.add,
                  color: AppColors.mainColorAccent,
                ),
                prefixIconConstraints: BoxConstraints(
                  minHeight: 30,
                  minWidth: 30,
                ),
              ),
              onEditingComplete: () {
                {
                  setState(() {
                    if (_controller.text.isNotEmpty) {
                      tags.add(_controller.text);
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputChips(String tag) {
    return InputChip(
      padding: EdgeInsets.all(8.0),
      label: Text(
        tag,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      deleteIconColor: Colors.white,
      deleteIcon: Icon(
        GalleryIcons.cancel,
        color: AppColors.colorWhite,
      ),
      backgroundColor: AppColors.decorationColor,
      onDeleted: () {
        setState(() {
          tags.remove(tag);
        });
      },
    );
  }
}
