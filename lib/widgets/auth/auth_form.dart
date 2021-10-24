import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imessage/pickers/user_image.dart';

enum AuthMode {
  LOGIN,
  SIGNUP,
}

class AuthForm extends StatefulWidget {
  final void Function(Map<String, String> data, File? image, AuthMode authMode,
      BuildContext ctx) getTheAuthData;
  final bool isLoading;
  const AuthForm(
      {Key? key, required this.getTheAuthData, required this.isLoading})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _passwordIsVisible = false;
  var _currentAuthMode = AuthMode.LOGIN;

  final formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  File? image;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };

  void getTheImageFile(File? imageFile) {
    image = imageFile;
  }

  void _submitForm() {
    if (image == null && _currentAuthMode == AuthMode.SIGNUP) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an image!'),
      ));
      return;
    }
    if (!formKey.currentState!.validate()) return null;
    formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    widget.getTheAuthData(_authData, image, _currentAuthMode, context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
        child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInBack,
      height: _currentAuthMode == AuthMode.LOGIN
          ? deviceSize.height * 0.42
          : deviceSize.height * 0.83,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 4, right: 16, left: 16),
              child: Column(
                children: [
                  if (_currentAuthMode == AuthMode.SIGNUP)
                    UserImage(
                      onImageSelected: getTheImageFile,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                        ),
                        labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please Enter The Email Email';
                      if (!value.contains('@')) {
                        return 'Please Enter a valid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!.trim();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_currentAuthMode == AuthMode.SIGNUP)
                    Column(
                      children: [
                        TextFormField(
                          key: const ValueKey('username'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              labelText: 'Username'),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'username must be at least 4 characters';
                            }
                            if (value.contains('@')) {
                              return 'Please Enter a valid Username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['username'] = value!.trim();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    controller: _passwordController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordIsVisible = !_passwordIsVisible;
                              });
                            },
                            icon: Icon(_passwordIsVisible
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                        ),
                        labelText: 'Password'),
                    obscureText: _passwordIsVisible ? false : true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please Enter The Password';
                      if (value.length < 8) return 'Password is to short';
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  if (_currentAuthMode == AuthMode.SIGNUP)
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          key: const ValueKey('confirm password'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              labelText: 'Confirm Password'),
                          obscureText: _passwordIsVisible ? false : true,
                          validator: (_currentAuthMode == AuthMode.SIGNUP)
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            _currentAuthMode == AuthMode.LOGIN
                                ? 'LOGIN'
                                : 'SIGNUP',
                            style: const TextStyle(fontSize: 20),
                          ),
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.padded,
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    child: Text('OR'),
                  ),
                  TextButton(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                if (_currentAuthMode == AuthMode.LOGIN) {
                                  _currentAuthMode = AuthMode.SIGNUP;
                                } else {
                                  _currentAuthMode = AuthMode.LOGIN;
                                }
                              });
                            },
                      child: Text(
                        _currentAuthMode == AuthMode.LOGIN
                            ? 'Create a new account'
                            : 'Already have an account',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
