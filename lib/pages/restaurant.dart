import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:ipohgo/blocs/ads_bloc.dart';
import 'package:ipohgo/config/config.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/models/restaurant.dart';
import 'package:ipohgo/services/map_service.dart';
import 'package:ipohgo/utils/convert_map_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class RestaurantPage extends StatefulWidget {
  final Place? placeData;
  RestaurantPage({Key? key, required this.placeData}) : super(key: key);

  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late GoogleMapController _controller;
  List<Restaurant> _alldata = [];
  PageController? _pageController;
  int? prevPage;
  List _markers = [];
  late Uint8List _customMarkerIcon;

  void openEmptyDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                Text("we didn't find any nearby restaurants in this area").tr(),
            title: Text(
              'no restaurants found',
              style: TextStyle(fontWeight: FontWeight.w700),
            ).tr(),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Future getData() async {
    http.Response response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json' +
            '?location=${widget.placeData!.latitude},${widget.placeData!.longitude}' +
            '&radius=3000' +
            // '&type=restaurant' +
            '&keyword=restaurant' +
            '&key=${Config().mapAPIKey}'));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      final List _rawData = decodedData['results'];
      if (_rawData.isEmpty) {
        openEmptyDialog();
      } else {
        _alldata = _rawData.map((m) => Restaurant.fromJson(m)).toList();
        _alldata.sort((a, b) => b.rating.compareTo(a.rating));
      }
    }
  }

  setMarkerIcon() async {
    _customMarkerIcon =
        await getBytesFromAsset(Config().restaurantPinIcon, 100);
  }

  _addMarker() {
    for (var data in _alldata) {
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(data.name!),
            position: LatLng(data.lat!, data.lng!),
            infoWindow: InfoWindow(title: data.name, snippet: data.address),
            icon: BitmapDescriptor.fromBytes(_customMarkerIcon),
            onTap: () {}));
      });
    }
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      context.read<AdsBloc>().initiateAds();
    });

    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    setMarkerIcon();
    getData().then((value) {
      animateCameraAfterInitialization();
      _addMarker();
    });
  }

  _restaurantList(index) {
    final String _photoUrl = _alldata[index].photoReference != null
        ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${_alldata[index].photoReference}&key=${Config().mapAPIKey}'
        : Config.emptyImage;
    return AnimatedBuilder(
        animation: _pageController!,
        builder: (BuildContext context, Widget? widget) {
          double value = 1;
          if (_pageController!.position.haveDimensions) {
            value = _pageController!.page! - index;
            value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
          }
          return Center(
            child: SizedBox(
              height: Curves.easeInOut.transform(value) * 140.0,
              width: Curves.easeInOut.transform(value) * 350.0,
              child: widget,
            ),
          );
        },
        child: InkWell(
          onTap: () {
            _onCardTap(index, _photoUrl);
          },
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.grey[300]!, blurRadius: 5)
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 10,
                  ),
                  padding: EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height,
                  width: 110,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 0.5, color: Colors.grey[500]!),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(_photoUrl),
                          fit: BoxFit.cover)),
                ),
                Flexible(
                  child: Wrap(
                    children: [
                      Container(
                        height: 10,
                      ),
                      Text(
                        _alldata[index].name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _alldata[index].address!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 20,
                            width: 90,
                            child: ListView.builder(
                              itemCount: _alldata[index].rating.round(),
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Icon(
                                  LineIcons.starAlt,
                                  color: Colors.orangeAccent,
                                  size: 16,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '(${_alldata[index].rating})',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _onCardTap(index, _photoUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 10, right: 5),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(_photoUrl),
                                fit: BoxFit.cover)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                              ),
                            ),
                            onTap: () => Navigator.pop(context)),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _alldata[index].name!,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.orangeAccent,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                _alldata[index].address!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.orangeAccent,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Rating : ${_alldata[index].rating}/5',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.opacity,
                              color: Colors.orangeAccent,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _getRating(index)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(10)),
                          icon: Icon(
                            LineIcons.directions,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Get Directions',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => MapService.openMap(
                              _alldata[index].lat!,
                              _alldata[index].lng!,
                              _alldata[index].placeId!,
                              context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Expanded _getRating(index) {
    return Expanded(
        child: Text(
      _alldata[index].price == 0
          ? 'Price : Moderate'
          : _alldata[index].price == 1
              ? 'Price : Inexpensive'
              : _alldata[index].price == 2
                  ? 'Price : Moderate'
                  : _alldata[index].price == 3
                      ? 'Price : Expensive'
                      : 'Price : Very Expensive',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              compassEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: Config().initialCameraPosition,
              markers: Set.from(_markers),
              onMapCreated: mapCreated,
            ),
          ),
          _alldata.isEmpty
              ? Container()
              : Positioned(
                  bottom: 10.0,
                  child: Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _alldata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _restaurantList(index);
                      },
                    ),
                  ),
                ),
          Positioned(
              top: 15,
              left: 10,
              child: Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 10,
                                offset: Offset(3, 3))
                          ]),
                      child: Icon(Icons.keyboard_backspace),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 0.5)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 10, bottom: 10, right: 15),
                      child: Text(
                        '${widget.placeData!.name} - Nearby Restaurants',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )),
          _alldata.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  void animateCameraAfterInitialization() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.placeData!.latitude!, widget.placeData!.longitude!),
      zoom: 13,
    )));
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_alldata[_pageController!.page!.toInt()].lat!,
            _alldata[_pageController!.page!.toInt()].lng!),
        zoom: 20,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
