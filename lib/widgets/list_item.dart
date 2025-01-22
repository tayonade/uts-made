// widgets/list_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final DocumentSnapshot document;

  const ListItem({
    Key? key,
    required this.document,
  }) : super(key: key);

  Future<void> _deleteNote(BuildContext context) async {
    try {
      await document.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note berhasil dihapus!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error menghapus note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = document.data() as Map<String, dynamic>;
    final title = data['title'];
    final content = data['content'];

    return Dismissible(
      key: Key(document.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        _deleteNote(context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(
            title,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 4),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
