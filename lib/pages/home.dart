
import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: "Metallica", votes: 5),
    Band(id: '2', name: "Queen", votes: 2),
    Band(id: '3', name: "Heroes del silencio", votes: 1),
    Band(id: '4', name: "Bon Jovi", votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    final sservice = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child:
            (sservice.serverStatus == ServerStatus.Online) 
            ? Icon(Icons.check_circle, color: Colors.green[300])
            : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index])
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: {direction}');
        // TODO: llamar el borrado del server
      },
      background: Container(
        padding: EdgeInsets.only(left: 9.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(
            color: Colors.white
          )),
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(band.votes.toString()),
        onTap: () {
          print('${band.name}');
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if(Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name: '),
            content: TextField(controller: textController),
            actions: [
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList(textController.text),
              )
            ],
          );
        },
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('New band name: '),
          content: CupertinoTextField(controller: textController),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    );

  }

  void addBandToList(String name) {
    print(name);
    if(name.length > 1) {
      // add band
      this.bands.add(
        new Band(id: DateTime.now().toString(), name: name, votes: 0)
      );
      setState(() {});
    }

    Navigator.pop(context);
  }
}