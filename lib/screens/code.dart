import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  String _fileContent = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadFileContent();
  }

  Future<void> _loadFileContent() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/generated_code.txt';
    final file = File(filePath);

    if (await file.exists()) {
      String content = await file.readAsString();
      setState(() {
        _fileContent = content;
      });
    } else {
      setState(() {
        _fileContent = 'File not found!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _fileContent,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}