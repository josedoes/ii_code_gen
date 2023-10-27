import 'package:flutter/material.dart';
import 'package:ii_code_gen/service/app_version/app_service.dart';
import 'package:stacked/stacked.dart';

import '../../ui/styles.dart';
import '../../view_models/login_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel()..initState(),
      builder: (context, model, child) {
        return const Scaffold(
          key: ValueKey('login_view'),
          body: LoginCard(),
        );
      },
    );
  }
}

class LoginCard extends ViewModelWidget<LoginViewModel> {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context, model) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 700,
                height: 700,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 24,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Logo or brand name

                    Container(
                      child: Image.asset(
                          'assets/png/llm_studio_logo.png'), // Replace with your logo
                      height: 80.0,
                    ),
                    SizedBox(height: 12.0),

                    Text(
                      '${appService.currentPackageVersion}',
                      style: baseFont.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'Sign In',
                      style: baseFont.copyWith(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 48.0),
                    // Email Field
                    Form(
                        key: model.formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              key: ValueKey('username'),
                              controller: model.usernameController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                              ),
                              style: baseFont,
                            ),
                            SizedBox(height: 20.0),
                            // Password Field
                            TextFormField(
                              obscureText: true,
                              style: baseFont,
                              key: ValueKey('password'),
                              controller: model.passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                              ),
                            ),
                            model.hasError
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      "Wrong email/password",
                                      style:
                                          baseFont.copyWith(color: Colors.red),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        )),
                    SizedBox(height: 20.0),

                    // Forgot Password
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        child: Text('Forgot Password?',
                            style: baseFont.copyWith(color: Colors.grey[600])),
                        onPressed: () {},
                      ),
                    ),

                    // Remember Me checkbox
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: true, // Or bind with some stateful value
                          onChanged: (newValue) {
                            // Handle change
                          },
                          activeColor: Colors.blue,
                        ),
                        Text('Keep me signed in',
                            style: baseFont.copyWith(color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 20.0),

                    model.loginBusy
                        ? SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator())
                        : ElevatedButton(
                            key: ValueKey('login_action'),
                            child: Text(
                              'Log In',
                              style: baseFont,
                            ),
                            onPressed: () => model.onLogin(context),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 24.0),
                              textStyle: baseFont.copyWith(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                    SizedBox(height: 20.0),

                    TextButton(
                      child: Text(
                        'Terms and Privacy Policy',
                        style: baseFont.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors
                                  .blue; // Color of the text when button is hovered
                            return Colors.grey; // Default color of the text
                          },
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 700,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 24,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextButton(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'New to LLM Lab? ',
                          style: baseFont.copyWith(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Create an Account',
                          style: baseFont.copyWith(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors
                            .transparent; // Return transparent color for all states
                      },
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Reduces additional size around the button
                  ),
                  onPressed: () {
                    // Handle account creation
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
