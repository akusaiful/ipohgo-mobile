import 'package:flutter/material.dart';
import 'package:ipohgo/blocs/sp_state_one.dart';
import 'package:ipohgo/models/colors.dart';
import 'package:ipohgo/config/config.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/pages/state_based_places.dart';
import 'package:ipohgo/utils/list_card.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class SpecialStateOne extends StatelessWidget {
  SpecialStateOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spb = context.watch<SpecialStateOneBloc>();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 20,
            right: 15,
          ),
          child: Row(
            children: <Widget>[
              Text(
                'special state-1 places',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                    wordSpacing: 1,
                    letterSpacing: -0.6),
              ).tr(),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => nextScreen(
                    context,
                    StateBasedPlaces(
                      id: 1, // temp
                      thumbnailUrl: '',
                      stateName: Config().specialState1,
                      color: (ColorList().randomColors..shuffle()).first,
                    )),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 10, right: 10),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: spb.data.isEmpty ? 4 : spb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (spb.data.isEmpty) return Container();
              return ListCard(
                d: spb.data[index],
                tag: 'sp1$index',
                color: Colors.grey[200],
              );
            },
          ),
        )
      ],
    );
  }
}
