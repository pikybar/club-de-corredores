import 'package:club_de_corredores/main.dart';
import 'package:club_de_corredores/pages/carreras_page.dart';
import 'package:club_de_corredores/pages/login_flow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(155, 21, 21, 1),
        backgroundBlendMode: BlendMode.luminosity,
        image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover, opacity: 0.25,)
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Image(image: AssetImage('assets/logo-white.png'), height: 130,),
              SizedBox(height: 10,),
              
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 35
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        appState.setPage(CarrerasPage());
                      }, 
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                        backgroundColor: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Carreras".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
                        )]
                      ),
                    ),
                
                    SizedBox(
                      height: 350,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: carreraCardsList,
                      ),
                    ),
                  ],
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 35
                ),
                child: ElevatedButton(
                  onPressed: () {
                    appState.setPage(
                      Login(directTo: "home")
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Home Corredor".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),
                      ),
                    ],
                  )
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 35
                ),
                child: ElevatedButton(
                  onPressed: () {
                    appState.setPage(Placeholder());
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                    backgroundColor: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Expos Abiertas".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
                      ),
                    ],
                  )
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
