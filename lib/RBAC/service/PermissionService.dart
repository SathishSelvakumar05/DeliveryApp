import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/permission_cubit.dart';
import '../enum/RBACenums.dart';

class PermissionService {
  static final PermissionService instance = PermissionService._();
  PermissionService._();
  List<FeatureResponse> _features = [];

  void setFeatures(List<FeatureResponse> features) {

    _features = features;
    print("the features");
    print(_features.toString());
  }

  static bool hasAccess(BuildContext context, ModuleType  module, AccessType  action) {
    return context.read<PermissionCubit>().hasAccess(module, action);
  }
  static bool hasModule(BuildContext context, ModuleType module) {
    return context.read<PermissionCubit>().hasModule(module);
  }

  // bool hasAccess(String module, String action) {
  //   for (var feature in _features) {
  //     for (var mod in feature.modules) {
  //       if (mod.moduleName.toLowerCase() == module.toLowerCase()) {
  //         return mod.accessType.contains(action);
  //       }
  //     }
  //   }
  //   return false;
  // }
}

