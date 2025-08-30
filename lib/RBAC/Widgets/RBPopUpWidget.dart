import 'package:flutter/material.dart';
import '../enum/RBACenums.dart';
import '../service/PermissionService.dart';

class PermissionPopupMenu extends StatelessWidget {
  final ModuleType module;

  // Callbacks for each action
  final VoidCallback? onAdd;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;

  const PermissionPopupMenu({
    Key? key,
    required this.module,
    this.onAdd,
    this.onUpdate,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allowedActions = AccessType.values
        .where((action) => action != AccessType.GET)
        .where((action) => PermissionService.hasAccess(context, module, action))
        .toList();

    if (allowedActions.isEmpty) return SizedBox.shrink();

    return
      PopupMenuButton<AccessType>(
      onSelected: (action) {
        switch (action) {
          case AccessType.ADD:
            if (onAdd != null) onAdd!();
            break;
          case AccessType.UPDATE:
            if (onUpdate != null) onUpdate!();
            break;
          case AccessType.DELETE:
            if (onDelete != null) onDelete!();
            break;
          default:
            print("Action not handled: ${action.name}");
        }
      },
      itemBuilder: (context) {
        return allowedActions
            .map(
              (action) => PopupMenuItem<AccessType>(
            value: action,
            child: Text(action.name),
          ),
        )
            .toList();
      },
      child: Icon(Icons.more_vert),
    );
  }
}
