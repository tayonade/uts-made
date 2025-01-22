import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  State<NewNoteScreen> createState() => _NewNotecreenState();
}

class _NewNotecreenState extends State<NewNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  // var _enteredTitle = '';
  // var _enteredContent = '';
  // bool _isAdding = true;
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final titleControl = TextEditingController();
  final contentControl = TextEditingController();

  void clearText() {
    titleControl.clear();
    contentControl.clear();
  }

  Future<void> submitToDb() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        CollectionReference noteCollection = _firestore
            .collection('note')
            .doc(authenticatedUser.uid)
            .collection('user_note');

        await noteCollection.add({
          'title': titleControl.text,
          'content': contentControl.text,
          'timestamp': DateTime.now(),
        });

        navigator.pop();
        navigator.pop();

        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Note berhasil ditambah!')),
        );
      } catch (e) {
        navigator.pop(); // Dismiss loading dialog
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul/Konten kosong')),
      );
    }
  }

  // Future<void> submitToDb() async {
  //   try {
  //     CollectionReference noteCollection = _firestore
  //         .collection('note')
  //         .doc(authenticatedUser.uid)
  //         .collection('user_note');

  //     await noteCollection.add({
  //       'title': titleControl.text,
  //       'content': contentControl.text,
  //       'timestamp': DateTime.now(), // Optional: add timestamp
  //     });

  //     // Show success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Note added successfully!')),
  //     );

  //     // Optional: clear the text fields after successful submission
  //     clearText();
  //   } catch (e) {
  //     // Show error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error adding note: $e')),
  //     );
  //   }
  // }

  // Future<void> submitToDb() async {
  //   final navigator = Navigator.of(context);
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   CollectionReference noteCollection = _firestore
  //       .collection('note')
  //       .doc(authenticatedUser.uid)
  //       .collection('user_note');

  //   //add
  //   DocumentReference newAssetRef = await noteCollection.add({
  //     'title': titleControl,
  //     'content': contentControl,
  //   });
  //   await newAssetRef.collection('history').add({
  //     'timestamp': DateTime.now(),
  //     'type': 'add',
  //     'comment': 'Initial purchase'
  //   });

  //   scaffoldMessenger.showSnackBar(
  //     const SnackBar(content: Text('Asset added successfully!')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleControl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 15,
                controller: contentControl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konten tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: clearText, child: const Text('clear')),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: submitToDb, child: const Text('save'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
