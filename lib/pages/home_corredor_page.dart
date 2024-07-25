import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/initial_page.dart';
import 'package:club_de_corredores/pages/mis_carreras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  if (imageUrl != null) Image.network(imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover,),
                        
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
                        launchUrl(Uri.parse('https://www.fotorun.com.ar/'));
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