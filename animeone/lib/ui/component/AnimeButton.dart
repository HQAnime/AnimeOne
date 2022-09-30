import 'package:animeone/core/anime/AnimeBasic.dart';
import 'package:animeone/ui/page/anime.dart';
import 'package:flutter/material.dart';

/// This a button that accepts AnimeSchedule or AnimeRecent
class AnimeButton extends StatelessWidget {
  const AnimeButton({
    Key? key,
    required this.basic,
    this.recent,
  }) : super(key: key);

  final AnimeBasic basic;
  final bool? recent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: () {
          // It might be null
          if (basic.link != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Anime(
                  link: basic.link,
                  recent: recent,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // Has update now
                return const AlertDialog(
                  content: Text('動畫還沒有更新第一集 >_<', textAlign: TextAlign.center),
                );
              },
            );
          }
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              basic.formattedName() ?? "賽博朋克",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
