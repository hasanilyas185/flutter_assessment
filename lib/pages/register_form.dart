import 'package:flutter/material.dart';
import 'package:flutter_assessment/blocs/authentication_bloc.dart';
import 'package:flutter_assessment/blocs/register_bloc.dart';
import 'package:flutter_assessment/events/authentication_event.dart';
import 'package:flutter_assessment/events/register_event.dart';
import 'package:flutter_assessment/states/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  bool passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  late RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
     passwordVisible = true;
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Register Failure',style: TextStyle(color: Colors.white),),
                    Icon(Icons.error),
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
                    Text('Registering...',style: TextStyle(color: Colors.white),),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Colors.black,
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                    height: 30,
                  ),
                  ElevatedButton(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: width / 1.2, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Sign up",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onFormSubmitted();
                      }
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 16 * scalefactor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mulish',
                            color: Colors.white))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(RegisterSubmitted(
        email: _emailController.text, password: _passwordController.text));
  }
}
