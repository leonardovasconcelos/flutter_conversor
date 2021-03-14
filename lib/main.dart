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
  double dolar;
  double euro;


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
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$"
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Dólares",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "US\$"
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Euros",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "€\$"
                          ),
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0
                          ),
                        )
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