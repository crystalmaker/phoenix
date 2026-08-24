import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pagina_principale.dart';
import 'dart:math';
import 'widget_tre_giocatori.dart'; // Importa il widget CounterWidget
import 'arrow_overlay.dart'; // Importa la tua classe

// Schermata con la griglia dei contatori
class GrigliaTre extends StatefulWidget {
  const GrigliaTre({super.key});

  @override
  GrigliaTreState createState() => GrigliaTreState();
}

class GrigliaTreState extends State<GrigliaTre> {
  late List<(Color, String)> colori;

  @override
  void initState() {
    super.initState();

    // Crea una lista di 3 colori
    colori = [
      (const Color.fromARGB(200, 246, 43, 43), 'assets/rosso.png'),
      (const Color.fromARGB(200, 44, 246, 44), 'assets/verde.png'),
      (const Color.fromARGB(200, 248, 248, 47), 'assets/giallo.png'),
    ];

    // Mescolo i colori nell'array
    colori.shuffle(rand);

    // Mostra l'overlay dopo 1 secondo
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      ArrowOverlay(context, 3).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nasconde la barra di stato
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final size = MediaQuery
        .of(context)
        .size;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Immagine di sfondo al di sotto delle 4 parti
          Positioned.fill(
            child: Image.asset(
              'assets/sfondonero.jpg', // Percorso dell'immagine
              fit: BoxFit.cover, // L'immagine copre tutto lo schermo
            ),
          ),
          Positioned(
            left: 0, // Posizione orizzontale (in pixel)
            bottom: size.height / 2, // Posizione verticale (in pixel)
            child: Container(
              width: (size.width / 1.8),
              height: (size.height / 2) - 4,
              color: Colors.transparent,
              child: Transform.rotate(
                  angle: pi, // Rotazione di 90 gradi
                  child: CounterWidget(randomColor: colori[0].$1, sfondo: colori[0].$2, gameover: 'assets/gameover3.png',   boxLeft: 300,
                    boxTop: 120,)),
            ), // Contatore in alto a sinistra
          ),
          // Sezione in alto a destra
          Positioned(
            left: 0, // Posizione orizzontale (in pixel)
            top: size.height / 2, // Posizione verticale (in pixel)
            child: Container(
              width: (size.width / 1.8),
              height: (size.height / 2) - 4,
              color: Colors.transparent,
              child: Transform.rotate(
                  angle: 0, // Rotazione di 90 gradi
                  child: CounterWidget(randomColor: colori[1].$1, sfondo: colori[1].$2, gameover: 'assets/gameover3.png',   boxLeft: 300,
                    boxTop: 120,)),
            ), // Contatore in alto a sinistra
          ),
          // Sezione singola di destra
          Align(
            alignment: const Alignment(0.99, 0), // Posiziona il secondo testo sotto il primo
            //alignment: Alignment.centerRight,
            child: SizedBox(
              width: size.height * 0.98,
              height: (size.width - (size.width / 1.7)),
              child: Transform.rotate(
                angle: -pi / 2, // Rotazione di 90 gradi
                  child: CounterWidget(randomColor: colori[2].$1, sfondo: colori[2].$2, gameover: 'assets/gameover4.png',   boxLeft: 210,
                    boxTop: 130,)),
            ),
          ),
        ]
      ),
    );
  }
}
