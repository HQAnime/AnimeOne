import 'package:animeone/core/GlobalData.dart';
import 'package:flutter/material.dart';

/// EmailButton class
class EmailButton extends StatelessWidget {
  const EmailButton({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.618,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
          ),
        ),
        onPressed: () {
          // Just to make sure the user doesn't send multiple emails
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('關於加載失敗'),
                content: const Text(
                  '請先嘗試重新啓動APP，檢查問題依然存在。如果問題依然存在，請一天後再次嘗試，如果還是無法加載的話，再發送郵件。網站有的時候會檢查瀏覽器，所以導致 APP 無法使用。報告只會包括錯誤信息，請不要重複發送多個報告！',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('發送郵件'),
                    onPressed: () => GlobalData().sendEmail(message),
                  ),
                  TextButton(
                    child: const Text('取消'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('詳細信息'),
      ),
    );
  }
}
