import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/congrats.dart';

class RelaxPage extends StatefulWidget {
  const RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> with BaseClass{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000),(){
      pushToNextScreen(context: context, destination: Congrats());
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        image: AssetImage('assets/images/relax.png'),
        width: Get.width,
        height: Get.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
