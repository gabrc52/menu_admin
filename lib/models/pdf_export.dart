import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'constants.dart';

const double _headerFontSize = 10;
const double _tableFontSize = 9;
const double _footerFontSize = 8;

String _hoy() {
  DateTime now = DateTime.now();
  return '${now.day}/${meses[now.month]}/${now.year}';
}

Widget _buildHeaderText({bool bold = false, required String text}) {
  return Center(
    child: Text(
      text,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: _headerFontSize,
      ),
    ),
  );
}

Widget _buildFooterText({required String text}) {
  return Text(
    text,
    textAlign: TextAlign.right,
    style: const TextStyle(
      fontSize: _footerFontSize,
    ),
  );
}

Widget _buildTableHeader(int week) {
  return Table(
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    defaultColumnWidth: const FractionColumnWidth(1 / 7),
    children: [
      TableRow(
        children: [
          for (int i = 7 * week; i < 7 * week + 7; i++)
            Container(
              padding: const EdgeInsets.all(0.5 * PdfPageFormat.mm),
              alignment: Alignment.center,
              child: Text(
                '${diasCompletos[i % 7]} ${i + 1}',
                style: const TextStyle(color: PdfColors.white),
                textAlign: TextAlign.center,
              ),
            ),
        ],
        decoration: const BoxDecoration(
          color: PdfColors.blueGrey,
        ),
      ),
    ],
  );
}

Widget _buildMealHeader(String meal) {
  return Table(
    children: [
      TableRow(
        children: [
          Center(
            child: Text(
              meal,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        decoration: const BoxDecoration(color: PdfColors.amber),
      ),
    ],
  );
}

Widget _buildMealTable({
  required int week,
  required int mealIndex,
  required Map<String, dynamic> menu,
}) {
  return Table(
    defaultColumnWidth: const FractionColumnWidth(1 / 7),
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    border: TableBorder.all(),
    children: [
      for (int item = 0; item < 8; item++)
        TableRow(
          children: [
            for (int i = 7 * week; i < 7 * week + 7; i++)
              Container(
                padding: const EdgeInsets.all(0.1 * PdfPageFormat.mm),
                alignment: Alignment.center,
                child: Text(
                  '${menu['${i + 1}'][mealIndex][item] ?? '---'}',
                  style: TextStyle(
                    fontSize: _tableFontSize,
                    fontWeight: item == 2 ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
    ],
  );
}

List<Widget> _buildHeader({required int week}) {
  return [
    _buildHeaderText(text: 'Universidad Autónoma Chapingo'),
    _buildHeaderText(text: 'Dirección General de Administración'),
    _buildHeaderText(text: 'Subdirección de Servicios Asistenciales'),
    _buildHeaderText(text: 'Departamento de Alimentación - Comedor central'),
    _buildHeaderText(text: 'Menú Cíclico', bold: true),
    _buildHeaderText(text: 'Semana ${week + 1}'),
    SizedBox(
      height: 1 * PdfPageFormat.mm,
    ),
  ];
}

List<Widget> _buildTable(
    {required int week, required Map<String, dynamic> menu}) {
  return [
    _buildTableHeader(week),
    _buildMealHeader('DESAYUNO'),
    _buildMealTable(week: week, mealIndex: 0, menu: menu),
    _buildMealHeader('COMIDA'),
    _buildMealTable(week: week, mealIndex: 1, menu: menu),
    _buildMealHeader('CENA'),
    _buildMealTable(week: week, mealIndex: 2, menu: menu),
  ];
}

List<Widget> _buildFooter() {
  return [
    SizedBox(
      height: 2 * PdfPageFormat.mm,
    ),
    Expanded(
      child: Container(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildFooterText(
                text:
                    'Menú sujeto a cambios por disponibilidad de materia prima y operatividad en los comedores'),
            _buildFooterText(
                text:
                    'Compras, Almacén, Comisión de Alimentación CGR-CEE, Jefes de comedor, Subdirección de Servicios Asistenciales, Jefes de Operaciones'),
            _buildFooterText(
                text: 'PDF Generado con app Menú Chapingo el ${_hoy()}'),
          ],
        ),
      ),
    ),
  ];
}

Future<Uint8List> generatePdf(String jsonString) async {
  Map<String, dynamic> menu = json.decode(jsonString);
  final pdf = Document(
    producer: 'Menú Chapingo',
    title: 'Menú Cíclico UACh',
    author: 'Comisión de Alimentación',
  );
  for (int week = 0; week < 8; week++) {
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.letter.landscape,
        margin: const EdgeInsets.all(5 * PdfPageFormat.mm),
        build: (Context context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildHeader(week: week),
              ..._buildTable(menu: menu, week: week),
              ..._buildFooter(),
            ],
          );
        },
      ),
    );
  }
  return await pdf.save();
}
