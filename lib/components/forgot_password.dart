import 'dart:async';
import 'package:club_de_corredores/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
    required this.changePage
  });

  final void Function(String page) changePage;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var redirected = false;
  var _loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();

  late final StreamSubscription<AuthState> _authSubscription;

  var obscure1 = true;
  var obscure2 = true;

  void showAlert(String message) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Error".toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Colors.white,),
              SizedBox(height: 5,),
              Text(message, textAlign: TextAlign.center,),
            ],
          ),
          backgroundColor: Color.fromRGBO(43, 101, 249, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          actionsAlignment: MainAxisAlignment.center,
          titleTextStyle: TextStyle(color: Colors.white),
          contentTextStyle: TextStyle(color: Colors.white),
          actions: [
            MaterialButton(
              color: Color.fromRGBO(180,200,254,1),
              textColor: Color.fromRGBO(27,59,140,1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Aceptar".toUpperCase()),
            ),
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        setState(() {
          redirected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> resetPassword() async {
    setState(() {
      _loading = true;
    });

    try {
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(), 
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      showAlert("Mail enviado");
    } on AuthException catch (error) {
      if (mounted) {
        showAlert(error.message);
      }
    } catch (error) {
      if (mounted) {
        showAlert("Ocurrió un error inesperado");
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> updatePassword() async {
    if (passwordController.text.trim() == confirmPassword.text.trim()) {
      setState(() {
        _loading = true;
      });

      try {
        await supabase.auth.updateUser(
          UserAttributes(password: passwordController.text.trim())
        );
        showAlert("Contraseña guardado");
      } on AuthException catch (error) {
        if (mounted) {
          showAlert(error.message);
        }
      } catch (error) {
        if (mounted) {
          showAlert("Ocurrió un error inesperado");
        }
      } finally {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    } else {
      showAlert("Las contraseñas no coinciden");
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator(color: Colors.white,),);
    if (redirected) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              Image.asset("assets/logo-white.png", height: 100,),
              
              SizedBox(height: 30,),
            
              TextField(
                controller: passwordController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 18),
                obscureText: obscure1,
                decoration: InputDecoration(
                  hintText: "Contraseña nueva",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                  filled: true,
                  fillColor: Color.fromARGB(165, 0, 0, 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  suffixIcon: IconButton(
                            icon: obscure1 ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                obscure1 = !obscure1;
                              });
                            }, 
                          )
                ),
              ),

              SizedBox(height: 10,),

              TextField(
                controller: confirmPassword,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 18),
                obscureText: obscure2,
                decoration: InputDecoration(
                  hintText: "Confirmar contraseña nueva",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                  filled: true,
                  fillColor: Color.fromARGB(165, 0, 0, 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  suffixIcon: IconButton(
                    icon: obscure2 ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        obscure2 = !obscure2;
                      });
                    }, 
                  )
                ),
              ),

              SizedBox(height: 10,),

              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                  ),

                  onPressed: updatePassword,

                  child: Text("Actualizar".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                ),
              ),

              SizedBox(height: 20,),

              GestureDetector(
                onTap: () {
                  widget.changePage('login');
                },
                child: Text("Regresar a iniciar sesión", style: TextStyle(fontSize: 18, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white),),
              )
            ],
          )
        )
      );
    }
    return SafeArea(
      child: Stack(
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
            color: Colors.white,
            onPressed: () {
              widget.changePage("prelogin");
            },
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: [
                Image.asset("assets/logo-white.png", height: 100,),
                
                SizedBox(height: 30,),
              
                TextField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                    filled: true,
                    fillColor: Color.fromARGB(165, 0, 0, 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),

                SizedBox(height: 10,),

                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                    ),

                    onPressed: resetPassword,

                    child: Text("Enviar".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                  ),
                ),
              ],
            )
          )
        ]
      ),
    );
  }
}