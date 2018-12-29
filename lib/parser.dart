

import 'dart:io' as io;
import 'dart:async';
import 'package:epub/epub.dart';

import 'utils.dart' show compute;

enum Format{
    epub,
    pdf,
    text,
}
class Parser{
  Uri uri;
  final Format format;
  Parser(this.format){

  }
  factory Parser.file(io.File file) {
    // todo parser file 
    Format format = Format.epub;

    return Parser(format)
      ..uri = file.uri;
  }

  readContents(){
    Stream<List<int>> stream = io.File.fromUri(uri).readAsBytes().asStream();
    stream.listen((List<int> data){

    });

    compute<String,EpubBook>(_getEPubBookFromFilePath,uri.toFilePath(),debugLabel: 'get_epub');
  }
  
  EpubBook _getEPubBookFromFilePath(String path){
    var bytes = io.File.fromUri(uri).readAsBytesSync();
    EpubBook book = Future.sync(EpubBook.readBook(bytes));
    return null;

  }

}
