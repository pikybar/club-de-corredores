import 'package:club_de_corredores/components/mi_carrera_card.dart';
import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/home_corredor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MisCarreras extends StatefulWidget {
  @override
  State<MisCarreras> createState() => _MisCarrerasState();
}

class _MisCarrerasState extends State<MisCarreras> {
  List<dynamic>? misCarreras;
  Set<MiCarreraCard> upcoming = {};
  Set<MiCarreraCard> past = {};
  var message = "Agregar una carrera para verla acá";
  var _loading = false;

  Future<void> loadMisCarreras() async {
    setState(() {
      _loading = true;
    });
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data = await supabase.from('profiles').select().eq('id', userId).single();
      misCarreras = data['mis_carreras'];

      if (misCarreras != null) {
        for (var carrera in misCarrerasCards) {
          for (var miCarrera in misCarreras!) {
            if (miCarrera.toString() == carrera.pageLink.name) {
              if (carrera.pageLink.time < DateTime.now().millisecondsSinceEpoch) {
                past.add(carrera);
              } else {
                upcoming.add(carrera);
              }
            }
          }
        }
      } else {
        print("nothing in mis carreras");
      }
    } on AuthException catch (error) {
      print(error.message);
      setState(() {
        message = "No pudo acceder carreras guardadas";
      });
    } catch (error) {
      print(error);
      setState(() {
        message = "No pudo acceder carreras guardadas";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadMisCarreras();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    } 

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
                      appState.setPage(HomeCorredorPage());
                    },
                  ),
                  Text("Home Corredor", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),),
                ]
              ),
            ),
          ),

          SizedBox(height: 10,),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: CustomScrollView(
                slivers: [
                  if (upcoming.isNotEmpty || (past.isEmpty && upcoming.isEmpty)) SliverToBoxAdapter(
                    child: Text("Mis Carreras".toUpperCase(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: colorScheme.primary, fontSize: 26, fontWeight: FontWeight.w500),),
                  ),

                  
                  if (past.isEmpty && upcoming.isEmpty) SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),

                  if (upcoming.isNotEmpty) SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: upcoming.length,
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: upcoming.toList()[index],
                        );
                      }
                    ),
                  ),

                  if (past.isNotEmpty) SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text("Carreras Pasadas".toUpperCase(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: colorScheme.primary, fontSize: 26, fontWeight: FontWeight.w500),),
                    ),
                  ),

                  if (past.isNotEmpty) SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: past.length,
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: past.toList()[index],
                        );
                      }
                    ),
                  ),
                ],
              ),
            )
          ),
        ]
      )
    );
  }
}