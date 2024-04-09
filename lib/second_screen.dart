import 'package:dofromscratch/class/book_titles.dart';
import 'package:dofromscratch/class/epub_to_list.dart';
import 'package:dofromscratch/test_screen.dart';
//import 'package:dofromscratch/test_screen.dart';
//import 'package:dofromscratch/views/scrollbar_exp.dart';
//import 'package:dofromscratch/views/scrollbar_exp2.dart';
import 'package:dofromscratch/views/scrollbar_exp3.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async{ 
              BuildContext currentContext = context;
              GetListFromEpub getList = GetListFromEpub(name:'eliot-felix-holt-the-radical.epub');
              var htmlAndTitle = await getList.parseEpubWithChapters(); 
              List<String> htmlList =    htmlAndTitle.item1;          
              String fullHtml = htmlList.last;
              htmlList.length = htmlList.length-1;  
              List<BookTitle> titles = htmlAndTitle.item2;

              // Use the captured context inside the async function.
              if (!currentContext.mounted) return;
              await Navigator.of(currentContext).push(MaterialPageRoute(
                builder: (context) => ScrollBarExp3(
                  data: htmlList,
                  page: 1,
                  location: 0,
                  fullHtml: fullHtml,
                  titles: titles,
                ),
              ));         
            },
            child: const Text('Open ScrollbarExp'),
          ),
                    
          const SizedBox(height: 10),          
          ElevatedButton(
            onPressed: () { saveFromAssetToLocal();},
            child: const Text('Save file to local'),
          ), 
          const SizedBox(height: 10),          
          ElevatedButton(
            onPressed: () async{ 
              BuildContext currentContext = context;
              GetListFromEpub getList = GetListFromEpub(name:'eliot-felix-holt-the-radical.epub');
              var htmlAndTitle = await getList.parseEpubWithChapters(); 
              List<String> htmlList =    htmlAndTitle.item1;          
              String fullHtml = htmlList.last;
              htmlList.length = htmlList.length-1;  
              List<BookTitle> titles = htmlAndTitle.item2;

              if (!currentContext.mounted) return;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageHtmlParser(
                  key: UniqueKey(),
                  lastLocation: 0,
                  titles: titles,
                  fullHtml: fullHtml,
                  textSize: 16,
                ),
              ));
            },
            child: const Text('Go to test Screen'),
          ), 
            
        ],
      ),
    );
  }
  
  Future<void> saveFromAssetToLocal() async{
    
    var dir = await getApplicationDocumentsDirectory();

    // Specify the asset file name
    String filename = 'eliot-felix-holt-the-radical.epub';
    
    io.File file = io.File('${dir.path}/$filename');
    

    ByteData data = await rootBundle.load('assets/$filename');
    List<int> bytes = data.buffer.asUint8List();

    await file.writeAsBytes(bytes);
  }
  
 
}