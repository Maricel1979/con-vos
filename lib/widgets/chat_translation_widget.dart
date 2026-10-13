import 'package:flutter/material.dart';

import '../translation_service.dart';

class ChatTranslationWidget extends StatefulWidget {
  final String senderName;
  final String originalText;

  const ChatTranslationWidget({
    Key? key,
    required this.senderName,
    required this.originalText,
  }) : super(key: key);

  @override
  State<ChatTranslationWidget> createState() => _ChatTranslationWidgetState();
}

class _ChatTranslationWidgetState extends State<ChatTranslationWidget> {
  String _targetLanguage = 'es';
  String? _translatedText;
  bool _isTranslating = false;

  Future<void> _translate() async {
    setState(() {
      _isTranslating = true;
    });

    final translation = await TranslationService.translateText(
      text: widget.originalText,
      targetLanguage: _targetLanguage,
    );

    setState(() {
      _translatedText = translation;
      _isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.senderName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              DropdownButton<String>(
                value: _targetLanguage,
                dropdownColor: Colors.black87,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'es', child: Text('🇪🇸 ES')),
                  DropdownMenuItem(value: 'en', child: Text('🇺🇸 EN')),
                  DropdownMenuItem(value: 'pt', child: Text('🇧🇷 PT')),
                  DropdownMenuItem(value: 'fr', child: Text('🇫🇷 FR')),
                ],
                onChanged: (String? newLang) {
                  if (newLang != null) {
                    setState(() {
                      _targetLanguage = newLang;
                    });
                    _translate();
                  }
                },
              ),
            ],
          ),
          Text(
            widget.originalText,
            style: const TextStyle(color: Colors.white70),
          ),
          if (_isTranslating)
            const SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.deepPurpleAccent,
              ),
            )
          else if (_translatedText != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                '🌐 $_translatedText',
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
