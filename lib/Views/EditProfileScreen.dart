import 'package:flutter/material.dart';

class Editpagescreen extends StatefulWidget {
  const Editpagescreen({super.key, });




  @override
  State<Editpagescreen> createState() => _Homepagescreen();
}

class _Homepagescreen extends State<Editpagescreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Edit Profile Screen"),
      ),
    );
  }
}
