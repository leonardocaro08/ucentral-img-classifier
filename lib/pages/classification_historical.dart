import 'package:flutter/material.dart';
import 'package:img_classifier/models/classification.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'package:img_classifier/pages/loading_page.dart';

final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

late UserService userClassService;

BuildContext? _context;

class ClassificationsPage extends StatelessWidget {
  const ClassificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    _context = context;
    userClassService = Provider.of<UserService>(context);
    if (userClassService.classifications == null)
      userClassService.loadUserClassifications();
    if (userClassService.loadClassifications) return LoadingPage();
    return WillPopScope(
      onWillPop: () async => await cerrarPantalla(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Classifications'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async => await cerrarPantalla(),
          ),
        ),
        body: Center(
          child: userClassService.classifications!.isNotEmpty
              ? ListView.builder(
                  itemCount: userClassService.classifications!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ClassificationCard(
                          title: crearTitulo(
                              userClassService.classifications![index]),
                          subtitle:
                              '${userClassService.classifications![index].classification_label}'))
              : Text('No hay clasificaciones registradas en la cuenta'),
        ),
      ),
    );
  }

  String crearTitulo(Classification classification) {
    final String fecha_formateada = formatter.format(classification.date);
    return '$fecha_formateada';
  }

  Future<bool> cerrarPantalla() async {
    Navigator.of(_context!).pop();
    await Navigator.of(_context!).maybePop();
    userClassService.classifications = null;
    return true;
  }
}

class ClassificationCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const ClassificationCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.black12,
            width: 1,
          )),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.history,
                size: 40,
              ), // Añade un icono de historia
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 20, // Incrementa el tamaño de fuente
                  fontWeight: FontWeight.bold, // Hace el texto en negrita
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 18, // Incrementa el tamaño de fuente
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
