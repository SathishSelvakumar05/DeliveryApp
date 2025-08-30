part of 'permission_cubit.dart';

// @immutable
// sealed class PermissionState {}
//
// final class PermissionInitial extends PermissionState {}



class FeatureResponse {
  final int featureId;
  final String featureName;
  final String description;
  final List<Module> modules;

  FeatureResponse({
    required this.featureId,
    required this.featureName,
    required this.description,
    required this.modules,
  });

  factory FeatureResponse.fromJson(Map<String, dynamic> json) {
    return FeatureResponse(
      featureId: json['featureId'],
      featureName: json['featureName'],
      description: json['description'],
      modules: (json['modules'] as List)
          .map((m) => Module.fromJson(m))
          .toList(),
    );
  }
}

class Module {
  final int moduleId;
  final String moduleName;
  final List<String> accessType;

  Module({
    required this.moduleId,
    required this.moduleName,
    required this.accessType,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleId: json['moduleId'],
      moduleName: json['moduleName'],
      accessType: List<String>.from(json['accessType']),
    );
  }
}

const String backendResponse = """
{
  "featureResponseList": [
    {
      "featureId": 3,
      "featureName": "AutoPlanner",
      "description": "Vehicle Fleet Management",
      "modules": [
      ]
    },
    {
      "featureId": 2,
      "featureName": "Yaantrac",
      "description": "Vehicle Fleet Management",
      "modules": [
        {
          "moduleId": 1,
          "moduleName": "reports",
          "accessType": ["GET"]
        },
        {
          "moduleId": 5,
          "moduleName": "liveDashboard",
          "accessType": ["GET"]
        },
        {
          "moduleId": 3,
          "moduleName": "trips",
          "accessType": ["ADD", "GET","DELETE","UPDATE"]
        },
        {
          "moduleId": 2,
          "moduleName": "driver",
          "accessType": ["ADD", "GET"]
        }
      ]
    }
  ]
}
""";

