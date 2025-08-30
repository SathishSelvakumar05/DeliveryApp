// module_type.dart
enum ModuleType { liveDashboard, trips, driver }

enum AccessType { GET, ADD, UPDATE, DELETE }

// Extension to convert enum to string (to match backend)
extension ModuleTypeExtension on ModuleType {
  String get name => this.toString().split('.').last;
}

extension AccessTypeExtension on AccessType {
  String get name => this.toString().split('.').last;
}
