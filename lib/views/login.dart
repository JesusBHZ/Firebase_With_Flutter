import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_auth.dart';
import '../validator.dart';
import 'package:firebasec2/views/HomeView.dart';
import 'package:firebasec2/views/register.dart';
import 'register.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeView(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  // drawer - menu de haburguesa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication'),
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Image.network(
                        'https://www.gstatic.com/devrel-devsite/prod/v8643e450826640c4e83cddfb72d4164f3407c33263e3070ba2a32acb4c849a5f/firebase/images/touchicon-180.png',
                        width: 200, // Ancho de la imagen
                        height: 200, // Alto de la imagen
                        fit: BoxFit.cover, // Modo de ajuste de la imagen
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          suffixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        controller: _emailTextController,
                        validator: (value) =>
                            Validator.validateEmail(email: value),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          suffixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        controller: _passwordTextController,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user =
                                await FireAuth.signInUsingEmailPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomeView(user: user)),
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Revisa tus credenciales",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.teal,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              print("THERE WAS AN ERROR!");
                              const AlertDialog(
                                  title: Text("There was an error!"));
                            }
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      /*const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterView()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),*/
                    ],
                  ),
                ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              // DefaultTabController & BottonNavigationBar
              title: const Text('Login'),
              trailing: Icon(Icons.login),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              // DefaultTabController & BottonNavigationBar
              title: const Text('Registro'),
              trailing: Icon(Icons.app_registration),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
