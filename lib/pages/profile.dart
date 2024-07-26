import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/blocs/notification_bloc.dart';
import 'package:ipohgo/blocs/sign_in_bloc.dart';
import 'package:ipohgo/blocs/theme_bloc.dart';
import 'package:ipohgo/config/config.dart';
import 'package:ipohgo/pages/contact.dart';
import 'package:ipohgo/pages/edit_profile.dart';
import 'package:ipohgo/pages/notifications.dart';
import 'package:ipohgo/pages/privacy.dart';
import 'package:ipohgo/pages/security.dart';
import 'package:ipohgo/pages/sign_in.dart';
import 'package:ipohgo/services/app_service.dart';
import 'package:ipohgo/services/theme_provider.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:ipohgo/widgets/image_view.dart';
import 'package:ipohgo/widgets/language.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  openAboutDialog() {
    final sb = context.read<SignInBloc>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationName: Config().appName,
            applicationIcon: Image(
              image: AssetImage(Config().splashIcon),
              height: 30,
              width: 30,
            ),
            applicationVersion: sb.appVersion,
          );
        });
  }

  TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    // color: Colors.grey[900],
  );

  // TextStyle _textStyle = Theme.of(context).textTheme.title,);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('profile').tr(),
          centerTitle: false,
          actions: [
            IconButton(
                icon: Icon(LineIcons.bell, size: 25),
                onPressed: () => nextScreen(context, NotificationsPage()))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
          children: [
            sb.isSignedIn == false ? GuestUserUI() : UserUI(),
            Text(
              "general setting",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ).tr(),
            SizedBox(
              height: 15,
            ),
            ListTile(
              // title: Text('get notifications', style: _textStyle).tr(),
              title: Text(
                'get notifications',
                style: Theme.of(context).textTheme.headlineMedium,
              ).tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.bell, size: 20, color: Colors.white),
              ),
              trailing: Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: context.watch<NotificationBloc>().subscribed,
                  onChanged: (bool newValue) {
                    context
                        .read<NotificationBloc>()
                        .handleSubscription(context, newValue);
                  }),
            ),
            ListTile(
              title: Text('Dark Theme',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(EvaIcons.moon, size: 20, color: Colors.white),
              ),
              trailing: Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: context.watch<ThemeBloc>().darkmode,
                  onChanged: (bool newValue) {
                    context
                        .read<ThemeBloc>()
                        .handleThemeChange(context, newValue);
                  }),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('language',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.globe, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreenPopup(context, LanguagePopup()),
            ),
            // Divider(
            //   height: 5,
            // ),
            // ListTile(
            //   title: Text('contact us', style: _textStyle).tr(),
            //   leading: Container(
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(
            //         color: Colors.blueAccent,
            //         borderRadius: BorderRadius.circular(5)),
            //     child: Icon(Feather.mail, size: 20, color: Colors.white),
            //   ),
            //   trailing: Icon(
            //     Feather.chevron_right,
            //     size: 20,
            //   ),
            //   onTap: () async => await AppService().openEmailSupport(context),
            // ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('rate this app',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.star, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => AppService().launchAppReview(context),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('privacy policy',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.lock, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreen(context, PrivacyPage()),
              // onTap: () => AppService()
              //     .openLinkWithCustomTab(context, Config().privacyPolicyUrl),
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text('about us',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.info, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),

              onTap: () => nextScreen(context, ContactPage()),
              // onTap: () => AppService()
              //     .openLinkWithCustomTab(context, Config().yourWebsiteUrl),
            ),
            sb.guestUser == true
                ? Container()
                : SecurityOption(
                    textStyle: _textStyle,
                  ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text('facebook',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.facebook, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () =>
                  AppService().openLink(context, Config().facebookPageUrl),
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: Text('youtube',
                      style: Theme.of(context).textTheme.headlineMedium)
                  .tr(),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.youtube, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () =>
                  AppService().openLink(context, Config().youtubeChannelUrl),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class SecurityOption extends StatelessWidget {
  const SecurityOption({Key? key, required this.textStyle}) : super(key: key);
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 10,
        ),
        ListTile(
          title: Text('security', style: textStyle).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueGrey, borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.settings, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => nextScreen(context, SecurityPage()),
        ),
      ],
    );
  }
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[900]);

    return Column(
      children: [
        ListTile(
          title: Text(
            'login',
            style: Theme.of(context).textTheme.headlineMedium,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.user, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => nextScreenPopup(
              context,
              SignInPage(
                tag: 'popup',
              )),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    TextStyle _textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[900]);
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              InkWell(
                child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: CachedNetworkImageProvider(sb.imageUrl!)),
                onTap: () => nextScreen(
                    context, FullScreenImage(imageUrl: sb.imageUrl!)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                sb.name!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.6,
                    wordSpacing: 2),
              ),
              Text(
                sb.email!,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -0.6,
                    wordSpacing: 2),
              )
            ],
          ),
        ),
        // ListTile(
        //   title: Text(
        //     sb.email!,
        //     style: _textStyle,
        //   ),
        //   leading: Container(
        //     height: 30,
        //     width: 30,
        //     decoration: BoxDecoration(
        //         color: Colors.blueAccent,
        //         borderRadius: BorderRadius.circular(5)),
        //     child: Icon(Feather.mail, size: 20, color: Colors.white),
        //   ),
        // ),
        // Divider(
        //   height: 5,
        // ),
        // ListTile(
        //   title: Text(
        //     sb.joiningDate!,
        //     style: _textStyle,
        //   ),
        //   leading: Container(
        //     height: 30,
        //     width: 30,
        //     decoration: BoxDecoration(
        //         color: Colors.green, borderRadius: BorderRadius.circular(5)),
        //     child: Icon(LineIcons.timesCircle, size: 20, color: Colors.white),
        //   ),
        // ),
        Divider(
          height: 5,
        ),
        ListTile(
            title: Text(
              'edit profile',
              // style: _textStyle,
              style: Theme.of(context).textTheme.headlineMedium,
            ).tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(Feather.edit_3, size: 20, color: Colors.white),
            ),
            trailing: Icon(
              Feather.chevron_right,
              size: 20,
            ),
            onTap: () => nextScreen(
                context, EditProfile(name: sb.name, imageUrl: sb.imageUrl))),
        Divider(
          height: 5,
        ),
        ListTile(
          title: Text(
            'logout',
            // style: _textStyle,
            style: Theme.of(context).textTheme.headlineMedium,
          ).tr(),
          leading: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Feather.log_out, size: 20, color: Colors.white),
          ),
          trailing: Icon(
            Feather.chevron_right,
            size: 20,
          ),
          onTap: () => openLogoutDialog(context),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('logout title').tr(),
            actions: [
              TextButton(
                child: Text('no').tr(),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('yes').tr(),
                onPressed: () async {
                  Navigator.pop(context);
                  await context
                      .read<SignInBloc>()
                      .userSignout()
                      .then((value) =>
                          context.read<SignInBloc>().afterUserSignOut())
                      .then((value) =>
                          nextScreenCloseOthers(context, SignInPage()));
                },
              )
            ],
          );
        });
  }
}
