import 'dart:ffi';

import 'package:flutter/material.dart';

void main() => runApp(BytebankApp());

// ignore: use_key_in_widget_constructors
class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple
        ).copyWith(secondary: Colors.deepPurple[700]),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple[700],
            )),
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.indigo[700],
            textTheme: ButtonTextTheme.primary),
      ),
      home: ListaTransferencias(),
    );
  }
}
class FormularioTransferencia extends StatefulWidget {
  FormularioTransferencia({Key? key}) : super(key: key);




  @override
  State<StatefulWidget> createState() {
    return FormularioTranferenciaState();
  }
}

class FormularioTranferenciaState extends State<FormularioTransferencia> {

  final TextEditingController _controladorCampoNumeroConta =
  TextEditingController();
  final TextEditingController _controladorCampoValor =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criando Tranferência'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Editor(
                controlador: _controladorCampoNumeroConta,
                rotulo: 'Numero da conta',
                dica: '0000',
              ),
              Editor(
                controlador: _controladorCampoValor,
                rotulo: 'Valor',
                dica: '0.00',
                icone: Icons.monetization_on,
              ),
              ElevatedButton(
                child: Text('Confirmar'),
                onPressed: () => _criaTranferencia(context),
              )
            ],
          ),
        ));
  }


  void _criaTranferencia(BuildContext context) {
    final int? numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(_controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint('criando transferencia');
      debugPrint('$transferenciaCriada');
      //naviagtor pop=  navegar de uma ionterface pra outra
      Navigator.pop(context, transferenciaCriada);
    }
  }
}


class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        // especificar o tipo de teclado que será exibido, nesse caso o numérico
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];



  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}
class ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transferências"),
      ),
      /*mudando de column para listview porque column tem limitação de células e list view é feito para escrolar elementos estáticos
     sem atualização dinâmica, com atualização dinâmica é necessário utilizar o listview.builder*/

      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            Future.delayed(Duration(seconds: 1), () {
              debugPrint('chegou no then do future');
              debugPrint('$transferenciaRecebida');
              if(transferenciaRecebida != null) {
                setState(() {
                  widget._transferencias.add(transferenciaRecebida);
                });
                }
              });
          });
        },
      ),
    );
  }


}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}
