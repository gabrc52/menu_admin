import 'package:flutter/material.dart';
import 'package:menu_admin/models/feedback_entry.dart';

class FeedbackViewPage extends StatefulWidget {
  const FeedbackViewPage({super.key, required this.entry});

  final FeedbackEntry entry;

  @override
  State<FeedbackViewPage> createState() => _FeedbackViewPageState();
}

class _FeedbackViewPageState extends State<FeedbackViewPage> {
  final _formKey = GlobalKey<FormState>();
  String? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry.type == null
            ? 'Retroalimentación'
            : 'Retroalimentación sobre ${widget.entry.type}'),
      ),
      body: Form(
        key: _formKey,
        onWillPop: () async {
          if (_formKey.currentState!.validate()) {
            final sureDiscard = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text(
                  '¿Estás seguro que deseas abandonar la respuesta?',
                ),
                actions: [
                  TextButton(
                    child: const Text('Sí'),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  TextButton(
                    child: const Text('No'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            );
            return sureDiscard!;
          } else {
            return true;
          }
        },
        child: Column(
          children: [
            TextFormField(
              onSaved: (textFieldResponse) {
                // https://stackoverflow.com/a/61070122/5031798
                response = textFieldResponse!;
              },
              decoration: const InputDecoration(
                hintText: 'Escribe tu respuesta aquí',
              ),
              maxLines: null, // so it autoexpands
              key: const Key('title'),
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Debes escribir algo para poder responder';
                } else {
                  return null;
                }
              },
            ),
            // TODO: remove
            // ElevatedButton(
            //   onPressed: () {
            //     for (var row in fromGoogle) {
            //       row['date'] = DateTime.parse(row['date']!);
            //       db.collection('feedback').add(row);
            //     }
            //   },
            //   child: const Text('IMPORT FROM GOOGLE SHEETS'),
            // ),
            OutlinedButton.icon(
              icon: const Icon(Icons.message),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final formState = _formKey.currentState!;
                if (formState.validate()) {
                  formState.save();
                  try {
                    // TODO: (1) ask for confirmation, (2) show success
                    await widget.entry.respondWithNotification(response!);
                    navigator.pop();
                  } catch (e) {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text('$e'),
                        );
                      },
                    );
                  }
                }
              },
              label: const Text('Enviar notificación'),
            ),
            Expanded(
              child: ListView(
                children: [ListTile(title: Text(widget.entry.feedback))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
