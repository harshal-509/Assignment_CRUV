// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(SeatFinderApp());
}

class SeatFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seat Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SeatFinderScreen(),
    );
  }
}

class SeatFinderScreen extends StatefulWidget {
  @override
  SeatFinderScreenState createState() => SeatFinderScreenState();
}

class SeatFinderScreenState extends State<SeatFinderScreen> {
  final seatNumberController = TextEditingController();
  int selectedSeatNumber = -1;

  @override
  void dispose() {
    seatNumberController.dispose();
    super.dispose();
  }

  String getBerthType(int seatNumber) {
    if (seatNumber % 8 == 1 || seatNumber % 8 == 4) {
      return 'Lower';
    } else if (seatNumber % 8 == 2 || seatNumber % 8 == 5) {
      return 'Middle';
    } else if (seatNumber % 8 == 3 || seatNumber % 8 == 6) {
      return 'Upper';
    } else if (seatNumber % 8 == 7) {
      return 'Side Lower';
    } else if (seatNumber % 8 == 0) {
      return 'Side Upper';
    }
    return '';
  }

  Widget buildSeatMap() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(72, (index) {
        final seatNumber = index + 1;
        final berthType = getBerthType(seatNumber);
        final isSelected = seatNumber == selectedSeatNumber;

        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: isSelected ? Colors.blue : null,
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Seat $seatNumber'),
                SizedBox(height: 8.0),
                Text(berthType),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Finder'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: seatNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Seat Number',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final seatNumber = int.tryParse(seatNumberController.text);
                  if (seatNumber != null && seatNumber >= 1 && seatNumber <= 72) {
                    final berthType = getBerthType(seatNumber);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Berth Type'),
                          content: Text('Seat $seatNumber is a $berthType berth.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      selectedSeatNumber = seatNumber;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invalid Seat Number'),
                          content: Text('Please enter a valid seat number between 1 and 72.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Find Berth'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Seat Map',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              buildSeatMap(),
            ],
          ),
        ),
      ),
    );
  }
}