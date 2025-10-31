import 'package:flutter/material.dart';
import 'package:libey_mt/providers/Auth.dart';
import 'package:libey_mt/utilities/colors.dart';
import 'package:libey_mt/views/home/product_list.dart';
import 'package:libey_mt/widgets/clipper.dart';
import 'package:provider/provider.dart';


class Loginscreeen extends StatefulWidget {
  const Loginscreeen({super.key});

  @override
  State<Loginscreeen> createState() => _LoginscreeenState();
}

class _LoginscreeenState extends State<Loginscreeen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: ColorControllers().searchbarcolor,
      appBar: AppBar(backgroundColor: ColorControllers().appbarcolor,),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Opacity(
                    opacity: 0.7,
                    child: ClipPath(
                      clipper: MyCustomClipper(),
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFC333B5),
                              Color(0xFFCF75D2),
                              Color(0xFFF3E4F5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 120,
                    left: 80,
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              _textField("Username", _emailController, false),
              const SizedBox(height: 30),
              _passwordField(),
              const SizedBox(height: 30),
              Container(
                width: 290,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFF6EAF6),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorControllers().ElevatedButtoncolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          final username = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                
                          if (username.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter username and password')),
                            );
                            return;
                          }
                
                          bool success =
                              await authProvider.login(username, password);
                
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Invalid credentials or login failed')),
                            );
                          }
                        },
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorControllers().textcolor,
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

  Widget _textField(String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: 290,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF6EAF6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFC272BA)),
          ),
          hintStyle: const TextStyle(color: Color(0xFF948C93)),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      width: 290,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: isObscure,
        builder: (context, value, child) {
          return TextField(
            controller: _passwordController,
            obscureText: value,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF6EAF6),
              suffixIcon: IconButton(
                onPressed: () => isObscure.value = !isObscure.value,
                icon: Icon(value ? Icons.visibility : Icons.visibility_off),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFFC272BA)),
              ),
              hintStyle: const TextStyle(color: Color(0xFF948C93)),
              hintText: "Password",
            ),
          );
        },
      ),
    );
  }
}
