import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/custom_text_field.dart';

class NotedScreen extends StatefulWidget {
  @override
  _NotedScreenState createState() => _NotedScreenState();
}

class _NotedScreenState extends State<NotedScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notedWelcome),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _controller,
              labelText: 'Enter your note',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notes.add(_controller.text);
                _controller.clear();
              });
            },
            child: Text('Add Note'),
          ),
        ],
      ),
    );
  }
}
