import 'package:carousel_slider/carousel_slider.dart';
import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/inscripcion_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarreraInfoTemplate extends StatefulWidget {
  const CarreraInfoTemplate({
    super.key,
    required this.images,
    required this.name,
    required this.medallaImg,
    required this.description,
    required this.inscripcionPage,
  });

  final List<dynamic> images; //slider images
  final String name;
  final String medallaImg;
  final String description;
  final Inscripcion inscripcionPage;

  @override
  State<CarreraInfoTemplate> createState() => _CarreraInfoTemplateState();
}

class _CarreraInfoTemplateState extends State<CarreraInfoTemplate> {
  int _current = 0;
  bool inMisCarreras = false;
  final CarouselController _controller = CarouselController();
  var _loading = true;

  Future<void> _getMisCarreras() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data = await supabase.from('profiles').select().eq('id', userId).single();
      final List<dynamic>? misCarreras = data['mis_carreras'];
      if (misCarreras != null) inMisCarreras = misCarreras.contains(widget.name);
    } catch (error) {
      print(error);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getMisCarreras();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator(color: Colors.white,));
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();
    final List<Widget> imageSliders = widget.images.map((item) => Container(
      margin: EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
      ),
    )).toList();

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
                      appState.setPage(carreraPage!);
                    },
                  ),
      
                  Text(widget.name, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),),
                ]
              ),
            ),
          ),

          Expanded(child: SingleChildScrollView(child: Column(children: [
              Stack(
              children: [
                CarouselSlider(
                  items: imageSliders, 
                  carouselController: _controller,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 2.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  )
                ),

                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row( //Carousel indicator
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.images.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (_current == entry.key ? colorScheme.primary : const Color.fromARGB(188, 0, 0, 0)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ]
            ),

            SizedBox(height: 15,),
        
            Text(widget.name.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: colorScheme.primary, fontSize: 30),),

            SizedBox(height: 15,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.medallaImg, width: 200,),
                SizedBox(width: 10,),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kit y Medalla", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
                        Text(widget.description, style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.254, color: Color.fromARGB(255, 84, 84, 84)),),
                        SizedBox(height: 6,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 193, 193),
                            padding: EdgeInsets.symmetric(horizontal: 10), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                          ),
                          onPressed: () {
                            print("retiro de kit");
                          }, 
                          child: Text("Retiro de kit".toUpperCase(), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),)
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
        
            SizedBox(height: 20,),
        
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: AssetImage('assets/medio-ambiente.jpg'), width: 200,),
                SizedBox(width: 10,),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fotorun", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
                        Text(
                          "descripción fotorun y kit en carrera descripción fotorun y kit en carrera descripción", 
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.254, color: Color.fromARGB(255, 84, 84, 84)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 20,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 193, 193), padding: EdgeInsets.symmetric(horizontal: 58), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),),
              onPressed: () {
                print("apto medico");
              }, 
              child: Text("apto médico".toUpperCase(), style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
            ),

            SizedBox(height: 02,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),), elevation: 0),
              onPressed: () {
                prevPage = widget;
                appState.setPage(widget.inscripcionPage);
              }, 
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colorScheme.primary, Color.fromARGB(255, 100, 21, 21)]),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 4),
                  child: Text("inscribirme".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,),),
                )
              ),
            ),

            SizedBox(height: 5,),

            if (supabase.auth.currentSession != null)
              SizedBox(
                width: 248,
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Color.fromARGB(184, 218, 218, 218),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _loading = true;
                      });

                      try {
                        final userId = supabase.auth.currentUser!.id;
                        final data = await supabase.from('profiles').select().eq('id', userId).single();
                        List<dynamic>? misCarreras = data['mis_carreras'];
                        if (misCarreras == null) {
                          await supabase.from('profiles').update({'mis_carreras': [widget.name]}).eq('id', userId);
                        } else if (misCarreras.contains(widget.name)) {
                          misCarreras.remove(widget.name);
                          await supabase.from('profiles').update({'mis_carreras': misCarreras}).eq('id', userId);
                        } else {
                          misCarreras.add(widget.name);
                          await supabase.from('profiles').update({'mis_carreras': misCarreras}).eq('id', userId);
                        }
                        setState(() {
                          inMisCarreras = !inMisCarreras;
                        });
                      } catch (error) {
                        print(error);
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                      
                    },
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.85,
                          child: Checkbox(
                            value: inMisCarreras,
                            checkColor: colorScheme.primary,
                            side: WidgetStateBorderSide.resolveWith((states) => BorderSide(color: colorScheme.primary, width: 2, strokeAlign: 3.5)),
                            shape: CircleBorder(),
                            onChanged: (bool? newValue) async {
                              setState(() {
                                _loading = true;
                              });

                              try {
                                final userId = supabase.auth.currentUser!.id;
                                final data = await supabase.from('profiles').select().eq('id', userId).single();
                                List<dynamic>? misCarreras = data['mis_carreras'];
                                if (misCarreras == null) {
                                  await supabase.from('profiles').update({'mis_carreras': [widget.name]}).eq('id', userId);
                                } else if (misCarreras.contains(widget.name)) {
                                  misCarreras.remove(widget.name);
                                  await supabase.from('profiles').update({'mis_carreras': misCarreras}).eq('id', userId);
                                } else {
                                  misCarreras.add(widget.name);
                                  await supabase.from('profiles').update({'mis_carreras': misCarreras}).eq('id', userId);
                                }
                                setState(() {
                                  inMisCarreras = newValue!;
                                });
                              } catch (error) {
                                print(error);
                              } finally {
                                setState(() {
                                  _loading = false;
                                });
                              }
                              
                            },
                          ),
                        ),
                    
                        Expanded(child: Text(inMisCarreras ? "Remover de MIS CARRERAS" : "Agregar a MIS CARRERAS", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),)),
                      ]
                    ),
                  ),
                ),
              )
          ],),)),
        ],
      ),
    );
  }
}