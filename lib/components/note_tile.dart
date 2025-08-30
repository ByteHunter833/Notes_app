import 'package:flutter/material.dart';
import 'package:notes_app/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;

  const NoteTile({
    super.key,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: ListTile(
        title: Text(text),
        tileColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        trailing: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showPopover(
                context: context,
                bodyBuilder: (context) => NoteSettings(
                  onEditPressed: onEditPressed,
                  onDeletePressed: onDeletePressed,
                ),

                width: 120,
                height: 100,
                arrowHeight: 10,
                arrowWidth: 20,
                backgroundColor: Theme.of(context).colorScheme.surface,
              );
            },
          ),
        ),
      ),
    );
  }
}
