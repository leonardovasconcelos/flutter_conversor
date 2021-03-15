import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; //importando a biblioteca http
import 'dart:async'; //requisição assíncrona


const request = "https://api.hgbrasil.com/finance?format=json&key=8c62b73a&symbol";

void main() async{

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    )
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _verifyEmpty(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
  }

  void _realChanged(String text){

    _verifyEmpty(text);

    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){

    _verifyEmpty(text);

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){

    _verifyEmpty(text);

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return mensagem_retorno("Carregando Dado...");

              default:
                if(snapshot.hasError){
                  return mensagem_retorno("Erro ao Carregar Dados :(");
                } else{
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView( // permite rolar a tela
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€\$", euroController, _euroChanged),

                      ],
                    ),
                  );
                }
            }
          }
      )

    );
  }
}


Future<Map> getData() async{
  http.Response response = await http.get(request); //retorna os dados no futuro
  return json.decode(response.body);
}

mensagem_retorno(String mensagem){
  return Center(
      child: Text(mensagem,
        style: TextStyle(
            color:  Colors.amber,
            fontSize: 25.0
        ),
        textAlign: TextAlign.center,
      )
  );
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
