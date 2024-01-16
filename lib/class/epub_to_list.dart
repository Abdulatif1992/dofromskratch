import 'package:dofromscratch/class/book_titles.dart';
import 'package:epubx/epubx.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
//it is for tuple function
import 'package:tuple/tuple.dart';

class GetListFromEpub {
  GetListFromEpub({required this.name,});

  final String name;
  
  Future <Tuple2<List<String>, List<BookTitle>>>   parseEpubWithChapters() async {
    var dir = await getApplicationDocumentsDirectory();
    String filename = name;
    
    io.File file = io.File('${dir.path}/$filename');
    List<int> bytes = await file.readAsBytes();


    // Opens a book and reads all of its content into memory
    EpubBook epubBook = await EpubReader.readBook(bytes);

    // Enumerating chapters
    String htmlContent = "";
    List<String> list = []; 
    int pageNumber = 0;
    List<BookTitle> titles = [];

    //for (EpubChapter chapter in epubBook.Chapters!) {
    for (int index = 0; index < epubBook.Chapters!.length; index++) {  
      EpubChapter chapter = epubBook.Chapters![index];
      // Title of chapter
      //String chapterTitle = chapter.Title!;

      titles.add(BookTitle(name: chapter.Title!, page: pageNumber, index: index));
                  
      // HTML content of current chapter
      String chapterHtmlContent = chapter.HtmlContent!;
      htmlContent += chapterHtmlContent;

      String delimiter = "<pagebr></pagebr>";
      int delimiterIndex = chapterHtmlContent.indexOf(delimiter);

      if (delimiterIndex != -1) {
        int startIndex = 0;

        while (delimiterIndex != -1) {
          list.add(chapterHtmlContent.substring(startIndex, delimiterIndex).trim());
          startIndex = delimiterIndex + delimiter.length;          
          delimiterIndex = chapterHtmlContent.indexOf(delimiter, startIndex);
          pageNumber += 1;
        }

        // Add the remaining content if any
        if (startIndex < chapterHtmlContent.length) {
          list.add(chapterHtmlContent.substring(startIndex).trim());
          pageNumber += 1;
        }
      }
      else{        
        list.add(chapterHtmlContent.trim());
        pageNumber += 1;
      }

      // Nested chapters
      // List<EpubChapter> subChapters = chapter.SubChapters!;
    }    

    list.add(htmlContent);
    return Tuple2(list, titles);
  }
  
  
  //Future<List<String>> parseEpub() async{

    // var dir = await getApplicationDocumentsDirectory();
    // String filename = name;
    
    // io.File file = io.File('${dir.path}/$filename');
    // List<int> bytes = await file.readAsBytes();


    // // Opens a book and reads all of its content into memory
    // EpubBook epubBook = await EpubReader.readBook(bytes);

    // // Extract HTML content    
    
    // EpubContent bookContent = epubBook.Content!;
    //     // All XHTML files in the book (file name is the key)
    // Map<String, EpubTextContentFile> htmlFiles = bookContent.Html!;

    // String htmlContent = "";
    // List<String> list = []; 
    // List<BookTitle> titles = [];
    // int pageNumber = 0;

    // for (EpubTextContentFile htmlFile in htmlFiles.values) {
    //   htmlContent += htmlFile.Content!; 

    //   String delimiter = "<pagebr></pagebr>";
    //   int delimiterIndex = htmlFile.Content!.indexOf(delimiter);
      
    //   if (delimiterIndex != -1) {
    //     int startIndex = 0;

    //     while (delimiterIndex != -1) {
    //       list.add(htmlFile.Content!.substring(startIndex, delimiterIndex).trim());
    //       startIndex = delimiterIndex + delimiter.length;
          
    //       delimiterIndex = htmlFile.Content!.indexOf(delimiter, startIndex);
    //       pageNumber += 1;
    //     }

    //     // Add the remaining content if any
    //     if (startIndex < htmlFile.Content!.length) {
    //       list.add(htmlFile.Content!.substring(startIndex).trim());
    //       pageNumber += 1;
    //     }
    //   }
    //   else{        
    //     list.add(htmlFile.Content!.trim());
    //     pageNumber += 1;
    //   }
    // }

    // list.add(htmlContent);
    // return list;
  //}
}  