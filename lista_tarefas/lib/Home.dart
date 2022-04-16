
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefa = [] ;

  Future<File>  _getFile() async{
    var diretorio = await getApplicationDocumentsDirectory(); // pegando o caminho
    return File( "${diretorio.path}/dados.json" );
  }

  _salvarAquivo() async  {

    var arquivo = await _getFile();

    //criar os dados

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = "Ir ao mercado";
    tarefa['realizada'] = false;
    _listaTarefa.add(tarefa);

    String dados = json.encode(_listaTarefa); // transformando em json
    arquivo.writeAsString(dados);

  }

  _lerarquivo() async {

    try{

      final arquivo = await _getFile();
      return arquivo.readAsString();

    }catch(e){
      return null;
    }

  }
  @override
  void initState() { // carrega antes do build

    super.initState();

    _lerarquivo().then( (dados ) {
      setState(() {
        _listaTarefa = json.decode(dados); // recuperando os dados no arquivo ao iniciar o app
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    //_salvarAquivo();
    print("itens: " + _listaTarefa.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: (){

          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Digite sua arefa"
                    ),
                    onChanged: (text){

                    },
                  ),
                  actions: <Widget> [
                    TextButton(
                        onPressed: ()=>Navigator.pop(context),
                        child: Text("Cancelar")
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")
                    )
                  ],
                );
              }
          );
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: _listaTarefa.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text(_listaTarefa[index]["titulo"]),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}