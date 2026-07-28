import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// WebsiteClosed class
class WebsiteClosed extends StatelessWidget {
  const WebsiteClosed({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('lib/assets/icon/logo.png'),
              height: 200,
              width: 200,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(l.websiteClosed,
                style: Theme.of(context).textTheme.headlineMedium),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(l.fenglinClosed),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                l.websiteClosedMessage,
                textAlign: TextAlign.center,
              ),
            ),
            Text(l.ifYouLikeEnglish),
            ElevatedButton(
              onPressed: () {
                launchUrlString(
                  'https://github.com/HenryQuan/AnimeGo-Re/releases',
                );
              },
              child: Text(l.downloadAnimeGoWebsite),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: TextButton(
                onPressed: () {
                  launchUrlString('https://github.com/HenryQuan/AnimeOne');
                },
                child: const Text('https://github.com/HenryQuan/AnimeOne'),
              ),
            ),
            const Text(
              'Aug 2019 - Apr 2020',
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

//
// 永遠のAnimeOne
