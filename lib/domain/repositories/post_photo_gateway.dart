import 'dart:io';

abstract class PostPhotoGateway{
  Future<void> postPhoto({File file, String name});
}