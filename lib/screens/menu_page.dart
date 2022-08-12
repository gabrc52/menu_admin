import 'package:flutter/material.dart';
import 'package:menu_admin/dialog.dart';
import 'package:menu_admin/screens/menu_pdf_view.dart';
import 'package:webviewx/webviewx.dart';
import 'package:menu_admin/models/constants.dart';

Future<String> _getMenuJson() async {
  final snapshot = await menuRef.get();
  String jsonString = snapshot.get('rawData');

  /// Works around https://github.com/adrianflutur/webviewx/issues/76
  ///
  /// Si dejas los \n como \n entonces los interpreta como nuevas líneas
  /// y es JSON inválido y da error.
  // if (UniversalPlatform.isAndroid) {
  //   jsonString = jsonString.replaceAll('\\n', '\\\\n');
  // }
  return jsonString;
}

Future<String> _saveMenuJson(String json) async {
  /// Works around https://github.com/adrianflutur/webviewx/issues/76
  ///
  /// Revertimos lo de las comillas. Y por alguna razón escapa las comillas
  /// así que revertimos eso también
  // if (UniversalPlatform.isAndroid) {
  //   json = json.replaceAll('\\\\n', '\\n').replaceAll('\\"', '"');
  // }
  await menuRef.set({'rawData': json});
  return json;
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late WebViewXController webviewController;
  late String json;
  bool hasLoaded = false;
  bool pageLoaded = false;

  Future<void> _loadJson(BuildContext? context) async {
    try {
      json = await _getMenuJson();
      await webviewController.callJsMethod('abrirJson', [json]);
      hasLoaded = true;
      if (mounted && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Se cargó exitosamente')));
      }
    } on NoSuchMethodError catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> _saveJson(BuildContext? context) async {
    try {
      json = await webviewController.callJsMethod('guardarJson', []);
      final int numberOfEmptyFields = 'null'.allMatches(json).length;
      if (numberOfEmptyFields == 3 * 7 * 8 * 8) {
        if (mounted && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No se puede guardar porque está en blanco'),
          ));
        }
      } else {
        json = await _saveMenuJson(json);
        if (mounted && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Se guardó exitosamente')));
        }
      }
    } catch (e) {
      if (context != null) {
        showAlertDialog('$e', context, mounted);
      } else {
        debugPrint('$e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('init state called!');
    () async {
      /// Interestingly, it only works with 1 second and not like 100 ms
      while (!pageLoaded) {
        await Future.delayed(const Duration(seconds: 1));
      }
      await Future.delayed(const Duration(seconds: 1));
      _loadJson(null);
    }();
  }

  @override
  void dispose() {
    debugPrint('Dispose called!');
    _saveJson(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.file_open),
                onPressed: () {
                  if (hasLoaded) {
                    showDialog(
                      context: context,
                      builder: (_) => WebViewAware(
                        child: AlertDialog(
                          title:
                              const Text('¿Seguro que deseas cargar el menú?'),
                          content: const Text(
                              'Perderás los cambios (en caso de haberlos)'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _loadJson(context);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Sí, cargar'),
                            ),
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('No, mantener vesión actual'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    _loadJson(null);
                  }
                },
                label: const Text('Cargar menú'),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _saveJson(context);
                },
                label: const Text('Guardar menú'),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () async {
                  await _saveJson(context);
                  if (!mounted) return;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PdfViewPage(jsonString: json)));
                },
                label: const Text('Generar PDF'),
              ),
            ],
          ),
        ),
        Expanded(
          child: WebViewX(
            onWebViewCreated: (controller) async {
              webviewController = controller;
              await webviewController.loadContent(
                'assets/editor.html',
                SourceType.html,
                fromAssets: true,
              );
            },
            onPageFinished: (_) {
              pageLoaded = true;
            },
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ],
    );
  }
}
