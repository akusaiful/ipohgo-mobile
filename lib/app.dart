import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/blocs/random_review_bloc.dart';
import 'services/theme_provider.dart';
import 'blocs/theme_bloc.dart';
// import 'package:ipohgo/config/config.dart';
import 'package:ipohgo/pages/splash.dart';
// import 'package:ipohgo/theme/theme.dart';
import 'package:ipohgo/theme/theme_data.dart';
import 'blocs/ads_bloc.dart';
import 'blocs/blog_bloc.dart';
import 'blocs/bookmark_bloc.dart';
import 'blocs/comments_bloc.dart';
import 'blocs/featured_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/other_places_bloc.dart';
import 'blocs/popular_places_bloc.dart';
import 'blocs/recent_places_bloc.dart';
import 'blocs/recommanded_places_bloc.dart';
import 'blocs/search_bloc.dart';
import 'blocs/sign_in_bloc.dart';
import 'blocs/sp_state_one.dart';
import 'blocs/sp_state_two.dart';
import 'blocs/state_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =
    FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogBloc>(
          create: (context) => BlogBloc(),
        ),
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<PopularPlacesBloc>(
          create: (context) => PopularPlacesBloc(),
        ),
        ChangeNotifierProvider<RecentPlacesBloc>(
          create: (context) => RecentPlacesBloc(),
        ),
        ChangeNotifierProvider<RandomReviewBloc>(
          create: (context) => RandomReviewBloc(),
        ),
        ChangeNotifierProvider<RecommandedPlacesBloc>(
          create: (context) => RecommandedPlacesBloc(),
        ),
        ChangeNotifierProvider<FeaturedBloc>(
          create: (context) => FeaturedBloc(),
        ),
        ChangeNotifierProvider<SearchBloc>(
          create: (context) => SearchBloc(),
        ),
        ChangeNotifierProvider<NotificationBloc>(
            create: (context) => NotificationBloc()),
        ChangeNotifierProvider<StateBloc>(
          create: (context) => StateBloc(),
        ),
        ChangeNotifierProvider<SpecialStateOneBloc>(
          create: (context) => SpecialStateOneBloc(),
        ),
        ChangeNotifierProvider<SpecialStateTwoBloc>(
          create: (context) => SpecialStateTwoBloc(),
        ),
        ChangeNotifierProvider<OtherPlacesBloc>(
          create: (context) => OtherPlacesBloc(),
        ),
        ChangeNotifierProvider<AdsBloc>(
          create: (context) => AdsBloc(),
        ),
        ChangeNotifierProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: ChangeNotifierProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
        child: Consumer<ThemeBloc>(
            builder: (context, ThemeBloc themeNotifier, child) {
          return MaterialApp(
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
            navigatorObservers: [firebaseObserver],
            // title: 'Flutter Demo',
            theme: themeNotifier.darkmode
                ? ThemeClass.darkTheme
                : ThemeClass.lightTheme,
            debugShowCheckedModeBanner: false,
            home: SplashPage(),
            // home: FlutterSplashScreen(),
          );
        }),
      ),
    );
  }
}
