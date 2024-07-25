import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/carrera_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiCarreraCard extends StatelessWidget {
  const MiCarreraCard({
    super.key,
    required this.pageLink,
    required this.logo
  });

  final CarreraTemplate pageLink;
  final String logo;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var colorScheme = Theme.of(context).colorScheme;
    final daysLeft = (DateTime.fromMillisecondsSinceEpoch(pageLink.time).difference(DateTime.now()).inHours / 24).round();

    return GestureDetector(
      onTap: () {
        appState.setPage(pageLink);
      },
      child: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(0),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Image.network(logo, alignment: Alignment.topCenter, height: 100, width: 110,),
                ),
                    
                VerticalDivider(color: Colors.black, indent: 10, endIndent: 10, width: 20,),
            
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          daysLeft < 0 ? "Carrera terminada" : "Faltan $daysLeft días", 
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                        ),

                        SizedBox(height: 2,),

                        if(daysLeft > 0) Text("No olvides acreditarte!", maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true, style: Theme.of(context).textTheme.bodyMedium),
                        
                        SizedBox(height: 8,),

                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), 
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3), 
                                minimumSize: Size.zero,
                                backgroundColor: daysLeft < 0 ? Color.fromRGBO(218,218,218,1) : colorScheme.primaryContainer,
                              ),
                              onPressed: () {
                                print("recorrido");
                              },
                              child: Text("Ver Recorrido", style: TextStyle(fontSize: 15, color: daysLeft < 0 ? Colors.black : colorScheme.primary),)
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, minimumSize: Size.zero, elevation: 0, padding: EdgeInsets.all(0)),
                              onPressed: () {
                                appState.setPage(pageLink);
                              },
                              child: Text("Ver más", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}