import 'package:firebase_auth/firebase_auth.dart';
import 'HomeView.dart';
import 'package:flutter/material.dart';
import '../firebase_auth.dart';
import '../validator.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication'),
      ),
      body: Padding(
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
                    hintText: 'Ingrese su nombre de usuario',
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  controller: _nameTextController,
                  validator: (value) => Validator.validateName(name: value),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ingrese el Email',
                    labelText: 'Email',
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  controller: _emailTextController,
                  validator: (value) => Validator.validateEmail(email: value),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Ingrese su password',
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator: (value) =>
                      Validator.validatePassword(password: value),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User? user = await FireAuth.registerUsingEmailPassword(
                        name: _nameTextController.text,
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );
                      if (user != null) {
                        Fluttertoast.showToast(
                            msg: "¡Usuario creado!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => HomeView(user: user),
                          ),
                          ModalRoute.withName('/'),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Ocurrio un error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print("THERE WAS AN ERROR!");
                        const AlertDialog(title: Text("There was an error!"));
                      }
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginView()));
              },
            ),
            ListTile(
              // DefaultTabController & BottonNavigationBar
              title: const Text('Registro'),
              trailing: Icon(Icons.app_registration),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
