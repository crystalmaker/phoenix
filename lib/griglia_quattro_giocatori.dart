import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pagina_principale.dart';
import 'dart:math';
import 'widget_quattro_giocatori.dart'; // Importa il widget CounterWidget
import 'arrow_overlay.dart'; // Importa la tua classe

// Schermata con la griglia dei contatori
class GrigliaQuattro extends StatefulWidget {
  const GrigliaQuattro({super.key});

  @override
  GrigliaQuattroState createState() => GrigliaQuattroState();
}

class GrigliaQuattroState extends State<GrigliaQuattro> {
  late List<(Color, String)> colori;

  @override
  void initState() {
    super.initState();

    // Crea una lista di 3 colori
    colori = [
      (const Color.fromARGB(200, 246, 43, 43), 'assets/rosso.png'),
      (const Color.fromARGB(200, 44, 246, 44), 'assets/verde.png'),
      (const Color.fromARGB(200, 28, 105, 246), 'assets/blu.png'),
      (const Color.fromARGB(200, 248, 248, 47), 'assets/giallo.png'),
    ];

    colori.shuffle(rand);

    Future.delayed(const Duration(seconds: 1), () {
    if (!mounted) return;

    ArrowOverlay(context, 4).show();
    // Mostra l'overlay dopo 1 secondo
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nasconde la barra di stato
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);


    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          // Immagine di sfondo
          Positioned.fill(
            child: Image.asset(
              'assets/sfondonero.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Prima colonna (sinistra)
          Positioned(
            left: -2,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                // Sezione in alto a sinistra
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Transform.rotate(
                      angle: pi,
                      child: CounterWidget(
                        randomColor: colori[0].$1,
                        sfondo: colori[0].$2,
                        gameover: 'assets/gameover2.png',
                        boxLeft: 270,
                        boxTop: 98,
                      ),
                    ),
                  ),
                ),

                // Sezione in basso a sinistra
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Transform.rotate(
                      angle: 0,
                      child: CounterWidget(
                        randomColor: colori[1].$1,
                        sfondo: colori[1].$2,
                        gameover: 'assets/gameover2.png',
                        boxLeft: 270,
                        boxTop: 98,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Seconda colonna (destra spostata a sinistra di 10 pixel)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 8,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                // Sezione in alto a destra
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Transform.rotate(
                      angle: pi,
                      child: CounterWidget(
                        randomColor: colori[2].$1,
                        sfondo: colori[2].$2,
                        gameover: 'assets/gameover2.png',
                        boxLeft: 270,
                        boxTop: 98,
                      ),
                    ),
                  ),
                ),

                // Sezione in basso a destra
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Transform.rotate(
                      angle: 0,
                      child: CounterWidget(
                        randomColor: colori[3].$1,
                        sfondo: colori[3].$2,
                        gameover: 'assets/gameover2.png',
                        boxLeft: 270,
                        boxTop: 98,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

