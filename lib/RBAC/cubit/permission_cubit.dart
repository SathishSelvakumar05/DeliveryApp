import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../enum/RBACenums.dart';
import '../service/PermissionService.dart';

part 'permission_state.dart';

// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../model/feature_response.dart';
// import '../backend_response.dart';

class PermissionCubit extends Cubit<List<FeatureResponse>> {
  PermissionCubit() : super([]);

  Future<void> loadPermissions() async {
    print("cubit called");

    final jsonMap = jsonDecode(backendResponse);
    final features = (jsonMap['featureResponseList'] as List)
        .map((f) => FeatureResponse.fromJson(f))
        .toList();

    print("cubit comes");

    emit(features);
  }

  bool hasAccess(ModuleType  module, AccessType  action) {
    final moduleName = module.name;
    final actionName = action.name;

    for (var feature in state) {
      for (var mod in feature.modules) {
        if (mod.moduleName.toLowerCase() == moduleName.toLowerCase()) {
          return mod.accessType
              .map((a) => a.toUpperCase())
              .contains(actionName.toUpperCase());
        }
      }
    }
    return false;
  }


  bool hasModule(ModuleType  module) {
    final moduleName=module.name;
    for (var feature in state) {
      for (var mod in feature.modules) {
        if (mod.moduleName.toLowerCase() == moduleName.toLowerCase()) {
          return true;
        }
      }
    }
    return false;
  }
}


// class PermissionCubit extends Cubit<PermissionState> {
//   PermissionCubit() : super(PermissionInitial());
// }
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PermissionCubit extends Cubit<List<FeatureResponse>> {
//   PermissionCubit() : super([]);
//
//   Future<void> loadPermissions() async {
//     print("cubit called");
//     final jsonMap = jsonDecode(backendResponse);
//     final features = (jsonMap['featureResponseList'] as List)
//         .map((f) => FeatureResponse.fromJson(f))
//         .toList();
//     print("cubit comes");
//
//
//     emit(features);
//     PermissionService.instance.setFeatures(features); //  set global
//   }
// }

