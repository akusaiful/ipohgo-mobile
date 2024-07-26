import 'dart:async';
import 'dart:convert';

import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ipohgo/blocs/ads_bloc.dart';
import 'package:ipohgo/blocs/bookmark_bloc.dart';
import 'package:ipohgo/blocs/sign_in_bloc.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/utils/sign_in_dialog.dart';
import 'package:ipohgo/widgets/comment_count.dart';
import 'package:ipohgo/widgets/exclude.dart';
import 'package:ipohgo/widgets/faq.dart';
import 'package:ipohgo/widgets/include.dart';
import 'package:ipohgo/widgets/love_count.dart';
import 'package:ipohgo/widgets/love_icon.dart';
import 'package:ipohgo/widgets/maps.dart';
import 'package:ipohgo/widgets/other_places.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/widgets/parking.dart';
import 'package:ipohgo/widgets/popular_places.dart';
import 'package:ipohgo/widgets/reviews.dart';
import 'package:ipohgo/widgets/todo.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:http/http.dart' as http;

import '../widgets/html_body.dart';

class PlaceDetails extends StatefulWidget {
  final Place? data;
  final String? tag;
  // final RecommandedPlacesBloc rpb;

  const PlaceDetails({Key? key, required this.data, required this.tag})
      : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  // final String collectionName = 'places';
  final String collectionName = 'tour';

  int? totalLike = 0;
  int? totalView = 0;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  late GoogleMapController mapController;

  // final LatLng _center =
  //     new LatLng(widget.data!.latitude!, widget.data!.longitude!);

  @override
  void initState() {
    super.initState();
    totalLike = widget.data!.loves;
    // rpb = widget.rpb;
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      context.read<AdsBloc>().initiateAds();
    });
    updateSeen();
  }

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;
    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onLoveIconClickHandle(collectionName, widget.data!.id, totalLike)
          .then((value) {
        // print('Here ' + value.toString());
        setState(() {
          totalLike = value;
        });
      });
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;
    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBloc>()
          .onBookmarkIconClickHandle(collectionName, widget.data!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = context.watch<SignInBloc>();

    // final RecommandedPlacesBloc rpb =
    //     Provider.of<RecommandedPlacesBloc>(context);

    // print('Name ' + rpb.data[0].name.toString());
    // rpb.data[0].name = 'test';
    // print(rpb.data[0].name);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                widget.tag == null
                    ? _slidableImages()
                    : Hero(
                        tag: widget.tag!,
                        child: _slidableImages(),
                      ),
                Positioned(
                  top: 20,
                  left: 15,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          LineIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 8, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          EvaIcons.shake,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        widget.data!.location!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      IconButton(
                          icon: BuildLoveIcon(
                              collectionName: collectionName,
                              uid: sb.id,
                              objectId: widget.data!.id!,
                              timestamp: widget.data!.timestamp),
                          onPressed: () {
                            handleLoveClick();
                          }),
                      // IconButton(
                      //     icon: BuildBookmarkIcon(
                      //         collectionName: collectionName,
                      //         uid: sb.uid,
                      //         objectId: widget.data!.id!,
                      //         timestamp: widget.data!.timestamp),
                      //     onPressed: () {
                      //       handleBookmarkClick();
                      //     }),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(widget.data!.name!,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          // letterSpacing: 0,
                          wordSpacing: 1,
                          height: 1.2,
                          // color: Colors.grey[800],
                        )),
                  ),

                  // Container(
                  //   margin: EdgeInsets.only(top: 8, bottom: 8),
                  //   height: 3,
                  //   width: 300,
                  //   decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: BorderRadius.circular(40)),
                  // ),
                  Row(
                    children: <Widget>[
                      LoveCount(
                        collectionName: collectionName,
                        id: widget.data!.id,
                        totalLike: totalLike,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        EvaIcons.messageSquare,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CommentCount(
                        collectionName: collectionName,
                        id: widget.data!.id,
                      ),
                      SizedBox(
                        width: 20,
                      ),
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
                          widget.data!.category.toString(),
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
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        EvaIcons.eye,
                        color: Colors.blue[400],
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        totalView.toString() + ' People views this location',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(color: Colors.grey[600]),
                ],
              ),
            ),

            // Stack(
            //   children: [
            //     GoogleMap(
            //       mapType: MapType.hybrid,
            //       // initialCameraPosition: _kGooglePlex,
            //       // onMapCreated: (GoogleMapController controller) {
            //       //   _controller.complete(controller);
            //       // },
            //       initialCameraPosition: CameraPosition(
            //         target: _center,
            //         zoom: 11.0,
            //       ),
            //       onMapCreated: _onMapCreated,
            //     )
            //   ],
            // ),
            HtmlBodyWidget(
              content: widget.data!.content.toString(),
              isIframeVideoEnabled: true,
              isVideoEnabled: true,
              isimageEnabled: true,
              fontSize: null,
            ),
            Maps(data: widget.data),
            Padding(
              padding: EdgeInsets.all(20),
              child: TodoWidget(placeData: widget.data),
            ),
            // RecentPlaces(),
            Reviews(place: widget.data),
            Padding(
              padding: EdgeInsets.all(20),
              child: IncludeWidget(placeData: widget.data),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ExcludeWidget(placeData: widget.data),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Divider(color: Colors.black38),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: FaqWidget(placeData: widget.data),
            ),
            Parking(
              place: widget.data,
            ),
            PopularPlaces(),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 0, bottom: 40),
              child: OtherPlaces(
                stateName: widget.data!.state,
                timestamp: widget.data!.timestamp,
                catId: widget.data!.categoryId,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _slidableImages() {
    return Container(
      color: Colors.white,
      child: Container(
        height: 320,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Carousel(
          dotBgColor: Colors.transparent,
          showIndicator: true,
          dotSize: 5,
          dotSpacing: 15,
          boxFit: BoxFit.cover,
          // images: [
          //   CustomCacheImage(imageUrl: widget.data!.imageUrl1),
          //   CustomCacheImage(imageUrl: widget.data!.imageUrl2),
          //   CustomCacheImage(imageUrl: widget.data!.imageUrl3),
          // ],
          images: widget.data!.sliders!,
        ),
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  Future<Null> updateSeen() async {
    final uri = Uri.http(
        Api.domain, Api.path + '/tour/seen/' + widget.data!.id.toString());
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var snap = jsonDecode(response.body);
      var data = snap['data'];

      setState(() {
        totalView = data['views'];
        print('Total view ' + totalView.toString());
      });
    }
  }
}
