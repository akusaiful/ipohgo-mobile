import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/blocs/recent_places_bloc.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/pages/more_places.dart';
import 'package:ipohgo/pages/place_details.dart';
import 'package:ipohgo/theme/theme_data.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/widgets/custom_cache_image.dart';
import 'package:ipohgo/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class RecentPlaces extends StatelessWidget {
  RecentPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rb = context.watch<RecentPlacesBloc>();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 20, right: 10),
          child: Row(
            children: <Widget>[
              Text('recently added',
                      style: CustomTextStyle.headerWidgetHome(context))
                  .tr(),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => nextScreen(
                    context,
                    MorePlacesPage(
                      title: 'recently',
                      color: Colors.blueGrey[600],
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
            itemCount: rb.data.isEmpty ? 3 : rb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (rb.data.isEmpty) return LoadingPopularPlacesCard();
              return _ItemList(
                d: rb.data[index],
              );
            },
          ),
        )
      ],
    );
  }
}

class _ItemList extends StatelessWidget {
  final Place d;
  const _ItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.60,
        decoration: BoxDecoration(
          // color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: d.id!,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      child: CustomCacheImage(imageUrl: d.bannerImage)),
                )),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.name!,
                    maxLines: 1,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
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
                          d.location!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            // color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        EvaIcons.checkmarkCircle,
                        color: Colors.green,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          d.category.toString(),
                          // maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          // softWrap: false,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                      )
                    ],
                  )
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
      onTap: () => nextScreen(
          context, PlaceDetails(data: d, tag: 'recent${d.timestamp}')),
    );
  }
}
