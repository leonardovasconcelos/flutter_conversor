import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; //importando a biblioteca http
import 'package:async/async.dart'; //requisição assíncrona


const request = "https://api.hgbrasil.com/finance?format=json&key=8c62b73a&symbol";

void main() async{

  http.Response response = await http.get(request); //não retorna os dados na hora
  print(json.decode(response.body)["results"]["currencies"]["USD"]);
  runApp(MaterialApp(
    home: Container()
  ));
}