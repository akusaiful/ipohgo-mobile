import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ipohgo/config/api.dart';
import 'package:ipohgo/config/config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  // bool _isLoading = false;
  late final WebViewController _controller;
  var loadingPercentage = 0;

  // _openDeleteDialog() {
  //   return showDialog(
  //       barrierDismissible: true,
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('account-delete-title').tr(),
  //           content: Text('account-delete-subtitle').tr(),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _handleDeleteAccount();
  //               },
  //               child: Text('account-delete-confirm').tr(),
  //             ),
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text('cancel').tr())
  //           ],
  //         );
  //       });
  // }

  // _handleDeleteAccount() async {
  //   setState(() => _isLoading = true);
  //   await context
  //       .read<SignInBloc>()
  //       .deleteUserDatafromDatabase()
  //       .then((_) async => await context.read<SignInBloc>().userSignout())
  //       .then((_) => context.read<SignInBloc>().afterUserSignOut())
  //       .then((_) {
  //     setState(() => _isLoading = false);
  //     Future.delayed(Duration(seconds: 1))
  //         .then((value) => nextScreenCloseOthers(context, SignInPage()));
  //   });
  // }

  // _callNumber() async {
  //   const number = '05-2083151'; //set the number here
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }
  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(Config().privacyPolicyUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
        // child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
