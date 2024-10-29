import 'package:flutter/material.dart';

class Homepagescreen extends StatefulWidget {
  const Homepagescreen({super.key, });




  @override
  State<Homepagescreen> createState() => _Homepagescreen();
}

class _Homepagescreen extends State<Homepagescreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Home Page"),
      ),
    );
  }
}
