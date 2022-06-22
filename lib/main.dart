
import 'package:agenda_contatos/telas/contact_page.dart';
import 'package:agenda_contatos/telas/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, //remove o banner de debug mode
    home: HomePage(),
  ));
}
