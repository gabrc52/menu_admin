import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:menu_admin/models/constants.dart';
import 'package:menu_admin/models/info.dart';

class InfoEditPage extends StatefulWidget {
  final String id;
  final Info? info;

  const InfoEditPage({Key? key, required this.id, this.info}) : super(key: key);

  @override
  State<InfoEditPage> createState() => InfoEditPageState();
}

class InfoEditPageState extends State<InfoEditPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now().toUtc();
  bool showEveryDay = false;
  IconData icon = Icons.info;
  String? title;
  String? subtitle;
  String? url;

  Future<bool> update() async {
    if (_formKey.currentState!.validate()) {
      await infoRef.doc(widget.id).set(
            Info(
              date: date,
              icon: icon,
              isGlobal: showEveryDay,
              title: title,
              subtitle: subtitle,
              url: url,
            ),
          );
      return true;
    }
    return false;
  }

  @override
  void initState() {
    if (widget.info != null) {
      if (widget.info!.date != null) {
        date = widget.info!.date!;
      }
      showEveryDay = widget.info!.isGlobal;
      if (widget.info!.title != null) {
        title = widget.info!.title;
      }
      if (widget.info!.subtitle != null) {
        title = widget.info!.subtitle;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final aYearAgo = DateTime.now().add(const Duration(days: -365));
    final inAYear = DateTime.now().add(const Duration(days: 365));
    return Form(
      onWillPop: update,
      onChanged: () {
        update();
      },
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar aviso'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mostrar todos los días'),
              value: showEveryDay,
              onChanged: (val) {
                setState(() {
                  showEveryDay = val;
                });
                update();
              },
            ),
            if (!showEveryDay)
              ListTile(
                title: const Text('Fecha'),
                leading: const Icon(Icons.today),
                trailing: Text(date.toString().split(' ')[0]),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: aYearAgo,
                    lastDate: inAYear,
                  );
                  if (selectedDate != null) {
                    setState(() {
                      date = selectedDate;
                    });
                    update();
                  }
                },
              ),
            ListTile(
              leading: Icon(icon),
              title: const Text('Icono'),
              onTap: () async {
                final data = await FlutterIconPicker.showIconPicker(
                  context,
                  searchHintText: 'Buscar (en inglés)',
                  title: const Text('Selecciona un icono'),
                  closeChild: const Text('Cerrar'),
                );
                if (data != null) {
                  setState(() {
                    icon = data;
                  });
                  update();
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Hoy solo abre el campestre',
                helperText: 'Mensaje principal o resumen, aparece más grande',
              ),
              initialValue: widget.info == null ? null : widget.info!.title,
              maxLines: null, // so it autoexpands
              onChanged: (val) {
                title = val;

                /// I am updating here too because if I only update in the `Form`,
                /// it doesn't save the last character for some reason unless you
                /// change another field. Maybe a bug? TODO: report if so
                update();
              },
              key: const Key('title'),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subtítulo',
                hintText:
                    'Esto es debido a la huelga. Toca para ver la publicación de la Comisión de Alimentación',
                helperText: 'Detalles sobre el aviso',
              ),
              initialValue:
                  (widget.info != null && widget.info!.subtitle != null)
                      ? widget.info!.subtitle!
                      : null,
              maxLines: null,
              onChanged: (val) {
                if (val == '') {
                  subtitle = null;
                } else {
                  subtitle = val;
                }
                update();
              },
              key: const Key('subtitle'),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText:
                    'https://www.facebook.com/ComisionDeAlimentacion/posts/2514354238780986/',
                helperText:
                    'Página o aplicación que se abrirá al tocar el aviso. Se permiten "url schemes".',
              ),
              initialValue: (widget.info != null && widget.info!.url != null)
                  ? widget.info!.url!
                  : null,
              onChanged: (val) {
                if (val == '') {
                  url = null;
                } else {
                  url = val;
                }
                update();
              },
              key: const Key('url'),
              validator: (value) {
                if (value != null) {
                  final uri = Uri.tryParse(value);

                  if (value != '' && !(uri?.hasScheme ?? false)) {
                    return 'Introduce un URL válido, empezando en https:// o algo similar.';
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
