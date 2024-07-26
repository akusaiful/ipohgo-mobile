import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/blocs/featured_bloc.dart';
import 'package:ipohgo/blocs/popular_places_bloc.dart';
import 'package:ipohgo/blocs/random_review_bloc.dart';
import 'package:ipohgo/blocs/recent_places_bloc.dart';
import 'package:ipohgo/blocs/recommanded_places_bloc.dart';
import 'package:ipohgo/blocs/sign_in_bloc.dart';
import 'package:ipohgo/blocs/sp_state_one.dart';
import 'package:ipohgo/blocs/sp_state_two.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipohgo/blocs/theme_bloc.dart';
import 'package:ipohgo/config/config.dart';
import 'package:ipohgo/pages/profile.dart';
import 'package:ipohgo/pages/search.dart';
import 'package:ipohgo/utils/fcm.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/widgets/featured_places.dart';
import 'package:ipohgo/widgets/google_drive.dart';
import 'package:ipohgo/widgets/parking.dart';
import 'package:ipohgo/widgets/popular_places.dart';
import 'package:ipohgo/widgets/home_random_review.dart';
import 'package:ipohgo/widgets/recent_places.dart';
import 'package:ipohgo/widgets/recommended_places.dart';
import 'package:easy_localization/easy_localization.dart';

class Explore extends StatefulWidget {
  Explore({Key? key}) : super(key: key);

  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    reloadData();
  }

  Future reloadData() async {
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      await context
          .read<FeaturedBloc>()
          .getData()
          .then((value) => context.read<PopularPlacesBloc>().getData())
          .then((value) => context.read<RecentPlacesBloc>().getData())
          .then((value) => context.read<RandomReviewBloc>().getData())
          .then((value) => context.read<SpecialStateOneBloc>().getData())
          .then((value) => context.read<SpecialStateTwoBloc>().getData())
          .then((value) => context.read<RecommandedPlacesBloc>().getData());
    });
  }

  Future _onRefresh() async {
    context.read<FeaturedBloc>().onRefresh();
    context.read<PopularPlacesBloc>().onRefresh(mounted);
    context.read<RecentPlacesBloc>().onRefresh(mounted);
    context.read<RandomReviewBloc>().onRefresh(mounted);
    context.read<SpecialStateOneBloc>().onRefresh(mounted);
    context.read<SpecialStateTwoBloc>().onRefresh(mounted);
    context.read<RecommandedPlacesBloc>().onRefresh(mounted);
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseMessaging _firebaseMessaging =
    //     FirebaseMessaging.instance; // Change here
    // _firebaseMessaging.getToken().then((token) {
    //   print("token is $token");
    // });
    setFcmToken();

    // getFcmToken().then((value) => print('Token ' + value.toString()));

    super.build(context);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _onRefresh(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Header(),
                  Featured(),
                  GoogleDrive(),
                  PopularPlaces(),
                  HomeRandomReview(),
                  RecentPlaces(),
                  // SpecialStateOne(),
                  // SpecialStateTwo(),
                  RecommendedPlaces()
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final ThemeBloc theme = Provider.of<ThemeBloc>(context);

    // final brightness = MediaQuery.of(context).platformBrightness;
    // final darkModeOn = (brightness == Brightness.dark);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TO DO :  replace with network image
                    Image.asset(
                      (theme.darkmode)
                          ? 'assets/images/logo_light.png'
                          : 'assets/images/logo_dark.png',
                      scale: 7,
                    ),
                    // Text(
                    //   Config().appName,
                    //   style: TextStyle(
                    //       fontSize: 24,
                    //       fontFamily: 'Muli',
                    //       fontWeight: FontWeight.w900,
                    //       color: Colors.grey[800]),
                    // ),
                    // Text(
                    //   'explore country',
                    //   style: TextStyle(
                    //       fontSize: 13,
                    //       fontStyle: FontStyle.italic,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.grey[600]),
                    // ).tr()
                  ],
                ),
                Spacer(),
                InkWell(
                  child: sb.imageUrl == null || sb.isSignedIn == false
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, size: 28),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(sb.imageUrl!),
                                  fit: BoxFit.cover)),
                        ),
                  onTap: () {
                    nextScreen(context, ProfilePage());
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Colors.grey[100],
                color: Theme.of(context).shadowColor,
                border: Border.all(color: Colors.grey[300]!, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Feather.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Discover our beautiful places',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey[700],
                          fontWeight: FontWeight.w500),
                    ).tr(),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          )
        ],
      ),
    );
  }
}
