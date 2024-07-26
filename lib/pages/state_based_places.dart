import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/models/place.dart';
import 'package:ipohgo/pages/place_details.dart';
import 'package:ipohgo/utils/empty.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/widgets/custom_cache_image.dart';
import 'package:ipohgo/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class StateBasedPlaces extends StatefulWidget {
  final int? id;
  final String? stateName;
  final String? thumbnailUrl;
  final Color? color;
  StateBasedPlaces(
      {Key? key,
      required this.id,
      required this.stateName,
      required this.thumbnailUrl,
      required this.color})
      : super(key: key);

  @override
  _StateBasedPlacesState createState() => _StateBasedPlacesState();
}

class _StateBasedPlacesState extends State<StateBasedPlaces> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'places';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Place> _data = [];
  bool? _hasData;
  int _offset = 0;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _offset = 0;
      // _lastVisible = null;
    });
    _getData();
  }

  Future<Null> _getData() async {
    setState(() => _hasData = true);
    // QuerySnapshot data;
    List<Place> data = [];
    final uri = Uri.http(Api.domain, Api.path + '/tour/view/category',
        {'id': widget.id.toString(), 'offset': _offset.toString()});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var _snapshot = jsonDecode(response.body);
      var snapshot = _snapshot['data'] as List;

      data = snapshot.map<Place>((json) => Place.fromJson(json)).toList();
    }

    // if (_lastVisible == null)
    //   data = await firestore
    //       .collection(collectionName)
    //       .where('state', isEqualTo: widget.stateName)
    //       .orderBy('loves', descending: true)
    //       .limit(5)
    //       .get();
    // else
    //   data = await firestore
    //       .collection(collectionName)
    //       .where('state', isEqualTo: widget.stateName)
    //       .orderBy('loves', descending: true)
    //       .startAfter([_lastVisible!['loves']])
    //       .limit(5)
    //       .get();

    // if (data.docs.length > 0) {
    //   _lastVisible = data.docs[data.docs.length - 1];
    //   if (mounted) {
    //     setState(() {
    //       _isLoading = false;
    //       _snap.addAll(data.docs);
    //       _data = _snap.map((e) => Place.fromFirestore(e)).toList();
    //     });
    //   }
    // } else {
    //   if (_lastVisible == null) {
    //     setState(() {
    //       _isLoading = false;
    //       _hasData = false;
    //       debugPrint('no items');
    //     });
    //   } else {
    //     setState(() {
    //       _isLoading = false;
    //       _hasData = true;
    //       debugPrint('no more items');
    //     });
    //   }
    // }
    if (data.isNotEmpty) {
      // _lastVisible = data.docs[data.docs.length - 1];
      _offset += data.length;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data);
          // _data = _snap.map((e) => Place.fromFirestore(e)).toList();
        });
      }
    } else {
      if (_offset == 0) {
        setState(() {
          _isLoading = false;
          _hasData = false;
          debugPrint('no items');
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasData = true;
          debugPrint('no more items');
        });
      }
    }
    return null;
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              // title: Text(
              //   'RECREATIONAL & NATURAL',
              //   style: TextStyle(color: Colors.white),
              // ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              automaticallyImplyLeading: true,
              pinned: true,
              snap: false,
              floating: true,
              // stretch: true,
              // actions: <Widget>[
              //   CircleAvatar(
              //       backgroundColor:
              //           Theme.of(context).primaryColor.withOpacity(0.9),
              //       child: IconButton(
              //         icon: Icon(
              //           Icons.keyboard_arrow_left,
              //           color: Colors.white,
              //         ),
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //       ))
              // ],
              // backgroundColor: widget.color,
              backgroundColor: Colors.blue,
              expandedHeight: 150,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.network(
                      widget.thumbnailUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[900]!.withOpacity(0.7),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        child: Text(
                          widget.stateName!.toUpperCase(),
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _hasData == false
                ? SliverFillRemaining(
                    child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                      ),
                      EmptyPage(
                          icon: Feather.clipboard,
                          message: 'no places found'.tr(),
                          message1: ''),
                    ],
                  ))
                : SliverPadding(
                    padding: EdgeInsets.all(15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _data.length) {
                            return _ListItem(
                              d: _data[index],
                              tag: '${_data[index].timestamp}$index',
                            );
                          }
                          return Opacity(
                            opacity: _isLoading ? 1.0 : 0.0,
                            child: _lastVisible == null
                                ? Column(
                                    children: [
                                      LoadingCard(
                                        height: 180,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  )
                                : Center(
                                    child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child:
                                            new CupertinoActivityIndicator()),
                                  ),
                          );
                        },
                        childCount: _data.length == 0 ? 5 : _data.length + 1,
                      ),
                    ),
                  )
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Place d;
  final String tag;
  const _ListItem({Key? key, required this.d, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 15),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Hero(
                      tag: tag,
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
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Feather.map_pin,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              d.location!,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Last Updated : ' + d.date!,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                          Spacer(),
                          Icon(
                            LineIcons.heart,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.loves.toString(),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            LineIcons.comment,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.commentsCount.toString(),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
      onTap: () => nextScreen(context, PlaceDetails(data: d, tag: tag)),
    );
  }
}
