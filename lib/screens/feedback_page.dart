import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Por el momento, la retroalimentación se encuentra en Google Sheets.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                      'https://docs.google.com/spreadsheets/d/1-91NxgRx3yQFp85Ra2xL6_gpAzTYOUaz1Ikacp7ykwQ/edit'),
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: const Icon(Icons.launch),
              label: const Text('Abrir Google sheets'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Próximamente podrás ver los comentarios y contestar con una notificación desde aquí.',
                textAlign: TextAlign.center,
                style:
                    Theme.of(context).textTheme.caption!.copyWith(fontSize: 20),
              ),
            ),
            const Text('(insísteme para agregar eso)')
          ],
        ),
      ),
    );
  }
}
