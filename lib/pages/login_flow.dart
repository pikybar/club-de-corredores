import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_countries/iso_countries.dart';

import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/components/prelogin.dart';
import 'package:club_de_corredores/components/avatar.dart';
import 'package:club_de_corredores/pages/home_corredor_page.dart';
import 'package:club_de_corredores/components/forgot_password.dart';

var direct = "perfil"; //which page to direct to after login

class Login extends StatelessWidget {
  const Login({
    super.key,
    required this.directTo,
  });

  final String directTo;

  @override
  Widget build(BuildContext context) {
    direct = directTo;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(155, 21, 21, 1),
        backgroundBlendMode: BlendMode.luminosity,
        image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, opacity: 0.25,)
      ),
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LoginContent(),
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  var page = supabase.auth.currentSession == null ? "prelogin" : "cuenta";
  var _loading = false;

  final nacimientoController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  String? genero;
  final paisController = TextEditingController();
  final provinciaController = TextEditingController();
  final ciudadController = TextEditingController();
  final postalController = TextEditingController();
  final documentoController = TextEditingController();
  final celularController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPassword = TextEditingController();

  XFile? _image;

  var obscure1 = true;
  var obscure2 = true;
  var obscure3 = true;

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

  Future<void> register() async {
    setState(() {
      _loading = true;
    });

    try {
      // check for matching dni in database
      final data = await supabase.from('profiles').select().eq('dni', documentoController.text.trim()); 

      if(
        nacimientoController.text == "" ||
        nombreController.text == "" ||
        apellidoController.text == "" ||
        emailController.text == "" ||
        passwordController.text == "" ||
        repeatPassword.text == "" ||
        genero == null ||
        paisController.text == "" ||
        provinciaController.text == "" ||
        ciudadController.text == "" ||
        postalController.text == "" ||
        documentoController.text == "" ||
        celularController.text == "" 
      ) {
        showAlert("Información incompleta");
      } else if (data.isNotEmpty && mounted) { // if there is an existing account with the dni entered
        showAlert("Este número de DNI ya está vinculado a una cuenta en Club de Corredores. Ingresá a esa cuenta o ponete en contacto con el club.");
      } else if (passwordController.text.trim() != repeatPassword.text.trim()) {
        showAlert("Las contraseñas no coinciden");
      } else {
        await supabase.auth.signUp(
          password: passwordController.text.trim(), 
          email: emailController.text.trim()
        );

        await supabase.auth.signInWithPassword(
          password: passwordController.text.trim(), 
          email: emailController.text.trim() 
        );

        if (mounted) {
          final user = supabase.auth.currentUser;
          final updates = {
            'id': user!.id,
            'nombre': nombreController.text.trim(),
            'apellido': apellidoController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
            'email': emailController.text.trim(),
            'genero': genero,
            'fecha_nacimiento': nacimientoController.text.trim(),
            'pais': paisController.text.trim(),
            'provincia': provinciaController.text.trim(),
            'ciudad': ciudadController.text.trim(),
            'codigo_postal': postalController.text.trim(),
            'dni': documentoController.text.trim(),
            'celular': celularController.text.trim(),
          };
          await supabase.from('profiles').upsert(updates);

          if (_image != null) {
            final imageExtension = _image!.path.split(".").last.toLowerCase();
            final imageBytes = await _image!.readAsBytes();
            final userId = supabase.auth.currentUser!.id;
            final imagePath = '/$userId/avatar';
            await supabase.storage.from('avatars').uploadBinary(
              imagePath, 
              imageBytes, 
              fileOptions: FileOptions(upsert: true, contentType: 'image/$imageExtension')
            );
            await supabase.from('profiles').update({'avatar_url': supabase.storage.from('avatars').getPublicUrl(imagePath)}).eq('id', userId);
          }

          if (mounted) {
            setState(() {
              page = "cuenta";
            });
          }
        }
      }
    } on AuthException catch (error) {
      if (mounted) showAlert(error.message);
    } on PostgrestException catch (error) {
      if (mounted) showAlert(error.message);
    } on StorageException catch (error) {
      if (mounted) showAlert(error.message);
    } catch (error) {
      if (mounted) {
        if (mounted) showAlert("Ocurrió un error inesperado");
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  List<Country> countryList = <Country>[];
  Country? country;
  @override
  void initState() {
    super.initState();
    prepareDefaultCountries();
  }

  Future<void> prepareDefaultCountries() async {
    List<Country>? countries;
    try {
      countries = await IsoCountries.isoCountries;
    } on PlatformException {
      countries = null;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      if (countries != null) {
        countryList = countries;
      }
    });
  }

  Future<void> prepareLocaleSpecificCountries() async {
    setState(() {
      _loading = true;
    });

    List<Country>? countries;

    try {
      countries = await IsoCountries.isoCountriesForLocale('es-es');
    } on PlatformException {
      countries = null;
    } catch (error) {
      print(error);
    }

    if (!mounted) {
      setState(() {
        _loading = false;
      });
      return;
    }

    setState(() {
      if (countries != null) {
        countryList = countries;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator(color: Colors.white,),);

    switch (page) {
      case "prelogin":
        return Prelogin(changePage: (p) {
          setState(() {
            page = p;
          });
        });

      case "login":
        Future<void> signIn() async {
          setState(() {
            _loading = true;
          });

          try {
            await supabase.auth.signInWithPassword(
              password: passwordController.text.trim(), 
              email: emailController.text.trim()
            );
            setState(() {
              page = "cuenta";
            });
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

        return SafeArea(
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    page = "prelogin";
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    Image(image: AssetImage('assets/LogoWhite.png'), height: 180,),
                
                    SizedBox(height: 50,),
                
                    Text("Iniciar Sesión".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,),),
                
                    Divider(color: Colors.white, thickness: 2,),
                
                    SizedBox(height: 4,),
                
                    TextField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
                        filled: true,
                        fillColor: Color.fromARGB(165, 0, 0, 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),

                    SizedBox(height: 10,),
                
                    TextField(
                      controller: passwordController,
                      obscureText: obscure1,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
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

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            page = "olvideContrasena";
                          });
                        },
                        child: Text("Olvidé mi contraseña", style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline, decorationColor: Colors.white),),
                      ),
                    ),  
                    
                    SizedBox(height: 10,),
                
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                        ),

                        onPressed: () {
                          signIn();
                        },

                        child: Text("Iniciar sesión".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        );
      
      case "registro":
        Future<void> selectDate() async {
          DateTime? picked = await showDatePicker(
            context: context, 
            firstDate: DateTime(1900), 
            lastDate: DateTime(2024)
          );

          if (picked != null) {
            nacimientoController.text = picked.toString().split(" ")[0];
          }
        }

        prepareLocaleSpecificCountries();

        return SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      page = "prelogin";
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset("assets/logo-white.png", height: 100,),

                      SizedBox(height: 10,),
                  
                      Avatar(image: _image, onUpload: (image){
                        setState(() {
                          _image = image;
                        });
                      }),

                      SizedBox(height: 10,),
                      
                      TextField(
                        controller: nombreController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Nombre/s",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Color.fromARGB(165, 0, 0, 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                          
                      SizedBox(height: 10,),
                          
                      TextField(
                        controller: apellidoController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Apellido",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Color.fromARGB(165, 0, 0, 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                          
                      SizedBox(height: 10,),
                          
                      TextField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "E-mail (de acceso a Entryfee, si tenés)",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Color.fromARGB(165, 0, 0, 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),

                      SizedBox(height: 10,),
                      
                      TextField(
                        controller: passwordController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        obscureText: obscure2,
                        decoration: InputDecoration(
                          hintText: "Crear contraseña",
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
                      
                      TextField(
                        controller: repeatPassword,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        obscureText: obscure3,
                        decoration: InputDecoration(
                          hintText: "Confirmar contraseña",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Color.fromARGB(165, 0, 0, 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          suffixIcon: IconButton(
                            icon: obscure3 ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                obscure3 = !obscure3;
                              });
                            }, 
                          )
                        ),
                      ),
                          
                      SizedBox(height: 10,),
                          
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Género", style: TextStyle(color: Colors.white, fontSize: 18,),),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color.fromARGB(165, 0, 0, 0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                buttonColor: Color.fromARGB(165, 0, 0, 0),
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  hint: Text("Seleccionar", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),),
                                  borderRadius: BorderRadius.circular(8),
                                  dropdownColor: Color.fromARGB(165, 0, 0, 0),
                                  value: genero,
                                  style: TextStyle(color: Colors.white, fontSize: 18,),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 11, right: 2),
                                    child: Icon(Icons.keyboard_arrow_down, size: 35, color: Colors.white,),
                                  ),
                                  items: [
                                    DropdownMenuItem(value: "Femenino", child: Text("Femenino"),),
                                    DropdownMenuItem(value: "Masculino", child: Text("Masculino"),),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      genero = value;
                                    });
                                  }
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                          
                      SizedBox(height: 10,),
                          
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Fecha de nacimiento", style: TextStyle(color: Colors.white, fontSize: 18,),),
                          ),
                          
                          SizedBox(
                            width: 160,
                            child: TextField(
                              controller: nacimientoController,
                              readOnly: true,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Seleccionar",
                                hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                                filled: true,
                                fillColor: Color.fromARGB(165, 0, 0, 0),
                                suffixIcon: Icon(Icons.keyboard_arrow_down, size: 35, color: Colors.white,),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(left: 12),
                              ),
                            
                              onTap: () {
                                selectDate();
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),
                          
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("País", style: TextStyle(color: Colors.white, fontSize: 18,),),
                          ),
                          
                          DropdownMenu(
                            width: 225,
                            controller: paisController,
                            requestFocusOnTap: true,
                            enableFilter: true,
                            hintText: "Seleccionar",
                            trailingIcon: Icon(Icons.abc, size: 0,),
                            selectedTrailingIcon: Icon(Icons.abc, size: 0,),
                            textStyle: TextStyle(color: Colors.white, fontSize: 18,),
                            inputDecorationTheme: InputDecorationTheme(
                              constraints: const BoxConstraints(maxHeight: 50),
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300), 
                              fillColor: Color.fromARGB(165, 0, 0, 0), 
                              filled: true,
                              suffixIconColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                            ),
                            menuStyle: const MenuStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(165, 0, 0, 0)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))))
                            ),
                            dropdownMenuEntries: countryList.map((country) => DropdownMenuEntry(
                              value: country.name, 
                              label: country.name,
                              style: MenuItemButton.styleFrom(textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w300), foregroundColor: Colors.white),
                            )).toList(),
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),
                          
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Provincia", style: TextStyle(color: Colors.white, fontSize: 18,),),
                          ),
                          
                          SizedBox(
                            width: 225,
                            child: TextField(
                              controller: provinciaController,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Provincia",
                                hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                                filled: true,
                                fillColor: Color.fromARGB(165, 0, 0, 0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),
                          
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Ciudad", style: TextStyle(color: Colors.white, fontSize: 18,),),
                          ),
                          
                          SizedBox(
                            width: 225,
                            child: TextField(
                              controller: ciudadController,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Ciudad",
                                hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                                filled: true,
                                fillColor: Color.fromARGB(165, 0, 0, 0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10,),
                      
                      TextField(
                        controller: postalController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Código postal",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Color.fromARGB(165, 0, 0, 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),

                      SizedBox(height: 10,),
                      
                      TextField(
                        controller: documentoController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Número de documento",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Color.fromARGB(165, 0, 0, 0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4))).copyWith(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),

                      SizedBox(height: 10,),
                      
                      TextField(
                        controller: celularController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Número de celular",
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

                          onPressed: () {
                            register();
                          },

                          child: Text("Registrarme".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),)
                        ),
                      ),

                      SizedBox(height: 100,),
                    ],
                  ),
                ),
              ]
            ),
          )
        );

      case "cuenta":
        Future<void> signOut() async {
          setState(() {
            _loading = true;
          });

          try {
            await supabase.auth.signOut();
            if (mounted) {
              setState(() {
                page = "prelogin";
              });
            }
          } on AuthException catch (error) {
            if (mounted) showAlert(error.message);
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

        Future<void> getImage() async {
          final userId = supabase.auth.currentUser!.id;
          final data = await supabase.from('profiles').select().eq('id', userId).single();
          imageUrl = data['avatar_url'];
          if(imageUrl != null) imageUrl = Uri.parse(imageUrl!).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();
        }

        Future<void> saveImage() async {

          final sm = ScaffoldMessenger.of(context);

          if (_image != null) {
            setState(() {
              _loading = true;
            });

            try {
              final imageExtension = _image!.path.split(".").last.toLowerCase();
              final imageBytes = await _image!.readAsBytes();
              final userId = supabase.auth.currentUser!.id;
              final imagePath = '/$userId/avatar';
              await supabase.storage.from('avatars').uploadBinary(
                imagePath, 
                imageBytes, 
                fileOptions: FileOptions(upsert: true, contentType: 'image/$imageExtension')
              );
              await supabase.from('profiles').update({'avatar_url': supabase.storage.from('avatars').getPublicUrl(imagePath)}).eq('id', userId);
              if (mounted) {
                showAlert('Imagen guardada');
              }
            } on StorageException catch (error) {
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
            sm.showSnackBar(SnackBar(content: Text("Imagen no seleccionada")));
          }
        }

        if (direct == "home") {
          return HomeCorredorPage();
        } else {
          getImage();
          return Column(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text("¿Salir de sesión?"),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar"),
                                  ),

                                  MaterialButton(
                                    textColor: Theme.of(context).colorScheme.primary,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      signOut();
                                    }, 
                                    child: Text("Salir"),
                                  ),
                                ],
                              );
                            }
                          );
                        },
                        child: Text("Salir de sesión")
                      ),

                      SizedBox(height: 10,),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            if (imageUrl != null && _image == null) Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)), child: Image.network(imageUrl!, height: 120, width: double.infinity, fit: BoxFit.cover,)),
                            Avatar(image: _image, onUpload: (image) {
                              setState(() {
                                _image = image;
                              });
                            }),
                          ]
                        ),
                      ),
                  
                      ElevatedButton(onPressed: saveImage, child: Text('guardar imagen')),

                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text("¿Borrar cuenta?"),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar"),
                                  ),

                                  MaterialButton(
                                    textColor: Theme.of(context).colorScheme.primary,
                                    onPressed: () async {
                                      try {
                                        final userId = supabase.auth.currentUser!.id;
                                        final objects = await supabase.storage.from('avatars').remove(['$userId/avatar']);
                                        print(objects);
                                        await supabase.functions.invoke("delete-account");
                                      } catch (error) {
                                        print(error);
                                      } finally {
                                        if (context.mounted) Navigator.pop(context);
                                        signOut();
                                      }
                                    }, 
                                    child: Text("Borrar"),
                                  ),
                                ],
                              );
                            }
                          );
                        }, 
                        child: Text("Borrar cuenta")
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      
      case "olvideContrasena":
        return ForgotPassword(changePage: (p) {
          setState(() {
            page = p;
          });
        });

      default: return SafeArea(child: Center(child: Text("oops,\npágina no existe", style: TextStyle(fontSize: 30, color: Colors.white),)));
    }
  }
}