import 'package:club_de_corredores/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Inscripcion extends StatelessWidget {
  const Inscripcion({
    super.key,
    required this.reglamento,
    required this.name,
    required this.logo,
    required this.img,
    required this.modalidades
  });

  final String reglamento;
  final String name;
  final String logo;
  final String img;
  final List<dynamic> modalidades;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();

    return Container(
      color: Color.fromRGBO(244,251,248,1),
      child: Column(
        children: [
          Container(
            color: colorScheme.primary,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45),
                    color: Colors.black,
                    onPressed: () {
                      appState.setPage(prevPage);
                    },
                  ),
      
                  Text(name, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),),
                ]
              ),
            ),
          ),

          SizedBox(height: 20,),
                    
          Image.network(logo),
                    
          SizedBox(height: 15,),
                    
          Text("Modalidad".toUpperCase(), style: Theme.of(context).textTheme.displaySmall!.copyWith(color: colorScheme.primary, fontSize: 30, fontWeight: FontWeight.w500),),
                    
          // SizedBox(height: 20,),
                    
          Flexible(
            child: GridView.count(
              childAspectRatio: 1/1.25,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              shrinkWrap: true,
              crossAxisCount: modalidades.length > 1 ? 2 : 1,
              children: modalidades.map((modalidad) => SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(img, fit: BoxFit.cover, width: double.infinity, height: 80,),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15, right: 10),
                        child: Text(modalidad[0].toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("${modalidad[1]}\n\n\n", maxLines: 3, overflow: TextOverflow.ellipsis,),
                      ),
                      GestureDetector(
                        onTap: () => launchUrl(Uri.parse(modalidad[2])),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text("CONTINUAR", textAlign: TextAlign.end, style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),),
                        ),
                      )
                    ],
                  ),
                ),
              )).toList()
            ),
          ),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 193, 193), padding: EdgeInsets.symmetric(horizontal: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),),
            onPressed: () => launchUrl(Uri.parse(reglamento)), 
            child: Text("Conocer reglamento".toUpperCase(), style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
          ),

          SizedBox(height: 10,)
        ]
      )
    );
  }
}