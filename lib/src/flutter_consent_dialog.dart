import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_consent_flow.dart';

class FlutterConsentDialog extends StatelessWidget {
  const FlutterConsentDialog({
    Key? key,
    required this.regulatoryFramework,
    required this.appIcon,
    required this.appName,
    required this.privacyPolicyLink,
    this.intro =
        'We care about your privacy and data security. We keep this app safe by showing ads.',
    this.question = 'Can we continue to use your data to tailor ads for you?',
    this.positiveButtonText = 'Yes, continue to see relevant ads',
    this.negativeButtonText = 'No, see ads that are less relevant',
  }) : super(key: key);

  final RegulatoryFramework regulatoryFramework;
  final ImageProvider<Object>? appIcon;
  final String appName;
  final String privacyPolicyLink;
  final String intro;
  final String question;
  final String positiveButtonText;
  final String negativeButtonText;

  String _getQuestion() {
    return question;
  }

  String _getFooterContent() {
    switch (regulatoryFramework) {
      case RegulatoryFramework.gdpr:
      case RegulatoryFramework.ccpa:
        return 'Our partners will collect data and use a unique identifier on your device to show you personalized ads. You can change your choice anytime for $appName in the app settings.';
      case RegulatoryFramework.lgpd:
        return 'Nossos parceiros coletarão dados e usarão um identificador único no seu dispositivo para exibir anúncios personalizados. Você pode alterar sua escolha a qualquer momento para $appName nas configurações do aplicativo.';
      case RegulatoryFramework.notApplied:
        return 'Our partners will collect data and use a unique identifier on your device to show you personalized ads. You can change your choice anytime for $appName in the app settings.';
    }
  }

  String _getComplianceIndicator() {
    switch (regulatoryFramework) {
      case RegulatoryFramework.gdpr:
        return 'GDPR Compliant';
      case RegulatoryFramework.ccpa:
        return 'CCPA Compliant';
      case RegulatoryFramework.lgpd:
        return 'LGPD Compliant';
      case RegulatoryFramework.notApplied:
        return 'Not Regulated';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (appIcon != null) ...[
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: appIcon,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (regulatoryFramework != RegulatoryFramework.notApplied)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getComplianceIndicator(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                intro,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: Text(
                _getQuestion(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _getFooterContent(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  try {
                    launchUrl(
                      Uri.parse(privacyPolicyLink),
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: Text(
                  'Learn how $appName and our partners collect and use data.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                // Handle user accepting consent
                Navigator.pop(context, true);
              },
              child: Text(positiveButtonText),
            ),
            TextButton(
              onPressed: () {
                // Handle user declining consent
                Navigator.pop(context, false);
              },
              child: Text(negativeButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
