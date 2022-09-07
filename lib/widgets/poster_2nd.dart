import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/helpers/image_path_helper.dart';

class Poster2nd extends StatelessWidget {
  const Poster2nd({
    Key key,
    @required this.img,
  }) : super(key: key);

  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.zero, bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 16.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  0, // horizontal, move right 10
                  10.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: img,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) {
                print(error);
                return Icon(Icons.error);
              },
              fit: BoxFit.fill,
            ),
          )),
    );
  }
}
