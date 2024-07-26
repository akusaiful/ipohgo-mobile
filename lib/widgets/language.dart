import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ipohgo/config/config.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key? key}) : super(key: key);

  @override
  _LanguagePopupState createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('select language').tr(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: Config().languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(Config().languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        ListTile(
          leading: Icon(LineIcons.language),
          title: Text(
            d,
          ),
          onTap: () async {
            if (d == 'English') {
              context.setLocale(Locale('en'));
            } else if (d == 'Spanish') {
              context.setLocale(Locale('es'));
            } else if (d == 'Arabic') {
              context.setLocale(Locale('ar'));
            }
            // else if(d == 'your_language_name'){
            //   context.setLocale(Locale('your_language_code'));
            // }
            Navigator.pop(context);
          },
        ),
        Divider(
          height: 5,
          color: Colors.grey[400],
        )
      ],
    );
  }
}
