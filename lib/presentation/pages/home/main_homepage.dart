// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/utils/text_style.dart';
import '../../../core/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box _todoBox = Hive.box('TODO_BOX');
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        title: const Text(
          'Todo List Sederhana',
          style: AppTextStyle.subHeadingWhite,
        ),
        backgroundColor: AppColor.accent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _deleteAllItems(),
                  icon: const Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Delete All',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, index) {
          final currentItem = _items[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(currentItem['name'] ?? '-'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(context, currentItem['key']),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(currentItem['key']),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onRefresh() {
    final data = _todoBox.keys.map((key) {
      final item = _todoBox.get(key);
      return {
        'key': key,
        'name': item['name'],
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _todoBox.add(newItem);
    log('amount of data is ${_todoBox.length}');
    _onRefresh();
  }

  Future<void> _deleteItem(int key) async {
    await _todoBox.delete(key);
    log('Item with key $key deleted');
    _onRefresh();
  }

  Future<void> _deleteAllItems() async {
    await _todoBox.clear();
    log('All items deleted');
    _onRefresh();
  }

  Future<void> _showForm(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem = _todoBox.get(itemKey);
      _nameController.text = existingItem['name'];
    } else {
      _nameController.clear();
    }

    await showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  return;
                }
                if (itemKey == null) {
                  await _createItem({
                    'name': _nameController.text,
                  });
                } else {
                  await _todoBox.put(itemKey, {
                    'name': _nameController.text,
                  });
                  _onRefresh();
                }

                // clear controller
                _nameController.clear();
                Navigator.of(context).pop();
              },
              child: Text(itemKey == null ? 'Create New' : 'Update'),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
