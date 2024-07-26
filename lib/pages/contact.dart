import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ipohgo/services/app_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _isLoading = false;

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

  _callNumber() async {
    const number = '05-2083151'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us').tr(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Image(image: AssetImage('assets/images/mbi.jpg')),
              ListTile(
                title: Text('Ipoh Tourism Information Centre').tr(),
                leading: Icon(
                  Feather.home,
                  size: 20,
                ),
                // onTap: _openDeleteDialog,
              ),
              ListTile(
                title: Text('05-208 3151').tr(),
                leading: Icon(
                  Feather.phone,
                  size: 20,
                ),
                onTap: _callNumber,
              ),
              ListTile(
                title: Text('ipohtourism@gmail.com').tr(),
                leading: Icon(
                  Feather.mail,
                  size: 20,
                ),
                onTap: () async => await AppService().openEmailSupport(context),
                // onTap: _openDeleteDialog,
              ),
              ListTile(
                title: Text(
                        'Tingkat Bawah, Pejabat Majlis Bandaraya Ipoh, Jalan Bandar, 30000 Ipoh, Perak')
                    .tr(),
                leading: Icon(
                  Feather.map_pin,
                  size: 20,
                ),
                // onTap: _openDeleteDialog,
              ),
              // ListTile(
              //   title: Text('delete-user-data').tr(),
              //   leading: Icon(
              //     Feather.trash,
              //     size: 20,
              //   ),
              //   // onTap: _openDeleteDialog,
              // ),
            ],
          ),
          Align(
            child:
                _isLoading == true ? CircularProgressIndicator() : Container(),
          )
        ],
      ),
    );
  }
}
