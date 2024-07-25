import 'package:club_de_corredores/components/carrera_card.dart';
import 'package:club_de_corredores/components/mi_carrera_card.dart';
import 'package:club_de_corredores/pages/carrera_info_template.dart';
import 'package:club_de_corredores/pages/carrera_template.dart';
import 'package:club_de_corredores/pages/initial_page.dart';
import 'package:club_de_corredores/pages/inscripcion_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
// import 'package:club_de_corredores/carreras/carrera_maya.dart';
import 'package:club_de_corredores/pages/login_flow.dart';

List<CarreraCard> carreraCardsList = [];
List<MiCarreraCard> misCarrerasCards = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://xgzgpobmfxfsckelloss.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhnemdwb2JtZnhmc2NrZWxsb3NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk1MTYyMzgsImV4cCI6MjAzNTA5MjIzOH0.YrlFLCz3J8UmifZ58coDZMqSWAuER_h2PO_cfIF_1ZA",
    authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce)
  );

  //create pages and cards for each carrera, then add to card lists
  final supabase = Supabase.instance.client;
  final data = await supabase.from('carreras').select();
  for (var carrera in data) {
    String name = carrera['nombre'];
    int time = DateTime.parse(carrera['evento_fecha_hora']).millisecondsSinceEpoch;
    String description = carrera['descripcion'];
    String cardDescription; 
    if (carrera['descripcion_corta'] == null) {
      cardDescription = carrera['descripcion'];
    } else {
      cardDescription = carrera['descripcion_corta'];
    }
    List<dynamic> distances = carrera['distancias'];
    String type = carrera['tipo'];
    String kitMedallaDesc = carrera['descripcion_kit_medalla'];
    String reglamento = carrera['reglamento_link'];
    List<dynamic> modalidades = carrera['modalidades'];
    String imgMain = carrera['main_imagen'];
    String imgLargada = carrera['largada_imagen'];
    List<dynamic> imgsSlider = carrera['slider_imagenes'];
    String imgKitMedalla = carrera['medalla_kit_imagen'];
    String logo = carrera['carrera_logo_imagen'];

    Inscripcion insc = Inscripcion(reglamento: reglamento, name: name, logo: logo, img: imgMain, modalidades: modalidades);
    CarreraInfoTemplate info = CarreraInfoTemplate(images: imgsSlider, name: name, medallaImg: imgKitMedalla, description: kitMedallaDesc, inscripcionPage: insc);
    CarreraTemplate page = CarreraTemplate(img: imgMain, name: name, time: time, description: description, infoPage: info, inscripcionPage: insc, largadaImg: imgLargada);
    CarreraCard card = CarreraCard(description: cardDescription, pageLink: page, distances: distances, type: type);
    MiCarreraCard miCard = MiCarreraCard(pageLink: page, logo: logo);

    carreraCardsList.add(card);
    misCarrerasCards.add(miCard);
  }

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

Widget prevPage = InitialPage();
CarreraTemplate? carreraPage;

const backgroundImage = "assets/medio-ambiente.jpg";

// final List<CarreraCard> carreraCardsList = [
//   carreraMayaCard,
//   carreraMayaCard1,
//   carreraMayaCard2,
//   carreraMayaCard3,
//   carreraMayaCard4,
//   carreraMayaCard5,
//   carreraMayaCard6,
// ];

// final List<MiCarreraCard> misCarrerasCards = [
//   miCarreraMayaCard,
//   miCarreraMayaCard,
//   miCarreraMayaCard
// ];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Club de Corredores',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(227, 22, 24, 1), primary: const Color.fromRGBO(227, 22, 24, 1)),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Widget page = InitialPage();

  void setPage(Widget p) {
    page = p;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var page = appState.page;
    var colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
      ),
      child: Column(
        children: [
          Expanded(child: page),

          SizedBox(
            height: 80,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 30,
              currentIndex: index,
              backgroundColor: Colors.black,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: true,
              selectedFontSize: 12,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
            
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: "Perfil",
                ),
                  
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: "Alertas",
                ),
                  
                BottomNavigationBarItem(
                  icon: Icon(Icons.message_rounded),
                  label: "Chats",
                ),
                  
                BottomNavigationBarItem(
                  icon: Icon(Icons.help),
                  label: "Ayuda",
                ),
              ],
                  
              onTap: (value) {
                setState(() {
                  index = value;
                });
            
                switch (value) {
                  case 0:
                    appState.setPage(InitialPage());
                  case 1:
                    appState.setPage(Login(directTo: "perfil",));
                  case 2: 
                    appState.setPage(NotificacionesPage());
                  case 3:
                    appState.setPage(MensajesPage());
                  case 4:
                    appState.setPage(AyudaPage());
                  default:
                    throw UnimplementedError('no widget for $value');
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class NotificacionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("Notificaciones", style: Theme.of(context).textTheme.displaySmall!,));
  }
}

class MensajesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("Mensajes", style: Theme.of(context).textTheme.displaySmall!,));
  }
}

class AyudaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Text("Ayuda", style: Theme.of(context).textTheme.displaySmall!,));
  }
}
