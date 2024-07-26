import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/pages/comments.dart';
import 'package:ipohgo/pages/guide.dart';
import 'package:ipohgo/pages/hotel.dart';
import 'package:ipohgo/pages/restaurant.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoWidget extends StatelessWidget {
  final Place? placeData;
  const TodoWidget({Key? key, required this.placeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Experience Nearby',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            )).tr(),
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          height: 3,
          width: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(40)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            'Indulge in a perfect blend of comfort and culinary delights at our nearby hotel and restaurant'),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: GridView.count(
            padding: EdgeInsets.all(0),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              InkWell(
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.blue[200]!,
                                      offset: Offset(0, 0),
                                      blurRadius: 0)
                                ]),
                            child: Icon(
                              Symbols.hotel,
                              size: 30,
                            ),
                          ),
                          Text(
                            'nearby hotels',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ).tr(),
                        ])),
                onTap: () => nextScreen(
                    context,
                    HotelPage(
                      placeData: placeData,
                    )),
              ),
              InkWell(
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.yellow[400]!,
                                      offset: Offset(5, 5),
                                      blurRadius: 0)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(
                                Icons.restaurant,
                                size: 28,
                              ),
                            ),
                          ),
                          Text(
                            'nearby restaurants',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ).tr(),
                        ])),
                onTap: () => nextScreen(
                    context,
                    RestaurantPage(
                      placeData: placeData,
                    )),
              ),
              // InkWell(
              //   child: Container(
              //       padding: EdgeInsets.all(15),
              //       decoration: BoxDecoration(
              //         color: Colors.blueAccent,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Container(
              //               height: 50,
              //               width: 50,
              //               decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   // color: Colors.white,
              //                   boxShadow: <BoxShadow>[
              //                     BoxShadow(
              //                         color: Colors.blueAccent[400]!,
              //                         offset: Offset(5, 5),
              //                         blurRadius: 2)
              //                   ]),
              //               child: Icon(
              //                 Symbols.alt_route,
              //                 size: 30,
              //               ),
              //             ),
              //             Text(
              //               'travel guide',
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 15),
              //             ).tr(),
              //           ])),
              //   onTap: () => nextScreen(context, GuidePage(d: placeData)),
              // ),
              // InkWell(
              //   child: Container(
              //       padding: EdgeInsets.all(15),
              //       decoration: BoxDecoration(
              //         color: Colors.indigoAccent,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Container(
              //               height: 50,
              //               width: 50,
              //               decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   // color: Colors.white,
              //                   boxShadow: <BoxShadow>[
              //                     BoxShadow(
              //                         color: Colors.indigoAccent[400]!,
              //                         offset: Offset(5, 5),
              //                         blurRadius: 2)
              //                   ]),
              //               child: Icon(
              //                 Symbols.message,
              //                 size: 30,
              //               ),
              //             ),
              //             Text(
              //               'user reviews',
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 15),
              //             ).tr(),
              //           ])),
              //   onTap: () => nextScreen(
              //       context,
              //       CommentsPage(
              //         collectionName: 'places',
              //         id: placeData!.id,
              //         timestamp: placeData!.timestamp,
              //       )),
              // ),
            ],
          ),
        )
      ],
    );
  }
}
