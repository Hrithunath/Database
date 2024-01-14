import 'package:flutter/material.dart';
import 'package:database/model/database_model.dart';

class Viewuser extends StatefulWidget {
  final User user;
  const Viewuser({super.key, required this.user});

  @override
  State<Viewuser> createState() => _ViewuserState();
}

class _ViewuserState extends State<Viewuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "Full Details",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Name',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.user.name ?? '',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('Class',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.user.study ?? '',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Admission number',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.user.admission ?? '',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Address',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(widget.user.address ?? '',
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ])));
  }
}
