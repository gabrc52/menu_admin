import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:menu_admin/models/info.dart';

class InfoEditPage extends StatefulWidget {
  final String? id;
  final Info? info;

  const InfoEditPage({Key? key, this.id, this.info}) : super(key: key);

  @override
  State<InfoEditPage> createState() => InfoEditPageState();
}

/// TODO: make it actually save

class InfoEditPageState extends State<InfoEditPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now().toUtc();
  bool showEveryDay = false;
  IconData icon = Icons.info;

  @override
  void initState() {
    if (widget.info != null) {
      if (widget.info!.date != null) {
        date = widget.info!.date!;
      }
      showEveryDay = widget.info!.isGlobal;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final aYearAgo = DateTime.now().add(const Duration(days: -365));
    final inAYear = DateTime.now().add(const Duration(days: 365));
    return Form(
      onChanged: () {},
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
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Hoy solo abre el campestre',
              ),
              initialValue: widget.info == null ? null : widget.info!.title,
              maxLines: null, // so it autoexpands
              key: const Key('title'),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subtítulo',
                hintText:
                    'Esto es debido a la huelga. Toca para ver la publicación de la Comisión de Alimentación',
              ),
              initialValue:
                  (widget.info != null && widget.info!.subtitle != null)
                      ? widget.info!.subtitle!
                      : null,
              maxLines: null,
              key: const Key('subtitle'),
            ),
          ],
        ),
      ),
    );
  }
}
