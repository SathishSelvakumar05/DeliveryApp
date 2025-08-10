import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:device_frame/device_frame.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CommonCubit/NetworkScreen/MainScreen.dart';
import 'CustomerScreen/DeliveryScreen/Cubit/add_delivery_cubit.dart';
import 'LoginScreen/Cubit/add_user_cubit.dart';
import 'LoginScreen/LoginForm.dart';
import 'main.dart';

final storybook = Storybook(
  stories: [
    Story(
      name: 'Main Screen',
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AddUserCubit>(create: (_) => AddUserCubit()),
          BlocProvider<DeliveryCubit>(create: (_) => DeliveryCubit()),
        ],
        child: MainScreen(child: MyHomePage()),
      ),
    ),
  ],
);
