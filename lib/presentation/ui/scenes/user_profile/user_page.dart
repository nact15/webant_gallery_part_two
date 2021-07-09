import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webant_gallery_part_two/data/repositories/http_photo_gateway.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/generated/l10n.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_colors.dart';
import 'package:webant_gallery_part_two/presentation/resources/app_strings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/main/new_or_popular_photos.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/photos_pages/gallery_grid.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/gallery/search_photo/search_photo_bloc/search_photo_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_bloc/user_bloc.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/user_profile/user_settings.dart';
import 'package:webant_gallery_part_two/presentation/ui/scenes/widgets/loading_circular.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserModel _user;
  List<PhotoModel> photos;
  Completer<void> _reFresh;
  List<String> locales = ['en', 'ru'];

  @override
  void initState() {
    _reFresh = Completer<void>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setLocale(String lang) {
    setState(() {
      S.load(Locale.fromSubtags(languageCode: '$lang'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton(
              icon: Icon(Icons.language, color: AppColors.mainColorAccent),
              onSelected: setLocale,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context) {
                return locales.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.mainColor),
            color: Colors.black,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => UserSettings()),
            ),
            alignment: Alignment.centerRight,
          ),
        ],
        elevation: 1,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              setState(() {
                _reFresh?.complete();
                _reFresh = Completer();
              });
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is LoadingUpdate) {
              return LoadingCircular();
            }
            if (state is ErrorData) {
              return RefreshIndicator(
                color: AppColors.mainColorAccent,
                backgroundColor: AppColors.colorWhite,
                strokeWidth: 2.0,
                onRefresh: () async {
                  context.read<UserBloc>().add(UserFetch());
                  return _reFresh.future;
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    color: AppColors.colorWhite,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 220, 0, 8),
                            child: Image.asset(AppStrings.imageIntersect),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              S.of(context).errorSorry,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: AppColors.mainColorAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            S.of(context).errorLostInternetConnection,
                            style: TextStyle(color: AppColors.mainColorAccent),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            if (state is UserData) {
              _user = state.user;
              return RefreshIndicator(
                color: AppColors.mainColorAccent,
                backgroundColor: AppColors.colorWhite,
                strokeWidth: 2.0,
                onRefresh: () async {
                  context.read<UserBloc>().add(UserFetch());
                  return _reFresh.future;
                },
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverAppBar(
                          title: const Text('Floating Nested SliverAppBar'),
                          floating: true,
                          expandedHeight: 300.0,
                          snap: true,
                          forceElevated: innerBoxIsScrolled,
                        ),
                      ),
                    ];
                  },
                  body: BlocProvider(
                    create: (context) => SearchPhotoBloc(
                        HttpPhotoGateway(type: typePhoto.SEARCH_BY_USER))
                      ..add(Searching(queryText: _user.id, newQuery: false)),
                    child: Builder(builder: (BuildContext context) {
                      return GalleryGrid(
                        type: typeGrid.SEARCH,
                        crossCount: 4,
                        queryText: _user.id,
                      );
                    }),
                  ),
                ),
              );
            }
            //return Center(
            //   child: Expanded(
            //     child: Column(
            //       children: [
            //         RefreshIndicator(
            //           color: AppColors.mainColorAccent,
            //           backgroundColor: AppColors.colorWhite,
            //           strokeWidth: 2.0,
            //           onRefresh: () async {
            //             context.read<UserBloc>().add(UserFetch());
            //             return _reFresh.future;
            //           },
            //           child: SingleChildScrollView(
            //             physics: AlwaysScrollableScrollPhysics(),
            //             child: Expanded(
            //               child: Column(
            //                 children: <Widget>[
            //                   SizedBox(
            //                     height: 250,
            //                     child: Column(
            //                       children: <Widget>[
            //                         Container(
            //                           padding: const EdgeInsets.only(top: 20),
            //                           decoration: BoxDecoration(
            //                             shape: BoxShape.circle,
            //                             border: Border.all(
            //                               color: AppColors.mainColorAccent,
            //                             ),
            //                           ),
            //                           child: Center(
            //                             child: CircleAvatar(
            //                               child: Icon(
            //                                 Icons.camera_alt,
            //                                 size: 55,
            //                                 color: AppColors.mainColorAccent,
            //                               ),
            //                               radius: 50,
            //                               backgroundColor: AppColors.colorWhite,
            //                             ),
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: const EdgeInsets.only(top: 10),
            //                           child: Center(
            //                             child: Text(
            //                               _user.username,
            //                               style: TextStyle(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.w400),
            //                             ),
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsets.only(top: 10),
            //                           child: Center(
            //                             child: Text(
            //                               _dateFormatter
            //                                   .fromDate(_user.birthday),
            //                               style: TextStyle(
            //                                   fontSize: 12,
            //                                   color: AppColors.mainColorAccent),
            //                             ),
            //                           ),
            //                         ),
            //                         //Spacer(),
            //                         Padding(
            //                           padding: const EdgeInsets.fromLTRB(
            //                               16, 27, 0, 0),
            //                           child: Row(
            //                             children: [
            //                               Text(S.of(context).countOfViews +
            //                                   state.countOfViews.toString()),
            //                               Padding(
            //                                 padding: EdgeInsets.only(left: 16),
            //                                 child: Text(S
            //                                         .of(context)
            //                                         .countOfLoaded +
            //                                     state.countOfPhotos.toString()),
            //                               ),
            //                             ],
            //                           ),
            //                         ),
            //                         Container(
            //                           decoration: const BoxDecoration(
            //                             border: Border(
            //                               bottom: BorderSide(
            //                                   width: 1.0,
            //                                   color: AppColors.mainColorAccent),
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   Expanded(
            //                     child: BlocProvider(
            //                       create: (context) => SearchPhotoBloc(
            //                           HttpPhotoGateway(
            //                               type: typePhoto.SEARCH_BY_USER))
            //                         ..add(Searching(
            //                             queryText: _user.id, newQuery: false)),
            //                       child: GalleryGrid(
            //                         type: typeGrid.SEARCH,
            //                         crossCount: 4,
            //                         queryText: _user.id,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
            return Container();
          },
        ),
      ),
    );
  }
}
