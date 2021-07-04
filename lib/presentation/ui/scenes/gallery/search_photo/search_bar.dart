import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key key, this.searchController}) : super(key: key);
  final TextEditingController searchController;

  @override
  _SearchBarState createState() => _SearchBarState(searchController);
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState(this._searchController);

  TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextFormField(
        cursorColor: AppColors.mainColorAccent,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.colorOfSearchBar,
          contentPadding: EdgeInsets.all(8),
          hintText: 'Search',
          hintStyle: TextStyle(
            fontSize: 17,
            color: AppColors.mainColorAccent,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.mainColorAccent,
          ),
          suffixIcon: _searchController.text.isEmpty ? null :
          IconButton(
            icon: Icon(Icons.cancel_outlined),
            onPressed: () => _searchController.clear(),
            color: AppColors.mainColorAccent,
          ),
          suffixStyle: TextStyle(),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColors.decorationColor)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.colorWhite),
          ),
        ),
        controller: _searchController,
      ),
    );
  }
}
