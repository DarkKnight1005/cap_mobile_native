import 'package:flutter/material.dart';

class FileConsts {
  FileConsts._();

  static String wordDocName = "wordprocessingml";
  static String powerPointDocName = "presentationml";
  static String excelDocName = "spreadsheetml";
  static String pdfDocName = "pdf";
  
  static String wordExtentionName = ".docx";
  static String powerPointExtentionName = ".pptx";
  static String excelExtentionName = ".xlsx";
  static String pdfExtentionName = ".pdf";

  static String getFileExtenion(String metaName){
    String _extention = ".txt";
    if(metaName.contains(FileConsts.excelDocName)){
      _extention = FileConsts.excelExtentionName;
    }else if(metaName.contains(FileConsts.wordDocName)){
      _extention = FileConsts.wordExtentionName;
    }else if(metaName.contains(FileConsts.powerPointDocName)){
      _extention = FileConsts.powerPointExtentionName;
    }else if(metaName.contains(FileConsts.pdfDocName)){
      _extention = FileConsts.pdfExtentionName;
    }
    return _extention;
  }
}