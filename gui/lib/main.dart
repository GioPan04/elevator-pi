import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage('1'),
    );
  }
}

class Floors extends StatelessWidget {
  final String floor;
  Floors(this.floor);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black87,
        ),
        child: TextButton(
          onPressed: () {},
          child:
              Text(floor, style: TextStyle(color: Colors.white, fontSize: 40)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String floor;
  HomePage(this.floor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Elevator'), backgroundColor: Colors.black),
      body: Column(
        children: <Widget>[
          Divider(height: 50, color: Colors.grey[300]),
          Row(
            children: <Widget>[
              Floors('1'),
              Floors('2'),
              Floors('3'),
            ],
          ),
          Row(
            children: <Widget>[
              Floors('4'),
              Floors('5'),
              Floors('6'),
            ],
          ),
          Divider(height: 130, color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.exposure_minus_1, size: 50),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900],
                ),
                child: Text(
                  floor,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.exposure_plus_1, size: 50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
