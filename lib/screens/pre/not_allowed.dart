import 'package:flutter/material.dart';

class NotAllowed extends StatefulWidget {
  const NotAllowed({super.key});

  @override
  State<NotAllowed> createState() => _NotAllowedState();
}

class _NotAllowedState extends State<NotAllowed> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Access Prohibited",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
