import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/photos_pages/single_photo.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/search_photo/search_photo_bloc/search_photo_bloc.dart';
import 'package:provider/provider.dart';
class SearchGrid extends StatefulWidget {
  const SearchGrid({Key key, this.photos, this.queryText}) : super(key: key);
  final List<PhotoModel> photos;
  final String queryText;

  @override
  _SearchGridState createState() => _SearchGridState(photos, queryText);
}

class _SearchGridState extends State<SearchGrid> {
  _SearchGridState(this.photos, this.queryText);
ScrollController scrollController;
  List<PhotoModel> photos;
  String queryText;
  bool _isLastPage = false;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }
  _scrollListener() {
    if (!_isLastPage) {
      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        context.read<SearchPhotoBloc>().add(Searching(queryText: queryText, newQuery: false));
     }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchPhotoBloc, SearchPhotoState>(
  listener: (context, state) {
    if (state is Search) {
      if (state.isLastPage) {
        setState(() {
          _isLastPage = true;
        });
      }
    }
  },
  child: CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (c, i) => Container(
                child: GestureDetector(
                  onTap: () => _toScreenInfo(photos[i]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Hero(
                      tag: photos[i].id,
                      child: photos[i].isPhotoSVG()
                          ? SvgPicture.network(photos[i].getImage())
                          : CachedNetworkImage(
                              imageUrl: photos[i].getImage(),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              childCount: photos.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: _isLastPage
                    ? null
                    :CircularProgressIndicator(
                  color: AppColors.mainColorAccent,
                  strokeWidth: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
);
  }

  void _toScreenInfo(PhotoModel photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenInfo(photo: photo),
      ),
    );
  }
}
