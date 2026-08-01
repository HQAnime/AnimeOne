import 'package:animeone/core/GlobalData.dart';
import 'package:animeone/core/translation/TranslationCache.dart';
import 'package:animeone/core/translation/TranslationService.dart';
import 'package:flutter/material.dart';

class TranslatedText extends StatefulWidget {
  final String originalText;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool canFetch;

  const TranslatedText({
    super.key,
    required this.originalText,
    this.style,
    this.maxLines,
    this.overflow,
    this.canFetch = false,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _displayText;
  bool _loading = false;

  String? _cleanName;

  @override
  void initState() {
    super.initState();
    _cleanName = _stripTag(widget.originalText);
    _resolve();
    GlobalData.localeNotifier.addListener(_onLocaleChanged);
    TranslationCache.translationAdded.addListener(_onTranslationAdded);
  }

  @override
  void dispose() {
    GlobalData.localeNotifier.removeListener(_onLocaleChanged);
    TranslationCache.translationAdded.removeListener(_onTranslationAdded);
    super.dispose();
  }

  void _onLocaleChanged() {
    _displayText = null;
    _loading = false;
    if (mounted) setState(() => _resolve());
  }

  void _onTranslationAdded() {
    final cleanName = _cleanName;
    if (cleanName == null) return;
    if (_displayText != null && _displayText != widget.originalText) return;
    if (!TranslationCache.has(cleanName)) return;
    final cached = TranslationCache.get(cleanName);
    if (cached == null) return;
    final tag = _extractTag(widget.originalText);
    final result = tag.isEmpty ? cached : '$tag $cached';
    if (mounted) setState(() => _displayText = result);
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.originalText != widget.originalText) {
      _displayText = null;
      _loading = false;
      _cleanName = _stripTag(widget.originalText);
      _resolve();
    }
  }

  static String _extractTag(String text) {
    if (text.startsWith('[')) {
      final end = text.indexOf(']');
      if (end > 0 && end + 1 < text.length) {
        return text.substring(0, end + 1);
      }
    }
    return '';
  }

  static String _stripTag(String text) {
    if (text.startsWith('[')) {
      final end = text.indexOf(']');
      if (end > 0 && end + 1 < text.length) {
        return text.substring(end + 1).trim();
      }
    }
    return text;
  }

  void _resolve() {
    final locale = GlobalData().getLocale();
    if (locale != null && locale.languageCode == 'zh') {
      _displayText = widget.originalText;
      return;
    }

    final tag = _extractTag(widget.originalText);
    final cleanName = _stripTag(widget.originalText);

    final cached = TranslationCache.get(cleanName);
    if (cached != null) {
      _displayText = tag.isEmpty ? cached : '$tag $cached';
      return;
    }

    if (!widget.canFetch || _loading) return;
    _loading = true;

    final target = locale?.languageCode ?? 'en';
    TranslationService.translate(cleanName, target).then((t) {
      if (!mounted) return;
      final translated = t ?? cleanName;
      TranslationCache.put(cleanName, translated);
      setState(
          () => _displayText = tag.isEmpty ? translated : '$tag $translated');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText ?? widget.originalText,
      style: widget.style,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
