import 'package:flutter/material.dart';
import 'package:movie_app/data/PhotoResponse.dart';

class PhotosNotifier extends ChangeNotifier {
  List<PhotoResponse> _photos = [];

  List<PhotoResponse> get photos => _photos;
  set photos(List<PhotoResponse> newMovies) {
    _photos.clear();
    _photos.addAll(newMovies);
    notifyListeners();
  }
}

PhotosNotifier photosNotifier = PhotosNotifier();
