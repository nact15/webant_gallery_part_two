import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webant_gallery_part_two/domain/models/photos_model/photo_model.dart';
import 'package:webant_gallery_part_two/domain/models/user/user_model.dart';
import 'package:webant_gallery_part_two/domain/repositories/firestore_repository.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {


  final FirestoreRepository _firestoreRepository;
  StreamSubscription _countSubscription;
  StreamSubscription _countUserSubscription;

  FirestoreBloc({FirestoreRepository firestoreRepository})
      : _firestoreRepository = firestoreRepository,
        super(FirestoreInitial());
  @override
  Stream<FirestoreState> mapEventToState(
    FirestoreEvent event,
  ) async* {

    if (event is UserViewsCounter) {
      _countUserSubscription?.cancel();
      _countUserSubscription = _firestoreRepository.getViewsCountOfUserPhoto(event.user).listen(
            (count) => add(UserCountUpdated(count)),
      );
    }
    if (event is UserCountUpdated){
      yield CountOfUserViews(event.count);
    }
  }
}
