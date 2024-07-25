import 'package:club_de_corredores/pages/carrera_template.dart';
import 'package:club_de_corredores/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarreraCard extends StatelessWidget {
  const CarreraCard({
    super.key,
    required this.description,
    required this.pageLink,
    required this.distances,
    required this.type,
  });

  final String description;
  final CarreraTemplate pageLink;
  final List<dynamic> distances;
  final String type;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    String name = pageLink.name;
    String img = pageLink.img;

    return GestureDetector(
      onTap: () {
        appState.setPage(pageLink);
      },
      child: SizedBox(
        height: 150,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.network(img, fit: BoxFit.cover,),
                  ),
                ),
            
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name, 
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          SizedBox(height: 2,),
                          Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true, style: Theme.of(context).textTheme.bodyMedium),
                          SizedBox(height: 8,),
                          Wrap(
                            children: [
                              Wrap(
                                spacing: 3,
                                children: distances.map((distance) => Card(
                                  margin: EdgeInsets.zero,
                                  color: Color.fromARGB(255, 40, 39, 39),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      distance, 
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )).toList(),
                              ),
                              SizedBox(width: 3,),
                              Card(
                                margin: EdgeInsets.zero,
                                color: Color.fromARGB(255, 40, 39, 39),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(type, style: TextStyle(color: Colors.white,),),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text("Ver más", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
          )
        ),
      ),
    );
  }
}
