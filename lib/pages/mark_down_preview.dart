import 'package:flutter/material.dart';

class MarkDownPreview extends StatefulWidget {
  const MarkDownPreview({super.key});

  @override
  State<MarkDownPreview> createState() => _MarkDownPreviewState();
}

class _MarkDownPreviewState extends State<MarkDownPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: const Center(child: Text('MarkDownPreview')),
    );
  }
}
