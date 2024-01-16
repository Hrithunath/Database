import 'dart:io';
import 'package:flutter/material.dart';
import 'package:database/model/database_model.dart';
import 'package:database/services/user-services.dart';
import 'package:database/screens/edit.dart';
import 'package:database/screens/view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<dynamic> _userList = [];
  late List<dynamic> _filteredUserList = [];
  final _userService = UserService();
  TextEditingController searchController = TextEditingController();

  getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    setState(() {
      _userList = users.map((user) {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.study = user['study'];
        userModel.admission = user['admission'];
        userModel.address = user['address'];
        userModel.selectedImage = user['selectedImage'];

        return userModel;
      }).toList();
      _filteredUserList = _userList;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  void _filterUserList(String enteredKeyword) {
    List<dynamic> filteredList = _userList.where((user) {
      return user.name!.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      _filteredUserList = filteredList;
    });
  }

  showSuccesSnackBar(String message) {
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
              content: const Text('Are you sure you want to delete this?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel'),
                ),
                TextButton(
                    onPressed: () async {
                      var result = await _userService.deleteUser(userId);
                      if (result != null) {
                        Navigator.pop(context);
                        getAllUserDetails();
                        showSuccesSnackBar('User Details Deleted succesfully');
                      }
                    },
                    child: const Text(
                      'delete',
                      style: TextStyle(color: Colors.red),
                    )),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text('SEARCH PAGE'),
        ),
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: _filterUserList,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'What are you looking for?',
                    prefixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: _filteredUserList.isEmpty
                      ? const Center(
                          child: Text('Not Found'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _filteredUserList.length,
                          itemBuilder: (context, index) => Card(
                            child: ListTile(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Viewuser(
                                    user: _filteredUserList[index],
                                  ),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: _filteredUserList[index]
                                                .selectedImage !=
                                            null &&
                                        File(_filteredUserList[index]
                                                .selectedImage!)
                                            .existsSync()
                                    ? FileImage(File(_filteredUserList[index]
                                            .selectedImage!))
                                        as ImageProvider<Object>?
                                    : const AssetImage(
                                        'assets/images/profile.jpg'),
                              ),
                              title: Text(
                                  _filteredUserList[index].name ?? 'No Name'),
                              subtitle: Text(
                                  _filteredUserList[index].study ?? 'No Study'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Edit(
                                            user: _filteredUserList[index],
                                          ),
                                        ),
                                      ).then(
                                        (data) {
                                          if (data != null) {
                                            getAllUserDetails();
                                            showSuccesSnackBar(
                                                'User updated successfully');
                                          }
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteFormDialog(
                                          context, _filteredUserList[index].id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ])));
  }
}
