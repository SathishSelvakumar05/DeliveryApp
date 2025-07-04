import 'package:flutter/material.dart';


class AnotherPage extends StatelessWidget {
  final String? payload;
  const AnotherPage({super.key,this.payload});

  @override
  Widget build(BuildContext context) {
    // final data = ModalRoute
    //     .of(context)!
    //     .settings
    //     .arguments;

    return Scaffold(
      appBar: AppBar(title: Text("Another Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text(payload!=null&&payload!.isNotEmpty?payload.toString():"NoData"),)
        ],
      ),
    );
  }
}