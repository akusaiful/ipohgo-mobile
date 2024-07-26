import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipohgo/blocs/random_review_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/models/review.dart';
import 'package:ipohgo/pages/more_places.dart';
import 'package:ipohgo/pages/place_details.dart';
import 'package:ipohgo/theme/theme_data.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ipohgo/widgets/custom_cache_image.dart';

/*
 * Home 
 */
class HomeRandomReview extends StatelessWidget {
  HomeRandomReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pb = context.watch<RandomReviewBloc>();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 15, right: 10),
          child: Row(
            children: <Widget>[
              Icon(
                EvaIcons.arrowheadRight,
                size: 20,
              ),
              Text(
                'Review from our visitor',
                style: CustomTextStyle.headerWidgetHome(context),
              ).tr(),
              Spacer(),

              // IconButton(
              //   icon: Icon(Icons.arrow_forward),
              //   onPressed: () => nextScreen(
              //       context,
              //       MorePlacesPage(
              //         title: 'popular',
              //         color: Colors.grey[800],
              //       )),
              // )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 320,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: pb.data.isEmpty ? 3 : pb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (pb.data.isEmpty) return LoadingPopularPlacesCard();
              return _ItemList(
                d: pb.data[index],
              );
            },
          ),
        )
      ],
    );
  }
}

class _ItemList extends StatelessWidget {
  final Review d;
  const _ItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.60,
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: d.id!,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child:
                              CustomCacheImage(imageUrl: d.place!.bannerImage)),
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 40),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[50],
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            CachedNetworkImageProvider(d.avatarUrl!)),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 2,
                    // ),
                    // Expanded(
                    //   child: Center(
                    //     child: Text(
                    //       d.place!.name!,
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //       style:
                    //           TextStyle(fontSize: 15, color: Colors.grey[700]),
                    //     ),
                    //   ),
                    // ),
                    Text(
                      d.place!.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Center(
                            child: Text(
                              d.content!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      d.author! + ' Visit on ' + d.createdAt!,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
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
            ),
          ],
        ),
      ),
      onTap: () => nextScreen(
          context, PlaceDetails(data: d.place, tag: 'recent${d.createdAt}')),
    );
  }
}
