import 'package:app/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  // Variable Members
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPress;
  final void Function(BuildContext)? onDeletePressed;
  // Constructor
  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEditPress,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // What the fuck is this?
      endActionPane: ActionPane(
        // What the fuck?
        motion: const StretchMotion(),
        children: [
          // settings option
          SlidableAction(
            onPressed: onEditPress,
            icon: Icons.settings,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          // delete option
          SlidableAction(
            onPressed: onDeletePressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: ListTile(title: Text(title), trailing: Text(trailing)),
    );
  }
}
