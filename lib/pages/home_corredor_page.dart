import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/initial_page.dart';
import 'package:club_de_corredores/pages/mis_carreras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String? imageUrl;

class HomeCorredorPage extends StatefulWidget {
  @override
  State<HomeCorredorPage> createState() => _HomeCorredorPageState();
}

class _HomeCorredorPageState extends State<HomeCorredorPage> {
  var _loading = false;

  Future<void> getImage() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase.from('profiles').select().eq('id', userId).single();
      imageUrl = data['avatar_url'];
      if(imageUrl != null) imageUrl = Uri.parse(imageUrl!).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (_loading) return Center(child: CircularProgressIndicator(color: Colors.white,));

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(155, 21, 21, 1),
        backgroundBlendMode: BlendMode.luminosity,
        image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, opacity: 0.25)
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
                  color: Colors.white,
                  onPressed: () {
                    appState.setPage(InitialPage());
                  },
                ),
              ],
            ),
        
            Expanded(
              child: ListView(
                children: [
                  if (imageUrl != null) Image.network(imageUrl!),
                        
                  SizedBox(height: 20,),
                            
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 55
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setPage(MisCarreras());
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Mis Carreras".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                          ),
                        ],
                      )
                    ),
                  ),
                            
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 55
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setPage(Placeholder());
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Clasificaciones".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                          ),
                        ],
                      )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 55
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setPage(Placeholder());
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Fotos de carrera".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* class HomeCorredorPage extends StatefulWidget {
  @override
  State<HomeCorredorPage> createState() => _HomeCorredorPageState();
}

class _HomeCorredorPageState extends State<HomeCorredorPage> {
  var showAptoMedico = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Widget aptoMedico;

    if (showAptoMedico) {
      aptoMedico = Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          color: const Color.fromARGB(165, 0, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Text("Apto Médico".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                  onTap: () {
                    setState(() {
                      showAptoMedico = false;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
                child: Placeholder(fallbackHeight: 300, fallbackWidth: 300,),
              ),
            ],
          ),
        ),
      );
    } else {
      aptoMedico = Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 55
        ),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              showAptoMedico = true;
            });
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Apto Médico".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
              ),
            ],
          )
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(155, 21, 21, 1),
        backgroundBlendMode: BlendMode.luminosity,
        image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, opacity: 0.25)
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
                  color: Colors.white,
                  onPressed: () {
                    appState.setPage(InitialPage());
                  },
                ),
              ],
            ),
        
            Expanded(
              child: ListView(
                children: [
                  Image(image: AssetImage("assets/carrera_maya.png")),
                        
                  SizedBox(height: 20,),
                            
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 55
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setPage(Placeholder());
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Mis Carreras".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                          ),
                        ],
                      )
                    ),
                  ),
                            
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 55
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        appState.setPage(Placeholder());
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1),),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Certificados".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                          ),
                        ],
                      )
                    ),
                  ),
                            
                  aptoMedico,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
} */