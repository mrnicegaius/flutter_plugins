// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Page for showing an example of saving with file_selector
class SaveTextPage extends StatelessWidget {
  /// Default Constructor
  SaveTextPage({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveFile() async {
    final String fileName = _nameController.text;
    // This demonstrates using an initial directory for the prompt, which should
    // only be done in cases where the application can likely predict where the
    // file will be saved. In most cases, this parameter should not be provided.
    final String initialDirectory =
        (await getApplicationDocumentsDirectory()).path;
    final String? path = await getSavePath(
      initialDirectory: initialDirectory,
      suggestedName: fileName,
    );
    if (path == null) {
      // Operation was canceled by the user.
      return;
    }

    final String text = _contentController.text;
    final Uint8List fileData = Uint8List.fromList(text.codeUnits);
    const String fileMimeType = 'text/plain';
    final XFile textFile =
        XFile.fromData(fileData, mimeType: fileMimeType, name: fileName);

    await textFile.saveTo(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save text into a file'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              child: TextField(
                minLines: 1,
                maxLines: 12,
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: '(Optional) Suggest File Name',
                ),
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                minLines: 1,
                maxLines: 12,
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Enter File Contents',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: const Text('Press to save a text file'),
              onPressed: () => _saveFile(),
            ),
          ],
        ),
      ),
    );
  }
}
