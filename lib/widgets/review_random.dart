import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/models/comment.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/pages/comments.dart';
import 'package:ipohgo/theme/theme_data.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';

class ReviewRandom extends StatelessWidget {
  final Place? place;
  ReviewRandom({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final rb = context.watch<ReviewsBloc>();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 20, right: 10),
          child: Row(
            children: <Widget>[
              Text('What they say',
                      style: CustomTextStyle.headerWidgetHome(context))
                  .tr(),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => nextScreen(
                    context,
                    CommentsPage(
                      collectionName: 'places',
                      id: place!.id,
                      timestamp: place!.timestamp,
                    )),
              )
            ],
          ),
        ),
        Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: place!.reviews!.isEmpty ? 3 : place!.reviews!.length,
            itemBuilder: (BuildContext context, int index) {
              if (place!.reviews!.isEmpty) return LoadingPopularPlacesCard();
              return _ItemList(
                d: place!.reviews![index],
              );
            },
          ),
        )
      ],
    );
  }
}

class _ItemList extends StatelessWidget {
  final Comment d;
  const _ItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.60,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //     height: 180,
            //     width: MediaQuery.of(context).size.width,
            //     child: Hero(
            //       tag: d.uid!,
            //       child: ClipRRect(
            //           borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(5),
            //               topRight: Radius.circular(5)),
            //           child: CustomCacheImage(imageUrl: d.imageUrl)),
            //     )),
            CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: CachedNetworkImageProvider(d.imageUrl!)),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Icon(
                      //   Feather.map_pin,
                      //   size: 16,
                      //   color: Colors.grey,
                      // ),
                      // SizedBox(
                      //   width: 6,
                      // ),
                      Expanded(
                        child: Text(
                          d.comment!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '- ' + d.name!,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       EvaIcons.checkmarkCircle,
                  //       color: Colors.green,
                  //       size: 20,
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Expanded(
                  //       child: Text(
                  //         d.category.toString(),
                  //         // maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         // softWrap: false,
                  //         style: TextStyle(
                  //             fontSize: 15,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.grey),
                  //       ),
                  //     )
                  //   ],
                  // )
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Icon(
                  //       CupertinoIcons.time,
                  //       size: 16,
                  //       color: Colors.grey[700],
                  //     ),
                  //     SizedBox(
                  //       width: 6,
                  //     ),
                  //     Text(
                  //       'Last Updated : ' + d.date!,
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         fontStyle: FontStyle.italic,
                  //         color: Colors.grey[700],
                  //       ),
                  //     ),
                  //     Spacer(),
                  //     Icon(
                  //       LineIcons.heart,
                  //       size: 16,
                  //       color: Colors.grey,
                  //     ),
                  //     SizedBox(
                  //       width: 3,
                  //     ),
                  //     Text(
                  //       d.loves.toString(),
                  //       style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Icon(
                  //       LineIcons.comment,
                  //       size: 16,
                  //       color: Colors.grey,
                  //     ),
                  //     SizedBox(
                  //       width: 3,
                  //     ),
                  //     Text(
                  //       d.commentsCount.toString(),
                  //       style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
      // onTap: () => nextScreen(
      //     context, PlaceDetails(data: d, tag: 'recent${d.timestamp}')),
    );
  }
}
