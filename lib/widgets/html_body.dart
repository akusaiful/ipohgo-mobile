import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ipohgo/widgets/youtube_player_widget.dart';

import '../services/app_service.dart';
import '../utils/next_screen.dart';
import 'image_view.dart';
import 'video_player_widget.dart';

class HtmlBodyWidget extends StatelessWidget {
  final String? content;
  final bool isVideoEnabled;
  final bool isimageEnabled;
  final bool isIframeVideoEnabled;
  final double? fontSize;

  const HtmlBodyWidget({
    Key? key,
    required this.content,
    required this.isVideoEnabled,
    required this.isimageEnabled,
    required this.isIframeVideoEnabled,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: content,
      onLinkTap: (url, _, __) {
        AppService().openLinkWithCustomTab(context, url!);
      },
      style: {
        "body": Style(
          // margin: Margins.zero,
          margin: Margins.only(right: 20),
          // padding: EdgeInsets.zero,
          // padding: EdgeInsets.zero,
          //Enable the below line and disble the upper line to disble full width image/video

          // padding: EdgeInsets.all(20),

          fontSize: FontSize(17),
          lineHeight: LineHeight(1.7),
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
          // color: Colors.blueGrey[600]),
          // color: Colors.black87,
        ),
        // "figure": Style(margin: Margins.zero, padding: EdgeInsets.zero),

        //Disable this line to disble full width image/video
        "p,h1,h2,h3,h4,h5,h6": Style(margin: Margins.all(20)),
      },
      extensions: [
        TagExtension(
            tagsToExtend: {"iframe"},
            builder: (ExtensionContext eContext) {
              final String videoSource = eContext.attributes['src'].toString();
              if (isIframeVideoEnabled == false) return Container();
              if (videoSource.contains('youtu')) {
                return VideoPlayerWidget(
                    videoUrl: videoSource, videoType: 'youtube');
                // print(videoSource);
                // return YoutubePlayerWidget(videoUrl: videoSource);
              } else if (videoSource.contains('vimeo')) {
                return VideoPlayerWidget(
                    videoUrl: videoSource, videoType: 'vimeo');
              }
              return Container();
            }),
        TagExtension(
            tagsToExtend: {"video"},
            builder: (ExtensionContext eContext) {
              final String videoSource = eContext.attributes['src'].toString();
              if (isVideoEnabled == false) return Container();
              return VideoPlayerWidget(
                  videoUrl: videoSource, videoType: 'network');
            }),
        TagExtension(
            tagsToExtend: {"img"},
            builder: (ExtensionContext eContext) {
              String imageUrl = eContext.attributes['src'].toString();
              if (isimageEnabled == false) return Container();
              return InkWell(
                  onTap: () =>
                      nextScreen(context, FullScreenImage(imageUrl: imageUrl)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ));
            }),
      ],
    );
  }
}
