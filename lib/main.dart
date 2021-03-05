import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; //importando a biblioteca http
import 'dart:async'; //requisição assíncrona


const request = "https://api.hgbrasil.com/finance?format=json&key=8c62b73a&symbol";

void main() async{

  runApp(MaterialApp(
    home: Home(),
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  return Container(color: Colors.green,);
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