import 'package:flutter/material.dart';
import 'package:flutter_assessment/blocs/authentication_bloc.dart';
import 'package:flutter_assessment/blocs/login_bloc.dart';
import 'package:flutter_assessment/events/authentication_event.dart';
import 'package:flutter_assessment/events/login_event.dart';
import 'package:flutter_assessment/pages/register_screen.dart';
import 'package:flutter_assessment/repositories/user_repository.dart';
import 'package:flutter_assessment/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Login Failure',style: TextStyle(color: Colors.white),),
                    Icon(Icons.error,color: Colors.white,),
                  ],
                ),
                backgroundColor: Colors.black,
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logging In...',style: TextStyle(color: Colors.white),),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor:  Colors.black,
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.red,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid email address or mobile no';
                      }
                      else if(!value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))
                      {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Email or Mobile Number',
                      contentPadding: const EdgeInsets.only(left: 24),
                      hintStyle: TextStyle(
                          fontSize: 14 * scalefactor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish',
                          color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: passwordVisible,
                      cursorColor: Colors.red,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid password';
                        } else if (value.length < 7) {
                          return 'Password must contains eight characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        hintText: 'Password',
                        contentPadding: const EdgeInsets.only(left: 24),
                        hintStyle: TextStyle(
                            fontSize: 14 * scalefactor,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mulish',
                            color: Colors.red),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: width / 1.2, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Sign in",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onFormSubmitted();
                      }
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 16 * scalefactor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                            color: Colors.white))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Don’t have an account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14 * scalefactor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish',
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: width / 1.2, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Register",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return RegisterScreen(
                          userRepository: widget._userRepository,
                        );
                      }));
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 16 * scalefactor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                            color: Colors.white))),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
