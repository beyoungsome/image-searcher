import 'package:dio/dio.dart';
import 'package:movie_app/constants/movie_db_provider_const.dart';
import 'package:movie_app/data/PhotoResponse.dart';
import 'package:movie_app/data/provider/photos_notifier.dart';

class PhotoDBProvider {
  void discoverPhotos({String query}) async {
    try {
      Response response = await Dio().get(
          '$UNSPLASH_BASE_URL/photos/random',
          queryParameters: {CLIENT_ID: UNSPLASH_ACCESS_KEY, COUNT: "30", QUERY: query});
      List<PhotoResponse> photos = [];
      for (dynamic photo in response.data) {
        photos.add(PhotoResponse.fromJson(photo));
      }
      photosNotifier.photos = photos;
    } catch (e) {
      print(e);
    }
  }

  void searchPhotos() async {
    try {
      Response response = await Dio().get(
          '$UNSPLASH_BASE_URL/photos/random',
          queryParameters: {CLIENT_ID: UNSPLASH_ACCESS_KEY, COUNT: "30"});
      List<PhotoResponse> photos = [];
      for (dynamic photo in response.data) {
        photos.add(PhotoResponse.fromJson(photo));
      }
      photosNotifier.photos = photos;
    } catch (e) {
      print(e);
    }
  }

}

PhotoDBProvider photoDBProvider = PhotoDBProvider();
