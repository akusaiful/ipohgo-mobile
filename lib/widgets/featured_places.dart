import 'package:dots_indicator/dots_indicator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/blocs/featured_bloc.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/pages/place_details.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/widgets/custom_cache_image.dart';
import 'package:ipohgo/utils/loading_cards.dart';

class Featured extends StatefulWidget {
  Featured({Key? key}) : super(key: key);

  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  @override
  Widget build(BuildContext context) {
    final fb = context.watch<FeaturedBloc>();
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 260,
          width: w,
          child: PageView.builder(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            itemCount: fb.data.isEmpty ? 1 : fb.data.length,
            onPageChanged: (index) {
              context.read<FeaturedBloc>().setListIndex(index);
            },
            itemBuilder: (BuildContext context, int index) {
              // if(fb.data.isEmpty) return LoadingFeaturedCard();
              // return _FeaturedItemList(d: fb.data[index]);
              if (fb.data.isEmpty) {
                if (fb.hasData == false) {
                  return _EmptyContent();
                } else {
                  return LoadingFeaturedCard();
                }
              }
              return _FeaturedItemList(d: fb.data[index]);
            },
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Center(
          child: DotsIndicator(
            dotsCount: fb.data.isEmpty ? 1 : fb.data.length,
            position: context.watch<FeaturedBloc>().listIndex,
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
              spacing: EdgeInsets.only(left: 6),
              size: const Size.square(5.0),
              activeSize: const Size(20.0, 4.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        )
      ],
    );
  }
}

class _FeaturedItemList extends StatelessWidget {
  final Place d;
  const _FeaturedItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    print('Build');
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: w,
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'featured${d.timestamp}',
              child: Container(
                  height: 220,
                  width: w,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomCacheImage(imageUrl: d.featuredImage))),
            ),
            Positioned(
              height: 100,
              width: w * 0.80,
              left: w * 0.05,
              bottom: 10,
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          // color: Colors.grey[300]!,
                          color: Theme.of(context).shadowColor,
                          offset: Offset(0, 2),
                          blurRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Expanded(
                      //   child: Text(
                      //     d.name!,
                      //     style: TextStyle(
                      //         fontSize: 16, fontWeight: FontWeight.w600),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),

                      Text(
                        d.name!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Expanded(
                      //   child: Text(
                      //     d.location!,
                      //     style: TextStyle(
                      //         fontSize: 13, fontWeight: FontWeight.w400),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // Icon(
                          //   Icons.location_on,
                          //   size: 16,
                          //   color: Colors.grey,
                          // ),
                          Expanded(
                            child: Text(
                              d.location!,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                        height: 20,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              LineIcons.heart,
                              size: 18,
                              // color: Colors.grey[800],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              d.loves.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                // color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Icon(
                              EvaIcons.messageSquareOutline,
                              size: 18,
                              // color: Colors.grey[800],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              d.commentsCount.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                // color: Colors.grey[700],
                              ),
                            ),
                            // Spacer(),
                            SizedBox(
                              width: 30,
                            ),
                            Icon(
                              EvaIcons.activity,
                              color: Colors.green,
                              size: 18,
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          nextScreen(
              context, PlaceDetails(data: d, tag: 'featured${d.timestamp}'));
        },
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 220,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text("No contents found!"),
      ),
    );
  }
}
