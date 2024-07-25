import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/carreras_page.dart';
import 'package:club_de_corredores/pages/inscripcion_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:provider/provider.dart';

class CarreraTemplate extends StatelessWidget {
  const CarreraTemplate({
    super.key,
    required this.img,
    required this.name,
    required this.time,
    required this.description,
    required this.infoPage,
    required this.inscripcionPage,
    required this.largadaImg,
  });

  final String img;
  final String name;
  final int time;
  final String description;
  final Widget infoPage;
  final Inscripcion inscripcionPage;
  final String largadaImg;


  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();
    carreraPage = this;

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
                    icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
                    color: Colors.black,
                    onPressed: () {
                      appState.setPage(CarrerasPage());
                    },
                  ),
                  Text("Carreras", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),),
                ]
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(img),
              
                  SizedBox(height: 8,),
              
                  Text(name.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: colorScheme.primary, fontSize: 30,),),
                  
                  TimerCountdown( 
                    timeTextStyle: Theme.of(context).textTheme.displayMedium,
                    descriptionTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Color.fromARGB(255, 84, 84, 84)),
                    colonsTextStyle: Theme.of(context).textTheme.displayMedium,
                    endTime: DateTime.fromMillisecondsSinceEpoch(time),
                    format: CountDownTimerFormat.daysHoursMinutesSeconds,
                    daysDescription: "Días",
                    hoursDescription: "Horas",
                    minutesDescription: "Minutos",
                    secondsDescription: "Segundos",
                    spacerWidth: 15,
                  ),
                  Text("CUENTA REGRESIVA", style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 20,)),
                  
                  SizedBox(height: 10,),
              
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(largadaImg, width: 210, height: 380, fit: BoxFit.cover,),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Color.fromARGB(255, 84, 84, 84)), softWrap: true,),
                              SizedBox(height: 10,),
                              Wrap(
                                spacing: 10,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 193, 193), padding: EdgeInsets.symmetric(horizontal: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),),
                                    onPressed: () {
                                      appState.setPage(infoPage);
                                    }, 
                                    child: Text("VER MÁS", style: TextStyle(color: Colors.black, fontSize: 15),),
                                  ),
                                                    
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),), elevation: 0),
                                    onPressed: () {
                                      prevPage = this;
                                      appState.setPage(inscripcionPage);
                                    }, 
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [colorScheme.primary, Color.fromARGB(255, 100, 21, 21)],
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                                        child: Text("INSCRIBIRME", style: TextStyle(color: Colors.white, fontSize: 15),),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ), 
        ],
      ),
    );
  }
}
