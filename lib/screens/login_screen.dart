import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void dialogCheckCredentials(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Incorrect Email/Password'),
          content: Text('Error : $error'),
        );
      },
    );
  }

  void signInWithEmail() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      dialogCheckCredentials(e.code);
    }
  }

  // void signInWithGoogle() async {
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  //   if (gUser == null) return;

  //   final GoogleSignInAuthentication gAuth = await gUser.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );

  //   await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 225),
              // const Center(
              //   child: Icon(
              //     Icons.lock,
              //     size: 100,
              //   ),
              // ),
              // const SizedBox(height: 50),
              // const Text(
              //   'Welcome back!',
              //   style: TextStyle(fontSize: 16.0),
              // ),
              // const SizedBox(height: 25),

              MyTextfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 30),
              MyTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              // const SizedBox(height: 10),
              // const Padding(
              //   padding: EdgeInsets.only(right: 25.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text('Forgot Password?'),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 75),
              ElevatedButton(
                onPressed: signInWithEmail,
                child: const Text('Sign In'),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     InkWell(
              //       onTap: () {}, //signInWithGoogle,
              //       child:
              //           const SquareTile(imagePath: 'assets/images/google.png'),
              //     ),
              //     const SizedBox(width: 25),
              //     const SquareTile(imagePath: 'assets/images/apple.png'),
              //   ],
              // ),
              const SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: widget.onTap,
                    child: const Text(
                      'Register now',
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
