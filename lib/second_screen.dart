import 'package:dofromscratch/class/book_titles.dart';
import 'package:dofromscratch/class/epub_to_list.dart';
import 'package:dofromscratch/models/books.dart';
import 'package:dofromscratch/test_screen.dart';
//import 'package:dofromscratch/test_screen.dart';
//import 'package:dofromscratch/views/scrollbar_exp.dart';
//import 'package:dofromscratch/views/scrollbar_exp2.dart';
import 'package:dofromscratch/views/scrollbar_exp3.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_session_manager/flutter_session_manager.dart';


class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  String name = 'eliot-small.epub';
  String folder = 'eliot-small';

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
              GetListFromEpub getList = GetListFromEpub(name:name, folder: folder);
              var htmlAndTitle = await getList.parseEpubWithChapters(); 
              List<String> htmlList =    htmlAndTitle.item1;          
              String fullHtml = htmlList.last;
              htmlList.length = htmlList.length-1;  
              List<BookTitle> titles = htmlAndTitle.item2;

              int page = 0;
              double location = 0;

              bool checker = await SessionManager().containsKey("10001");
              if(checker)
              {
                HtmlBook book  = HtmlBook.fromJson( await SessionManager().get("10001"));
                page = book.page!;
                location = book.location;
              }

              // Use the captured context inside the async function.
              if (!currentContext.mounted) return;
              await Navigator.of(currentContext).push(MaterialPageRoute(
                builder: (context) => ScrollBarExp3(
                  bookId: '10001',
                  data: htmlList,
                  page: page,
                  location: location,
                  fullHtml: fullHtml,
                  titles: titles,
                ),
              ));         
            },
            child: const Text('Open ScrollbarExp'),
          ),
                    
          const SizedBox(height: 10),          
          ElevatedButton(
            onPressed: () { saveFromAssetToLocal(name, folder);},
            child: const Text('Save file to local'),
          ),

          
         
          const SizedBox(height: 10),          
          ElevatedButton(
            onPressed: () async{ 
              BuildContext currentContext = context;
              GetListFromEpub getList = GetListFromEpub(name:name, folder: folder);
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
  
  Future<void> saveFromAssetToLocal(String name, String folder) async{
    
    var dir = (await getApplicationDocumentsDirectory()).path;

    await createFolder(dir, folder);

    // Specify the asset file name
    String filename = name;
    
    io.File file = io.File('$dir/$folder/$filename');
    

    ByteData data = await rootBundle.load('assets/$filename');
    List<int> bytes = data.buffer.asUint8List();

    await file.writeAsBytes(bytes);
  }

  Future<void> createFolder(String path, String folderName) async {
    // Create a Directory instance at the specified path
    io.Directory newFolder = io.Directory('$path/$folderName');

    // Check if the folder already exists
    if (await newFolder.exists()) {
      //print('Folder already exists');
    } else {
      // Create the folder
      await newFolder.create();
      //print('Folder created at $path/$folderName');
    }
  }
 
}