import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  // final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    // usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void dialogPasswordNotMatch() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Password Not Match'),
          content: Text('Please check your credentials'),
        );
      },
    );
  }

  void showErrorMessage(BuildContext ctx, String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong.'),
          content: Text('Reason: $error'),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(ctx).pop,
              child: const Text('Back'),
            ),
          ],
        );
      },
    );
  }

  void signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (!mounted) return;
      Navigator.of(context).pop();

      if (emailController.text.isEmpty) {
        return showErrorMessage(context, 'Email & Username cannot be empty.');
      }

      if (passwordController.text == confirmPasswordController.text) {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('note')
            .doc(userCredential.user!.uid)
            .set({
          // 'username': emailController.text,
          'email': emailController.text,
        });
      } else {
        dialogPasswordNotMatch();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showErrorMessage(context, e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 180),
              // const Center(
              //   child: Icon(
              //     Icons.lock,
              //     size: 60,
              //   ),
              // ),
              // const SizedBox(height: 50),
              // const Text(
              //   'Let\'s create an account!',
              //   style: TextStyle(fontSize: 16.0),
              // ),
              // const SizedBox(height: 25),
              MyTextfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              // const SizedBox(height: 10),
              // MyTextfield(
              //   controller: usernameController,
              //   hintText: 'Username',
              //   obscureText: false,
              // ),
              const SizedBox(height: 10),
              MyTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: signUp,
                child: Text('Sign Up'),
              ),
              // const SizedBox(height: 50),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 25.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 10.0),
              //         child: Text('Or continue with'),
              //       ),
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 50),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SquareTile(imagePath: 'assets/images/google.png'),
              //     SizedBox(width: 25),
              //     SquareTile(imagePath: 'assets/images/apple.png'),
              //   ],
              // ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class MyButton extends StatelessWidget {
//   const MyButton({
//     super.key,
//     required this.onTap,
//     required this.buttonText,
//   });

//   final void Function() onTap;
//   final String buttonText;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 25),
//       height: 80,
//       child: InkWell(
//         splashColor: Colors.blueGrey,
//         customBorder:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         onTap: onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Text(
//               buttonText,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyTextfield extends StatefulWidget {
  const MyTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  _MyTextfieldState createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  String _counterText = '0';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLength: 50,
            controller: widget.controller,
            obscureText: widget.obscureText,
            onChanged: (value) {
              setState(() {
                _counterText = value.length.toString();
              });
            },
            decoration: InputDecoration(
              labelText: widget.hintText,
              counterText: '$_counterText/50',
            ),
          ),
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     String _counterText = '0';
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: TextField(
//         maxLength: 50,
//         controller: controller,
//         obscureText: obscureText,
//         onChanged: (value) {
//           setState(() {
//             _counterText = value.length.toString();
//           });
//         },
//         decoration: InputDecoration(
//           // enabledBorder: const OutlineInputBorder(
//           //   borderSide: BorderSide(color: Colors.grey),
//           // ),
//           // focusedBorder: const OutlineInputBorder(
//           //   borderSide: BorderSide(color: Colors.white),
//           // ),
//           labelText: hintText,
//           counterText: '$_counterText/50',
//           //hintStyle: TextStyle(color: Colors.grey.shade700)
//         ),
//       ),
//     );
//   }
// }

class SquareTile extends StatelessWidget {
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[900],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
        width: 40,
        fit: BoxFit.fill,
      ),
    );
  }
}
