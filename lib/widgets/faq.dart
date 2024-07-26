import 'package:flutter/material.dart';
import 'package:ipohgo/models/faq.dart';
import 'package:ipohgo/models/place.dart';
import 'package:easy_localization/easy_localization.dart';

class FaqWidget extends StatelessWidget {
  final Place? placeData;
  const FaqWidget({Key? key, required this.placeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Faqs');
    print('Total : ' + placeData!.faqs!.length.toString());

    print(placeData!.faqs!.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Frequently asked questions (FAQ)',
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
          child: placeData!.faqs!.isNotEmpty
              ? ListView.separated(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 30, left: 0, right: 15),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: placeData!.faqs!.length,
                  // itemCount: 4,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (placeData!.faqs!.isEmpty)
                      return Container(
                        child: Text('No FAQ' + index.toString()),
                      );
                    return _ListItem(faq: placeData!.faqs![index]);
                    // return Text('Test : ' + placeData!.faqs![index].title!);
                  },
                )
              : Container(
                  child: Text('No info'),
                ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final Faq faq;
  // final RecommandedPlacesBloc rpb;
  const _ListItem({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          faq.title!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(faq.content!),
      ],
    );
  }
}
