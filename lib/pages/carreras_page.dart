import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarrerasPage extends StatefulWidget {
  @override
  State<CarrerasPage> createState() => _CarrerasPageState();
}

class _CarrerasPageState extends State<CarrerasPage> {
  final List<String> distances = ["5K", "10K", "+10K"];
  final List<String> types = ["Trail", "Calle"];

  List<String> selectedDistances = [];
  List<String> selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    Set filteredCarreras = {};

    for (var c in carreraCardsList) {
      for (var d in c.distances) {
        if ((selectedDistances.contains(d) && selectedTypes.contains(c.type))
        ||
        (selectedDistances.contains(d) && selectedTypes.isEmpty)
        ||
        (selectedDistances.isEmpty && selectedTypes.contains(c.type))
        ||
        (selectedDistances.isEmpty && selectedTypes.isEmpty)) {
          filteredCarreras.add(c);
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(155, 21, 21, 1),
        backgroundBlendMode: BlendMode.luminosity,
        image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, opacity: 0.25)
      ),
      child: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.only(left: 8),
                  icon: Icon(Icons.keyboard_arrow_left_rounded, size: 45,),
                  color: Colors.white,
                  onPressed: () {
                    appState.setPage(InitialPage());
                  },
                ),
              ],
            ),
          ),

          Text("Carreras".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,),),
          
          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Card(
              elevation: 0,
              color: const Color.fromRGBO(0, 0, 0, 0),
              child: Row(
                children: [
                  Wrap(
                    spacing: 8,
                    children: distances.map((distance) => FilterChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(255, 40, 39, 39),
                      selectedColor: Colors.white,
                      side: BorderSide(width: 0),
                      labelStyle: TextStyle(color: selectedDistances.contains(distance) ? Colors.black : Colors.white),
                      label: Text(distance),
                      selected: selectedDistances.contains(distance),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDistances.add(distance);
                          } else {
                            selectedDistances.remove(distance);
                          }
                        });
                      }
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 5,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Row(
                children: [
                  Wrap(
                    spacing: 8,
                    children: types.map((type) => FilterChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(255, 40, 39, 39),
                      selectedColor: Colors.white,
                      side: BorderSide(width: 0),
                      labelStyle: TextStyle(color: selectedTypes.contains(type) ? Colors.black : Colors.white),
                      label: Text(type),
                      selected: selectedTypes.contains(type),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTypes.add(type);
                          } else {
                            selectedTypes.remove(type);
                          }
                        });
                      }
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 5,),
          
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredCarreras.length,
              itemBuilder: (context, index) {
                return filteredCarreras.toList()[index];
              },
            ),
          )),
        ]
      ),
    );
  }
}
