import 'package:Kide/pages/HomePage/PostDetailsPage.dart';
import 'package:Kide/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class PostCard extends StatefulWidget {
  String title, subtitle, image, body, id, views, likes, postType;
  final date;

  PostCard(
      {this.id,
      this.title,
      this.subtitle,
      this.image,
      this.body,
      this.date,
      this.likes,
      this.views,
      this.postType});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked, isSaved;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = (widget.date as Timestamp).toDate();
    String formattedDate = DateFormat.yMMMd().format(date);
    final deviceHeight = MediaQuery.of(context).size.height;
    return Card(
      color: DynamicTheme.of(context).data.cardColor,
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailsPage(
                        id: widget.id,
                        postType: widget.postType,
                        body: widget.body,
                        title: widget.title,
                        subtitle: widget.subtitle,
                        date: formattedDate.toString(),
                        image: widget.image,
                        likes: widget.likes,
                        views: widget.views,
                      )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.image != null
                ? Stack(
                    children: <Widget>[
                      Hero(
                        tag: widget.image,  // Any tag that needs to be unique like URL of image.
                        child: Container(
                          height: deviceHeight * 0.32,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: widget.image,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Image.asset(
                                    POSTCARD_IMAGE_PLACEHOLDER_ASSET_PNG,
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.32,
                                  width: double.infinity,
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.grey.withOpacity(0.5),
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                            errorWidget: (context, url, error) => SizedBox(
                              child: Icon(Icons.warning),
                              width: 90,
                              height: 90,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: deviceHeight * 0.32,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.center,
                                colors: [
                                  Colors.black.withOpacity(0.55),
                                  Colors.black.withOpacity(0.15)
                                ],
                                stops: [
                                  0.5,
                                  3
                                ])),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: deviceHeight * 0.125,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 3),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  height: 1.25,
                                  fontSize: deviceHeight * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: deviceHeight * 0.023,
                          color: Colors.black),
                    ),
                  ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.subtitle != null ? widget.subtitle : widget.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: deviceHeight * 0.021),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: deviceHeight * 0.023),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${widget.views.toString()} Views",
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: deviceHeight * 0.023),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
