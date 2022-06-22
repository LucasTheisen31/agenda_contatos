import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tabelaContato = "contactTable";
final String idColuna = "idColuna";
final String nomeColuna = "nomeColuna";
final String emailColuna = "emailColuna";
final String telefoneColuna = "telefoneColuna";
final String imagemColuna = "imagemColuna";

class ContactSingleton{//Classe Singleton, somente vai conter uma instancia no codigo todo

  static final ContactSingleton _instancia = ContactSingleton.internal();//static significa variavel da classe nao do objeto

  factory ContactSingleton(){
    return _instancia;
  }

  ContactSingleton.internal();

  Database ?_bancoDeDados;

  Future<Database?> get bancoDeDados async {//retorna o banco de dados
    if(_bancoDeDados != null){
      return _bancoDeDados;
    }else{
      _bancoDeDados = await iniciaBancoDeDados();//chama a funcao para iniciar o banco
      return _bancoDeDados;
    }
  }

  Future<Database> iniciaBancoDeDados() async {
      final bancoPath = await getDatabasesPath();//pega o caminho para a basta onde é armazenado o banco de dados
      final path =  join(bancoPath, "contatos.db");//junta o caminho da pasta com o nome do banco de dados e armazena em path

      return await openDatabase(path, version: 1, onCreate: (Database banco, int versao) async{//cria o banco de dados
        await banco.execute(
            "CREATE TABLE $tabelaContato("
                "$idColuna INTEGER PRYMARI KEY, AUTO INCREMENT "
                "$nomeColuna  TEXT, "
                "$emailColuna TEXT, "
                "$telefoneColuna TEXT, "
                "$imagemColuna TEXT )");
      });
  }

  //metodo para salvar
  Future<Contato> salvarContato(Contato contato) async{
    Database? dbContato = await bancoDeDados;//pega o banco
    contato.id = await dbContato!.insert(tabelaContato, contato.toMap());//quando execta um insert ele retorna o id
    return contato;
  }

  //metodo para pegar um contato no banco
  Future<Contato?> consultaUmContato(int id) async{
    Database? dbContato = await bancoDeDados;//pega o banco
    List<Map> maps = await dbContato!.query(tabelaContato, columns: [idColuna, nomeColuna, emailColuna, telefoneColuna, imagemColuna], where: "$idColuna = ?", whereArgs: [id]);
    if(maps.length>0){//verifica se foi retornado um contato
      return Contato.fromMap(maps.first);//pega os dados do map transforma em 1 contato e retorna
    }else{
      return null;
    }
  }

  //metodo para deletar 1 contato
  Future<int> deletaContato(int id) async{
    Database? dbContato = await bancoDeDados;//pega o banco
    return await dbContato!.delete(tabelaContato, where: "$idColuna = ?", whereArgs: [id]);//delete retorna 1 inteiro
  }

  //metodo para atualizar um contato
  Future<int> atualizaContato(Contato contato) async{
    Database? dbContato = await bancoDeDados;//pega o banco
    return await dbContato!.update(tabelaContato, contato.toMap(), where: "$idColuna = ?", whereArgs: [contato.id]);//update retorna 1 inteiro
  }

//metodo para buscar todos os contato
  Future<List> ConsultaTodosContatos() async{
    Database? dbContato = await bancoDeDados;//pega o banco
    List listaMap = await dbContato!.rawQuery("SELECT * FROM $tabelaContato");//cada mapa vai ser 1 contato, lista de mapas
    List<Contato> listaContatos = [];//lista de contatos
    for(Map m in listaMap){//para cada mapa na listaMap vai transformar em 1 contato
      listaContatos.add(Contato.fromMap(m));//converte em 1 contato e adiciona na listaContato
    }
    return listaContatos;
  }

  //metodo para retornar o numero de contatos da lista
  Future<int?> numeroCotatos() async{
    Database? dbContato = await bancoDeDados;//pega o banco
    return Sqflite.firstIntValue(await dbContato!.rawQuery("SELECT COUNT(*) FROM $tabelaContato)"));
  }

  //metodo para fechar a conexao com o banco
  Future closeBanco() async{
    Database? dbContato = await bancoDeDados;//pega o banco
    return dbContato!.close();//fecha a conexao
  }

}

//a tabela tera: id nome  email telefone  imagem

class Contato{
  //atributos
  int ?id;
  String ?nome;
  String ?email;
  String ?telefone;
  String ?imagem;

  //metodos
  Contato();//contrutor vazio

  Contato.fromMap(Map map){ //construtor -> pega os dados do map passa pro contato
    this.id = map[idColuna];
    this.nome = map[nomeColuna];
    this.email = map[emailColuna];
    this.telefone = map[telefoneColuna];
    this.imagem = map[imagemColuna];
  }

  Map<String,dynamic> toMap(){//converte os dados do contato e passa para um map
    Map<String,dynamic> map = {
      nomeColuna: nome,
      emailColuna: email,
      telefoneColuna: telefone,
      imagemColuna: imagem,
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override //sobrescrita
  String toString() {
    return ("ID: $id, Nome: $nome, Email: $email, Telefone: $telefone");
  }
}