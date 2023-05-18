// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/model.dart';
import 'package:untitled2/server.dart';
import 'package:untitled2/othwe_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    populateState();
  }

  void populateState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    listNote = prefs
        .getStringList("textNote")!
        .map((e) => Note.fromMap(json.decode(e)))
        .toList();

    setState(() {});
  }

  final textController = TextEditingController();

  final prefranceServer _prefrance = prefranceServer();

  List<Note>? listNote = [];

  addNoteTxt() async {
    final textNoteEdit = Note(textController.text);
    var textNote = await _prefrance.saveServer(textNoteEdit);
    listNote!.add(textNote);
    print(textNote);
    Navigator.of(context).pop();
  }

  update() async {
    final textNoteEdit = Note(textController.text);
    final prefrance = await _prefrance.getServer();
  }

  myDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonTheme(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      minWidth: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancelar"),
                      )),
                  ButtonTheme(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      minWidth: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (textController.text.isEmpty) {
                            null;
                          } else {
                            setState(() {
                              addNote(Note(textController.text));
                            });
                          }
                        },
                        child: const Text("Adicionar"),
                      )),
                ],
              )
            ],
            content: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Criar nota"),
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 20,
                      controller: textController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4)),
                          labelText: "Nota",
                          labelStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          hintStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(Icons.note)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget emptyList() {
    return Center(
        child: Text('Que vazio... -_-',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.black, letterSpacing: .5, fontSize: 15))));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: listNote!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = listNote![index];
        return Dismissible(
          key: Key(item.textNote.toString()),
          confirmDismiss: (DismissDirection direction) async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text(
                        "Tem certeza de que deseja excluir essa nota?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              listNote!.removeAt(index);
                              Navigator.of(context).pop();
                            });
                          },
                          child: const Text("Excluir")),
                    ],
                  );
                });
          },
          onDismissed: (DismissDirection direction) {
            setState(() {
              listNote!.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Apagado"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    setState(() {
                      listNote!.insert(index, item);
                    });
                  },
                ),
              ));
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.centerLeft,
              height: 70,
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(item.textNote,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          ),
        );
      },
    );
  }

  void saveData() async {
    List<String> stringList =
        listNote!.map((item) => json.encode(item.toMap())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('textNote', stringList);
    print(prefs.getStringList('textNote'));
  }

  void addNote(Note note) {
    listNote!.add(note);
    saveData();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const LoginUi();
                }));
              },
              child: const Text("Ir"))
        ],
        title: Text('Bloco de Notas',
            style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(color: Colors.black, letterSpacing: .5))),
        centerTitle: true,
      ),
      body: listNote!.isEmpty ? emptyList() : buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myDialog();
        },
        child: const Icon(Icons.note_add_rounded),
      ),
    );
  }
}
