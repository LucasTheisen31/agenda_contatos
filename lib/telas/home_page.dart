
import 'dart:io';
import 'package:agenda_contatos/helpers/contato_helper.dart';
import 'package:flutter/material.dart';

import 'contact_page.dart';


class HomePage extends StatefulWidget {//widget statefull
  const HomePage({Key? key}) : super(key: key);//construtor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactSingleton singleton = ContactSingleton();//criando uma instancia da classe ContactHelper que vai fazer a comunicaçao com o banco de dados
  List<Contato> listaContatos = <Contato>[];


  @override
  void initState() {//metodo chamado ao iniciar o tela
    super.initState();
    _pegarAllContatos();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _exibirPaginaContato();//chama a funcao que exibe a tela de contatos pois vai criar um novo contato
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),//borda de 10 em todas as direçoes
          itemCount: listaContatos.length,//numero de elementos da lista
          itemBuilder: (context, index){
          return _cardContatos(context, index);
          }),
    );
  }

  Widget _cardContatos(BuildContext context, int index){
    return GestureDetector(
      onTap: (){
        _exibirPaginaContato(contato: listaContatos[index]);//chama a funcao para exibir o contato passando o contato do card, cada car possui 1 contato indicado pelo indice
      },//para pegar os gestos
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),//adiciona margem de 10 em todos os lados
          child: Row(//linha
            children:<Widget> [
              Container(//adiciona um container a linha
                height: 45,
                width: 45,
                decoration: BoxDecoration(//faz o container ficar arredondado para poder colocar a imagem
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/person.png"),
                    //listaContatos[index].imagem != null ? FileImage(File(listaContatos[index].imagem), scale: 1.0) : AssetImage("images/person.png") as ImageProvider
                  ),
                ),
              ),
              Padding(padding://adiciona margem entre a imagem e os dados
                EdgeInsets.only(left: 10),
                child: Column(//adiciona uma coluna dentro do padding onde vai ser exibido os dados
                  crossAxisAlignment: CrossAxisAlignment.start,//alinha os dados a esquerda
                  children:<Widget>[
                    Text(listaContatos[index].nome ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(listaContatos[index].email ?? "", style: TextStyle(fontSize: 18)),
                    Text(listaContatos[index].telefone ?? "", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),//adiciona margem entre a imagem e os dados
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exibirPaginaContato({Contato? contato}) async {
    final contatoRecuperado = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contato: contato,))//rota para a pagina do contato passando um contato(nameParamentro: paramentro),
      // quando chama o metodo navigator definimos para ele retornar o contato que esta sendo manipulado na pagina e então amazenamos em contatoRecuperado para poder salvar ou atualizar
    );
    if(contatoRecuperado != null){
      if(contato != null){//se foi enviado algum contato, ou seja tem algum contato sendo editado
        await singleton.atualizaContato(contatoRecuperado);//atualiza o contato
      }else{//se for um contato novo
        await singleton.salvarContato(contatoRecuperado);
      }
      _pegarAllContatos();//carrega todos os contatos atualizando a lista de contatos
    }
  }

  void _pegarAllContatos(){//funcao para buscar todos os contatos
    singleton.ConsultaTodosContatos().then((lista){//quando obter todos os contatos vai chamar a funcao passando uma lista
      setState(() {
        listaContatos = lista.cast<Contato>();//lista de contatos recebe a lista
      });
    });
  }
}
