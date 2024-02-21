import 'package:flutter/material.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _NotAllowedState();
}
class _NotAllowedState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Image.asset("assets/dashboard_bg.png",fit: BoxFit.fill,) 
      ),
    );
  }
}
