import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/translation/TranslationCache.dart';
import 'package:animeone/core/translation/TranslationService.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:animeone/ui/page/support.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  static const _localeCodes = ['zh', 'en', 'ja', 'ko', 'ru', 'id'];
  static const _localeNames = [
    '繁體中文',
    'English',
    '日本語',
    '한국어',
    'Русский',
    'Bahasa Indonesia',
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Support()),
              );
            },
            title: Text(l.supportDevTitle),
            subtitle: Text(l.supportDevSubtitle),
            trailing: const Icon(Icons.favorite, color: Colors.red),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(l.fontSize),
                  subtitle: StatefulBuilder(
                    builder: (context, setInnerState) {
                      final scale = GlobalData().getFontScale();
                      return Row(
                        children: [
                          Text(l.small),
                          Expanded(
                            child: Slider(
                              value: scale,
                              min: 0.8,
                              max: 2.5,
                              divisions: 17,
                              label: '${(scale * 100).round()}%',
                              onChanged: (v) {
                                GlobalData().setFontScale(v);
                                setInnerState(() {});
                              },
                            ),
                          ),
                          Text(l.large),
                        ],
                      );
                    },
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setInnerState) {
                    final forceDark = GlobalData.darkModeNotifier.value;
                    return ListTile(
                      title: Text(l.forceDarkMode),
                      subtitle: Text(l.forceDarkModeSubtitle),
                      onTap: () {
                        GlobalData().setForceDark(!forceDark);
                        setInnerState(() {});
                      },
                      trailing: Transform.translate(
                        offset: const Offset(8, 0),
                        child: Checkbox(
                          value: forceDark,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (v) {
                            GlobalData().setForceDark(v ?? false);
                            setInnerState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                StatefulBuilder(
                  builder: (context, setInnerState) {
                    final currentLocale = GlobalData().getLocale();
                    final currentCode = currentLocale?.languageCode ?? '';
                    final idx = _localeCodes.indexOf(currentCode);
                    return ListTile(
                      title: Text(l.language),
                      subtitle: Text(
                        idx >= 0 ? _localeNames[idx] : '繁體中文',
                      ),
                      trailing: const Icon(Icons.language),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => SimpleDialog(
                            title: Text(l.language),
                            children: [
                              for (int i = 0; i < _localeCodes.length; i++)
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    if (_localeCodes[i] == currentCode) return;
                                    showDialog(
                                      context: context,
                                      builder: (c2) => AlertDialog(
                                        title: Text(l.language),
                                        content: Text(l.changeLangWarning),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(c2),
                                            child: Text(l.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(c2);
                                              TranslationCache.clear();
                                              TranslationService
                                                  .cancelPending();
                                              GlobalData()
                                                  .setLocale(_localeCodes[i]);
                                            },
                                            child: Text(l.confirm),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        currentCode == _localeCodes[i]
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(_localeNames[i]),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  onTap: () {
                    TranslationCache.clear();
                    TranslationService.cancelPending();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.resetCachedDone)),
                    );
                  },
                  title: Text(l.resetCachedTitles),
                  subtitle: Text(l.resetCachedTitlesSubtitle),
                  trailing: const Icon(Icons.delete_outline),
                ),
                const Divider(),
                ListTile(
                  onTap: () => launchUrlString('https://61.uy/d'),
                  title: Text(l.discordServer),
                  subtitle: const Text('https://61.uy/d'),
                ),
                ListTile(
                  onTap: () {
                    launchUrlString('https://anime1.me/%e9%97%9c%e6%96%bc');
                  },
                  title: Text(l.officialWebsite),
                  subtitle: Text(l.officialWebsiteSubtitle),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    launchUrlString('https://github.com/HenryQuan/AnimeOne');
                  },
                  title: Text(l.sourceCode),
                  subtitle: Text(l.sourceCodeSubtitle),
                ),
                ListTile(
                  onTap: () {
                    launchUrlString(
                      'https://github.com/HenryQuan/AnimeOne/blob/master/README.md#%E9%9A%B1%E7%A7%81%E6%A2%9D%E6%AC%BE',
                    );
                  },
                  title: Text(l.privacyPolicy),
                  subtitle: Text(l.privacyPolicySubtitle),
                ),
                ListTile(
                  title: Text(l.openSourceLicense),
                  subtitle: Text(l.openSourceLicenseSubtitle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => LicensePage(
                          applicationName: 'AnimeOne',
                          applicationVersion: GlobalData.version,
                          applicationLegalese: l.openSourceLegalese,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    launchUrlString(GlobalData.eminaOne);
                  },
                  title: Text(l.downloadEminaOne),
                  subtitle: Text(l.downloadEminaOneSubtitle),
                ),
                ListTile(
                  onTap: () {
                    launchUrlString(GlobalData.oneAnime);
                  },
                  title: Text(l.downloadOneAnime),
                  subtitle: Text(l.downloadOneAnimeSubtitle),
                ),
                ListTile(
                  onTap: () {
                    launchUrlString(GlobalData.animeGo);
                  },
                  title: Text(l.downloadAnimeGo),
                  subtitle: Text(l.downloadAnimeGoSubtitle),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    GlobalData().sendEmail('');
                  },
                  title: Text(l.email),
                  subtitle: Text(l.emailSubtitle),
                ),
                ListTile(
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text: GlobalData.latestRelease,
                        subject: l.shareSubject,
                        sharePositionOrigin: const Rect.fromLTWH(0, 0, 0, 0),
                      ),
                    );
                  },
                  title: Text(l.shareApp),
                  subtitle: Text(l.shareAppSubtitle),
                ),
                ListTile(
                  title: Text(l.appUpdate),
                  subtitle: Text(GlobalData.version),
                  onTap: () {
                    GlobalData().checkGithubUpdate().then((_) {
                      if (!context.mounted) return;
                      GlobalData()
                          .getGithubUpdate()
                          ?.checkUpdate(context, showAlertWhenNoUpdate: true);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
