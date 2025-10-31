import 'package:flutter/material.dart';
import 'package:libey_mt/utilities/colors.dart';
import 'package:libey_mt/views/login/loginscreen.dart';
import 'package:libey_mt/widgets/clipper.dart';

class Registerscreeen extends StatefulWidget {
  const Registerscreeen({super.key});

  @override
  State<Registerscreeen> createState() => _LoginscreeenState();
}

class _LoginscreeenState extends State<Registerscreeen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorControllers().searchbarcolor,
    
       body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
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
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color(0xFFC333B5),
                            Color(0xFFCF75D2),
                            Color(0xFFF3E4F5),
                          ])),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: 300,
                        height: 175,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(70),
                          ),
                          color: Color(0xFFCF75D2),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: 200,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(40),
                          ),
                          color: Color(0xFFC272BA),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: 120,
                    left: 80,
                    child: Text(
                      "REGISTER",
                      style: TextStyle(color: ColorControllers().textcolor,fontSize: 35),
                    )),
               
              ],
            ),
            
            _textField("Name", _usernameController, false),
            SizedBox(height: 30),
            _textField("Email", _emailController, false),
            SizedBox(height: 30),
            _passwordField(),
            SizedBox(height: 30),
           Container(
      width: 290,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF6EAF6),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorControllers().ElevatedButtoncolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Loginscreeen()));
        },
        child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  color: ColorControllers().textcolor,
                ),
              ),
      ),
    )

          ],
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
          fillColor: Color(0xFFF6EAF6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFFC272BA)),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xFFC272BA))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xFFC272BA))),
          hintStyle: const TextStyle(color: Color(0xFF948C93)),
          hintText: hint,
        ),
        autofocus: true,
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
              fillColor: Color(0xFFF6EAF6),
              suffixIcon: IconButton(
                onPressed: () {
                  isObscure.value = !isObscure.value;
                },
                icon: Icon(
                  value ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFFC272BA)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xFFC272BA))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xFFC272BA))),
              hintStyle: const TextStyle(color: Color(0xFF948C93)),
              hintText: "Password",
            ),
          );
        },
      ),
    );
  }

}