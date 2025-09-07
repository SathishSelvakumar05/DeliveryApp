import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network_cubit.dart';
import 'NetworkScreen.dart';


class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return const NetworkErrorScreen();
        } else {
          return child;
        }
      },
    );
  }
}
