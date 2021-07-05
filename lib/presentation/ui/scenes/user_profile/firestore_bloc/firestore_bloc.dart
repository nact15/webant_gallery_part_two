import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/firestore_repository.dart';
import 'package:webant_gallery_part_two/domain/repositories/oauth_gateway.dart';
import 'package:webant_gallery_part_two/domain/repositories/user_gateway.dart';

part 'firestore_event.dart';

part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreRepository _firestoreRepository;
  StreamSubscription _countUserSubscription;
  UserModel _user;
  final UserGateway _userGateway;
  final OauthGateway _oauthGateway;

  FirestoreBloc(this._userGateway, this._oauthGateway,
      {OauthGateway oauthGateway, FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(FirestoreInitial());

  @override
  Stream<FirestoreState> mapEventToState(
    FirestoreEvent event,
  ) async* {
    if (event is UserViewsCounter) {
      _user = await _oauthGateway.getUser();
      _countUserSubscription?.cancel();
      _countUserSubscription =
          _firestoreRepository.getViewsCountOfUserPhoto(_user).listen(
                (count) => add(UserCountUpdated(count)),
              );
    }
    if (event is UserCountUpdated) {
      yield CountOfUserViews(event.count);
    }
    if (event is GetTags) {
      String userName;
      if (event.photo.user != null) {
        userName = await _userGateway.getUserName(event.photo.user);
      }
      List<dynamic> tags = await _firestoreRepository.getTags(event.photo);
      yield ShowTags(tags, userName );
    }
  }
}
