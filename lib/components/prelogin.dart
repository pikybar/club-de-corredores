import 'package:flutter/material.dart';

class Prelogin extends StatelessWidget {
  const Prelogin({
    super.key,
    required this.changePage
  });

  final void Function(String page) changePage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            Image(image: AssetImage('assets/LogoWhite.png'), height: 180,),
        
            SizedBox(height: 50,),
        
            Text("Iniciar Sesión".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white,),),
        
            Divider(color: Colors.white, thickness: 2,),

            SizedBox(height: 4,),
        
            ElevatedButton(
              onPressed: () {
                changePage("registro");
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
                    child: Text("Registrarme".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
                  ),
                ],
              )
            ),

            SizedBox(height: 12,),

            ElevatedButton(
              onPressed: () {
                changePage("login");
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
                    child: Text("Iniciar Sesión".toUpperCase(), style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}