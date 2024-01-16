import 'dart:io';

import 'package:flutter/material.dart';
import 'package:database/screens/Create.dart';
import 'package:database/screens/search.dart';
import 'package:database/model/database_model.dart';
import 'package:database/services/user-services.dart';
import 'package:database/screens/edit.dart';
import 'package:database/screens/grid_view.dart';
import 'package:database/screens/view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<User> _userList = <User>[];
  final _userService = UserService();

  getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    _userList = <User>[];
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.study = user['study'];
        userModel.admission = user['admission'];
        userModel.address = user['address'];
        userModel.selectedImage = user['selectedImage'];
        _userList.add(userModel);
      });
    });
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    var result = await _userService.deleteUser(userId);
                    if (result != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      getAllUserDetails();
                      _showSuccessSnackBar('User Detail Deleted Success');
                    }
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.only(right: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Gridview()),
              );
            },
            icon: const Icon(Icons.grid_view),
            padding: const EdgeInsets.only(right: 30),
          ),
        ],
        backgroundColor: Colors.lightBlue,
        title: const Text('HOME PAGE'),
      ),
      body: Container(
        child: _userList.isEmpty
            ? const Center(
                child: Text('No Data'),
              )
            : ListView.builder(
                itemCount: _userList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewUser(
                                      user: _userList[index],
                                    )));
                      },
                      leading: CircleAvatar(
                          radius: 50,
                          backgroundImage: _userList[index].selectedImage !=
                                      null &&
                                  File(_userList[index].selectedImage!)
                                      .existsSync()
                              ? FileImage(File(_userList[index].selectedImage!))
                                  as ImageProvider<Object>?
                              : const AssetImage('assets/images/profile.jpg')),
                      title: Text(_userList[index].name ?? ''),
                      subtitle: Text(_userList[index].study ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Edit(
                                              user: _userList[index],
                                            ))).then((data) {
                                  if (data != null) {
                                    getAllUserDetails();
                                    _showSuccessSnackBar(
                                        'User Detail Updated Successfully');
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.teal,
                              )),
                          IconButton(
                              onPressed: () {
                                deleteFormDialog(context, _userList[index].id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Detailspage()))
              .then((data) {
            if (data != null) {
              getAllUserDetails();
              _showSuccessSnackBar('User Detail Added Successfully');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
