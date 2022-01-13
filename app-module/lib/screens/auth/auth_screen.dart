import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/home/home_screen.dart';

import '../../widgets/custom_button.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/login';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'displayName': '',
    'password': '',
  };
  final _emailController = TextEditingController(text: 'duytd752@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
  final _displayNameController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  var _isLoading = false;

  InputDecoration _getCustomDecoration(String hint, Widget icon) {
    var _tmpBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(45),
      borderSide: const BorderSide(color: Colors.white),
    );

    return InputDecoration(
      focusedBorder: _tmpBorder,
      disabledBorder: _tmpBorder,
      errorBorder: _tmpBorder,
      focusedErrorBorder: _tmpBorder,
      enabledBorder: _tmpBorder,
      prefixIcon: icon,
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['displayName']!,
          _authData['password']!,
        );
      }
      Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
    } catch (error) {
      // const errorMessage =
      //     'Could not authenticate you. Please try again later.';
      _showErrorDialog(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 320,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _authMode == AuthMode.login ? 'Login' : 'Sign Up',
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  decoration: _getCustomDecoration(
                    'Email',
                    const Icon(Icons.account_circle),
                  ),
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                  validator: _authMode == AuthMode.signUp
                      ? (value) {
                          if (value!.trim().isEmpty || !value.contains('@')) {
                            return 'Email address invalid!';
                          }
                        }
                      : null,
                ),
                if (_authMode == AuthMode.signUp) ...[
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: _getCustomDecoration(
                      'Display Name',
                      const Icon(Icons.font_download_rounded),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please input your name.';
                      }
                    },
                    onSaved: (value) {
                      _authData['displayName'] = value!;
                    },
                  ),
                ],
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: _getCustomDecoration(
                    'Password',
                    const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: _authMode == AuthMode.signUp
                      ? (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Password is too short (at least 6 characters)';
                          }
                        }
                      : null,
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.signUp) ...[
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _repeatPasswordController,
                    decoration: _getCustomDecoration(
                      'Repeat Password',
                      const Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Repeat password not match!';
                      }
                    },
                  ),
                ],
                const SizedBox(height: 25),
                CustomButton(
                  _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP',
                  Colors.white,
                  Theme.of(context).colorScheme.primary,
                  _submit,
                  btnWidth: 180,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_authMode == AuthMode.login
                        ? 'Don\'t have an account ?'
                        : 'Already have an account ?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_authMode == AuthMode.login) {
                            _authMode = AuthMode.signUp;
                          } else {
                            _authMode = AuthMode.login;
                          }
                        });
                      },
                      child: Text(
                          _authMode == AuthMode.login ? 'Sign up' : 'Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
