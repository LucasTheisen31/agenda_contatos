import 'dart:io';

import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:flutter/material.dart';


class ContactPage extends StatefulWidget {//widget Statefull

  final Contato? contato;

  //construtor da classe

  ContactPage({this.contato});//{} pois o parametro é opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorTelefone = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _contatoFoiEditado = false;

  Contato ?_editedContato;

  @override
  void initState() {//metodo chamado quando a pagina iniciar
      super.initState();

      if(widget.contato == null){//se for um contato novo, se nao foi passado um contato para editar
        _editedContato = Contato();//_editedContato = new Contato();
      }else{
        _editedContato = Contato.fromMap(widget.contato!.toMap());//pega os dados do contato do widget e converte para um mapa
        // e apos isso converte em um contato passando para o contato _editedContato, ou seja copia um contato para _editedContato
      }

      //ao iniciar a pagina tamber quero que os controladores dos text Field recebam os dados do contato que foi passado
      _controladorNome.text = _editedContato!.nome!;
      _controladorEmail.text = _editedContato!.email!;
      _controladorTelefone.text = _editedContato!.telefone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_editedContato!.nome ?? "Novo Contato"),//se nao tiver um contato ja, coloca o nome como novo contato, caso coontrario exibe o nome do contato
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(//botao de salvar contato
        onPressed: (){
          if(_editedContato!.nome!.isNotEmpty && _editedContato!.nome != null){
            Navigator.pop(context, _editedContato);//vai voltar pra tela anterior, e retorna o contato _editedContato
          }else{//caso o campo do nome esteja vazio
            FocusScope.of(context).requestFocus(_nomeFocus);//colocamos o foco no textFild nome
          }
        },
        child: Icon(Icons.save),//no icon poderia adicionar a cor do icone
        backgroundColor: Colors.blue,//cor do botao
      ),
      body: SingleChildScrollView(//Uma caixa na qual um único widget pode ser rolado.
        padding: EdgeInsets.all(10),//margem em todos os lados
        child: Center(
          child: Column(
            children:<Widget> [
              GestureDetector(//para poder clicar na imagem
                child: Container(//adiciona um container onde vamos colocar a imagem
                  height: 131,
                  width: 131,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,//faz o container ficar arredondado para poder colocar a imagem
                    image: DecorationImage(
                      image: _editedContato!.imagem != null ? FileImage(File(_editedContato!.imagem.toString())) : AssetImage("images/person.png") as ImageProvider,
                    ),
                  ),
                ),
              ),
             TextField(
               controller: _controladorNome,
               focusNode: _nomeFocus,//usado para controlar o foco do text field
               decoration: InputDecoration(labelText: "Nome"),//label é o nome acima do textField
               onChanged: (text){//ao modificar o formulario passa o texto do text field
                 _contatoFoiEditado = true;
                 setState(() {
                   _editedContato!.nome = text;
                 });
               },
             ),
              TextField(
                controller: _controladorEmail,
                decoration: InputDecoration(labelText: "Email"),//label é o nome acima do textField
                onChanged: (text){//ao modificar o formulario passa o texto do text field
                  _contatoFoiEditado = true;
                  _editedContato!.email = text;
                },
                keyboardType: TextInputType.emailAddress,//define o tipo de dado do textField
              ),
              TextField(
                controller: _controladorTelefone,
                decoration: InputDecoration(labelText: "Telefone"),//label é o nome acima do textField
                onChanged: (text){//ao modificar o formulario passa o texto do text field
                  _contatoFoiEditado = true;
                  _editedContato!.telefone = text;
                },
                keyboardType: TextInputType.phone,//define o tipo de dado do textField
              ),
            ],
          ),
        ),

      ),
    );
  }
}
