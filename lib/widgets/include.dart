import 'package:flutter/material.dart';
import 'package:ipohgo/models/include.dart';
import 'package:ipohgo/models/place.dart';
import 'package:easy_localization/easy_localization.dart';

class IncludeWidget extends StatelessWidget {
  final Place? placeData;
  const IncludeWidget({Key? key, required this.placeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Faqs');
    print('Total : ' + placeData!.faqs!.isEmpty.toString());

    print(placeData!.faqs!.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Available at Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            )).tr(),
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 15),
          height: 3,
          width: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(40)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: placeData!.include!.isNotEmpty
              ? ListView.separated(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 15),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: placeData!.include!.length,
                  // itemCount: 4,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _ListItem(include: placeData!.include![index]);
                  },
                )
              : Container(
                  child: Text('No Info'),
                ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final Include include;
  // final RecommandedPlacesBloc rpb;
  const _ListItem({Key? key, required this.include}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: double.infinity,
        child: Icon(Icons.done),
      ),
      title: new Text(include.title!),
      onTap: null,

      // trailing: new Text(''),
      // minVerticalPadding: 0,
      minLeadingWidth: 5,
      horizontalTitleGap: 10,

      // dense: true,
      visualDensity: VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
    );

    // return Wrap(
    //   children: [
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         new Icon(
    //           Icons.close,
    //           // size: 30.0,
    //           color: Colors.red[900],
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(left: 10, top: 3),
    //           child: Wrap(
    //             children: <Widget>[
    //               Text(
    //                 include.title!,
    //                 style: TextStyle(fontWeight: FontWeight.normal),
    //                 softWrap: true,
    //               )
    //             ],
    //           ),
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }
}
