import 'package:flutter/material.dart';
import 'package:ipohgo/models/exclude.dart';
import 'package:ipohgo/models/include.dart';
import 'package:ipohgo/models/place.dart';
import 'package:easy_localization/easy_localization.dart';

class ExcludeWidget extends StatelessWidget {
  final Place? placeData;
  const ExcludeWidget({Key? key, required this.placeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Faqs');
    print('Total : ' + placeData!.faqs!.length.toString());

    print(placeData!.faqs!.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Not Available',
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
          child: placeData!.exclude!.isNotEmpty
              ? ListView.separated(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 15),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: placeData!.exclude!.length,
                  // itemCount: 4,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (placeData!.include!.isEmpty)
                      return Container(
                        child: Text('No FAQ' + index.toString()),
                      );
                    return _ListItem(exclude: placeData!.exclude![index]);
                    // return Text('Test : ' + placeData!.faqs![index].title!);
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
  final Exclude exclude;
  // final RecommandedPlacesBloc rpb;
  const _ListItem({Key? key, required this.exclude}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: double.infinity,
        child: Icon(
          Icons.close,
          color: Colors.red[900],
        ),
      ),
      title: new Text(exclude.title!),
      onTap: null,

      // trailing: new Text(''),
      // minVerticalPadding: 0,
      minLeadingWidth: 5,
      horizontalTitleGap: 10,

      // dense: true,
      visualDensity: VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
    );
  }
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       new Icon(
  //         Icons.close,
  //         // size: 30.0,
  //         color: Colors.red[900],
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 10, top: 3),
  //         child: Text(
  //           exclude.title!,
  //           style: TextStyle(fontWeight: FontWeight.normal),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
