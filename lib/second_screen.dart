import 'package:dofromscratch/views/scrollbar_exp.dart';
import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart';
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


              List<String> htmlList = await parseEpub();              
              String fullHtml = htmlList.last;
              htmlList.length = htmlList.length-1;  

              // Use the captured context inside the async function.
              if (!currentContext.mounted) return;
              await Navigator.of(currentContext).push(MaterialPageRoute(
                builder: (context) => ScrollBarExp(
                  data: htmlList,
                  page: 7,
                  location: 825.2164322,
                  fullHtml: fullHtml,
                ),
              ));         
            },
            child: const Text('Open ScrollbarExp'),
          ),
                    
          const SizedBox(height: 10),          
          ElevatedButton(
            onPressed: () { parseEpub();},
            child: const Text('Parse epub'),
          ),          
        ],
      ),
    );
  }
  
  Future<void> saveFromAssetToLocal() async{
    
    var dir = await getApplicationDocumentsDirectory();

    // Specify the asset file name
    String filename = 'eliot-small.epub';
    
    io.File file = io.File('${dir.path}/$filename');
    

    ByteData data = await rootBundle.load('assets/$filename');
    List<int> bytes = data.buffer.asUint8List();

    await file.writeAsBytes(bytes);
  }
 
  Future<List<String>> parseEpub() async{
    await saveFromAssetToLocal();

    var dir = await getApplicationDocumentsDirectory();

    // Specify the asset file name
    String filename = 'eliot-small.epub';
    
    io.File file = io.File('${dir.path}/$filename');
    List<int> bytes = await file.readAsBytes();


    // Opens a book and reads all of its content into memory
    EpubBook epubBook = await EpubReader.readBook(bytes);

    // Extract HTML content    
    
    EpubContent bookContent = epubBook.Content!;
        // All XHTML files in the book (file name is the key)
    Map<String, EpubTextContentFile> htmlFiles = bookContent.Html!;

    String htmlContent = "";
    List<String> list = []; 

    for (EpubTextContentFile htmlFile in htmlFiles.values) {
      htmlContent += htmlFile.Content!; 

      String delimiter = "<pagebr></pagebr>";
      int delimiterIndex = htmlFile.Content!.indexOf(delimiter);
      
      if (delimiterIndex != -1) {
        int startIndex = 0;

        while (delimiterIndex != -1) {
          list.add(htmlFile.Content!.substring(startIndex, delimiterIndex).trim());
          startIndex = delimiterIndex + delimiter.length;
          
          delimiterIndex = htmlFile.Content!.indexOf(delimiter, startIndex);
        }

        // Add the remaining content if any
        if (startIndex < htmlFile.Content!.length) {
          list.add(htmlFile.Content!.substring(startIndex).trim());
        }
      }
      else{
        list.add(htmlFile.Content!.trim());
      }
    }

    list.add(htmlContent);
    return list;
  }
 
}