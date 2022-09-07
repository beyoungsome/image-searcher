import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_app/data/PhotoResponse.dart';
import 'package:movie_app/data/provider/photos_notifier.dart';
import 'package:movie_app/repository/photo_db_provider.dart';
import 'package:movie_app/widgets/poster_2nd.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
//import 'package:wallpaper_manager/wallpaper_manager.dart';

import 'detail_page.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({Key key}) : super(key: key);

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  //static const _itemsLength = 50;
  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();
  final _searchController = TextEditingController();
  String title = '';
  File _displayImage;

  //static Size size;
  // late List<MaterialColor> colors;
  // late List<String> songNames;

  @override
  void initState() {
    _setData();
    super.initState();
    photoDBProvider.discoverPhotos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setData() {
    // colors = getRandomColors(_itemsLength);
    // songNames = getRandomNames(_itemsLength);
    photoDBProvider.discoverPhotos(query: _searchController.value.text);
  }

  Future<void> _refreshData() async {
    return setState(() => _setData());
  }

  // Future<void> _refreshData() {
  //   return Future.delayed(
  //     // This is just an arbitrary delay that simulates some network activity.
  //     const Duration(seconds: 2),
  //         () => setState(() => _setData()),
  //   );
  // }

  Widget build(BuildContext context) {
    //size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<PhotosNotifier>.value(
      value: photosNotifier,
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: RefreshIndicator(
              key: _androidRefreshKey,
              onRefresh: _refreshData,
              child: Consumer<PhotosNotifier>(
                  builder: (context, photosNotifier, child) {
                    if (photosNotifier.photos.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<PhotoResponse> photoResponse = photosNotifier
                        .photos; //photosNotifier.photos[pageNotifier.value.floor()];
                    return Column(
                      children: [
                        TextFormField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.search,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              hintText: '이미지를 검색해 보세요',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                // color: Palette.textColor1
                              ),
                              contentPadding: EdgeInsets.all(10)),
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                          onFieldSubmitted: (data) {
                            data = _searchController.value.text;
                            photoDBProvider.discoverPhotos(query: data);
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //itemExtent: photosNotifier.photos.length.toDouble(),
                            //padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: photosNotifier.photos.length,
                            itemBuilder: _listBuilder,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    //if (index >= _itemsLength) return Container();

    return SafeArea(
      top: false,
      bottom: false,
      child: Consumer<PhotosNotifier>(
        builder: (context, photosNotifier, child) {
          return GestureDetector(
            onTap: () {
              _showDownloadPhotoConfirmationDialog(
                  photoResponse: photosNotifier.photos[index]
              );
            },
            onLongPress: () {
              Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 700),
                  pageBuilder: (_, __, ___) =>
                      DetailPage(photosNotifier.photos[index])
              ));
            },
            child: Hero(
              tag: photosNotifier.photos[index].urls.regular,
              child: Poster2nd(
                // scale: scale,
                img: photosNotifier.photos[index].urls.regular,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDownloadPhotoConfirmationDialog(
      {PhotoResponse photoResponse}) {
    print("logging01: _showDialog: " + photoResponse.urls.regular);
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('[앨범에 저장하기]',
            style: TextStyle(color: Colors.black87),),
          content: const Text('이 사진을 저장하시겠습니까?',
            style: TextStyle(color: Colors.black87),),
          actionsPadding: EdgeInsets.symmetric(horizontal: 50.0),
          actions: [
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                _downloadPhoto(photoResponse.urls.regular);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadPhoto(String urlData) async {

    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    try{
      Uri myUri = Uri.parse(urlData);
      final response = await http.get(myUri);
      print("logging02: response.statusCode: " + response.statusCode.toString());
      if(response.statusCode == 200){
        //final imageName = "download.img";
        final imageName = path.basename(urlData);
        final appDir = await pathProvider.getApplicationDocumentsDirectory();
        //final appDir = "/storage/emulated/0/Pictures/";
        //final localPath = path.join(appDir, imageName);
        final localPath = path.join(appDir.path, imageName);
        print("logging03: localPath: " + localPath.toString());
        final imageFile = File(localPath);
        await imageFile.writeAsBytes(response.bodyBytes);
        print("logging03: imageFile: " + imageFile.toString());
        setState(() {
          _displayImage = imageFile;
        });
        // await WallpaperManager.setWallpaperFromFile(
        //     imageFile.path, WallpaperManager.HOME_SCREEN);
      } else {
        print("logging[!==200] " + response.statusCode.toString());
      }
    } catch (ex) {
      print("logging[error] " + ex);
    }
    //GallerySaver.saveImage(urlData);
    //ImageDownloader.downloadImage(urlData);

  }

  Future<void> _downloadPhoto2(String urlData) async {

    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    try{
      Uri myUri = Uri.parse(urlData);
      final response = await http.get(myUri);
      print("logging02: response: " + response.statusCode.toString());
      if(response.statusCode == 200){
        //final imageName = "download.img";
        final imageName = path.basename(urlData);

        final appDir = await pathProvider.getApplicationDocumentsDirectory();
        final localPath = path.join(appDir.path, imageName);
        print("logging03: _showDialog: " + localPath.toString());
        Uint8List data = response.bodyBytes;
        var bytes = ByteData.view(data.buffer);
        final buffer = bytes.buffer;
        final imageFile = File(localPath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        // final imageFile = File(localPath);
        // await imageFile.writeAsBytes(response.bodyBytes);
        setState(() {
          _displayImage = imageFile as File;
        });
      } else {
        print("logging[!==200] " + response.statusCode.toString());
      }
    } catch (ex) {
      print("logging[error] " + ex);
    }
    //GallerySaver.saveImage(urlData);
    //ImageDownloader.downloadImage(urlData);

  }

  // Future<void> saveImageF(String ImagDetails) async {
  //   String imgPath = (imageLinkInAssets).substring(7);
  //
  //   late File image;
  //   await getImageFileFromAssets(imgPath).then((file) => image = file);
  //
  //   final extDir = await getExternalStorageDirectory();
  //
  //
  //   //  Path of file in android data files
  //   final myImagePath = '${extDir!.path}/images';
  //
  //
  //   //create the base name
  //   String basename = (ImagDetails).substring(20);
  //
  //   // File copied to ext directory.
  //   File newImage = await image.copy("$myImagePath/${p.basename(basename)}");
  //
  //   print(newImage.path);
  // }



}