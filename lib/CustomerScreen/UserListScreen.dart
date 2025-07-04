import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../LoginScreen/Cubit/add_user_cubit.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body: BlocBuilder<AddUserCubit, AddUserState>(
        builder: (context, state) {
          if (state.users.isEmpty) {
            return const Center(child: Text("No users added yet."));
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow("Name", user.name),
                        _buildRow("Mobile", user.mobile),
                        _buildRow("Email", user.email),
                        _buildRow("Address", user.address),
                        _buildRow("Vehicle No.", user.vehicleNumber),
                        _buildRow("ID Proof", user.idProof),
                        _buildRow("License Doc", user.licenseDoc),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return value == null || value.isEmpty
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
