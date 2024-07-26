import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:ipohgo/blocs/notification_bloc.dart';
import 'package:ipohgo/models/notification.dart';
import 'package:ipohgo/services/app_service.dart';
import 'package:ipohgo/utils/empty.dart';
import 'package:ipohgo/utils/next_screen.dart';
import 'notification_details.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      context.read<NotificationBloc>().onRefresh(mounted);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<NotificationBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<NotificationBloc>().setLoading(true);
        context.read<NotificationBloc>().getData(mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nb = context.watch<NotificationBloc>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('notifications').tr(),
        actions: [
          IconButton(
            icon: Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () => context.read<NotificationBloc>().onReload(mounted),
          )
        ],
      ),
      body: RefreshIndicator(
        child: nb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: Feather.bell_off,
                      message: 'no notifications'.tr(),
                      message1: ''),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.only(top: 15, bottom: 20),
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: nb.data.length + 1,
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (_, int index) {
                  if (index < nb.data.length) {
                    return _ListItem(d: nb.data[index]);
                  }
                  return Center(
                    child: new Opacity(
                      opacity: nb.isLoading ? 1.0 : 0.0,
                      child: new SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: new CircularProgressIndicator()),
                    ),
                  );
                },
              ),
        onRefresh: () async {
          context.read<NotificationBloc>().onRefresh(mounted);
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final NotificationModel d;
  const _ListItem({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey[100]!, blurRadius: 5, offset: Offset(0, 5))
            ],
            border: Border.all(
              color: Colors.black12,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5,
              constraints: BoxConstraints(minHeight: 140),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(AppService.getNormalText(d.preview.toString()),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey[600])),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Icon(
                          EvaIcons.calendarOutline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          d.createdAt,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          EvaIcons.paperPlane,
                          size: 16,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Publish by ' + d.author.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => nextScreen(context, NotificationDetails(data: d)),
    );
  }
}
