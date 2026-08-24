import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pagina_principale.dart';
import 'dart:math';
import 'widget_due_giocatori.dart'; // Importa il widget CounterWidget
import 'arrow_overlay.dart'; // Importa la tua classe

// Schermata con la griglia dei contatori
class GrigliaDue extends StatefulWidget {
  const GrigliaDue({super.key});

  @override
  GrigliaDueState createState() => GrigliaDueState();
}

class GrigliaDueState extends State<GrigliaDue> {
  late List<(Color, String)> colori;

  @override
  void initState() {
    super.initState();

    // Crea una lista di 2 colori
    colori = [
      (const Color.fromARGB(200, 246, 43, 43), 'assets/rosso.png'),
      (const Color.fromARGB(200, 44, 246, 44), 'assets/verde.png'),
    ];

    // Mescolo i colori nell'array
    colori.shuffle(rand);

    // Mostra l'overlay dopo 1 secondo
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      ArrowOverlay(context, 2).show();
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

          // Sezione di sinistra
          Align(
            alignment: const Alignment(-0.99, 0), // Posiziona il secondo testo sotto il primo
            child: SizedBox(
              width: size.height * 0.98,
              height: (size.width - (size.width / 1.75)),
              child: Transform.rotate(
                angle: pi, // Rotazione di 90 gradi
                child: CounterWidget(randomColor: colori[0].$1, sfondo: colori[0].$2, gameover: 'assets/gameover4.png',   boxLeft: 220,
                  boxTop: 120)),
              ),
            ),
          // Sezione di destra
          Align(
            alignment: const Alignment(0.95, 0), // Posiziona il secondo testo sotto il primo
            child: SizedBox(
              width: size.height * 0.98,
              height: (size.width - (size.width / 1.75)),
              child: Transform.rotate(
                angle: 0, // Rotazione di 90 gradi
                child: CounterWidget(randomColor: colori[1].$1, sfondo: colori[1].$2, gameover: 'assets/gameover4.png',   boxLeft: 220,
                  boxTop: 120)),
            ),
          ),
        ],
      ),
    );
  }
}
