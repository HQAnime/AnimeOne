import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// An icon button that opens ChatGPT with a pre-filled prompt.
///
/// [buildPrompt] returns the prompt to send, or null/empty to hide the button.
class AskChatGPTButton extends StatelessWidget {
  const AskChatGPTButton({super.key, required this.buildPrompt});

  final String? Function(BuildContext context, AppLocalizations l) buildPrompt;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GlobalData.askChatGPTNotifier,
      builder: (context, enabled, _) {
        if (!enabled) return const SizedBox.shrink();

        final l = AppLocalizations.of(context)!;
        final prompt = buildPrompt(context, l);
        if (prompt == null || prompt.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.chat_outlined),
          tooltip: l.askChatGPT,
          onPressed: () => _launch(context, l, prompt),
        );
      },
    );
  }

  Future<void> _launch(
    BuildContext context,
    AppLocalizations l,
    String prompt,
  ) async {
    final uri = Uri.https('chatgpt.com', '/', {'q': prompt});
    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      launched = false;
    }
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loadFailed)),
      );
    }
  }
}
