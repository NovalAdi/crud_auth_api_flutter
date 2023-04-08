// ignore_for_file: use_build_context_synchronously

import 'package:crud_api_app/locals/secure_storage.dart';
import 'package:crud_api_app/models/user.dart';
import 'package:crud_api_app/services/user_service.dart';
import 'package:crud_api_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../services/auth_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late User user;

  void getUser() {
    SecureStorage.getUser().then((value) {
      if (value != null) {
        setState(() {
          user = value;
        });
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: FutureBuilder(
        initialData: null,
        future: SecureStorage.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                _nameController.text = user.name!;
                _emailController.text = user.email!;
                return SingleChildScrollView(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: _nameController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Nama can not be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    labelText: 'Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email can not be empty';
                                    } else if (!isEmail(value)) {
                                      return 'Email is not valid';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool updateValid = false;

                                        await Utils.dialog(context, () async {
                                          final res = await UserService.update(
                                              id: user.id!,
                                              name: _nameController.text,
                                              email: _emailController.text);
                                          setState(() {
                                            updateValid = res;
                                          });
                                        });

                                        if (updateValid) {
                                          getUser();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Data successfully updated'),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => const AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Login is not valid or a server error'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      'update'.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        'Are you sure you want to logout ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          bool isLogout = false;
                                          Navigator.of(context).pop();
                                          await Utils.dialog(context,
                                                  () async {
                                                final res =
                                                await AuthService.logout();
                                                setState(() {
                                                  isLogout = res;
                                                });
                                              });
                                          if (isLogout) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                const LoginPage(),
                                              ),
                                            );
                                            await SecureStorage
                                                .deleteDataLokal();
                                          }
                                        },
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: Colors.red
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                'logout'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
