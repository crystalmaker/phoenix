import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ArrowOverlay {
  final BuildContext context;
  OverlayEntry? overlayEntry; // Variabile di istanza per l'OverlayEntry
  ArrowOverlay(this.context, this.number);

  // Crea un'istanza della classe Random
  int number;

  // Funzione per mostrare l'overlay con l'immagine
  void show() {
    // Genera un numero casuale tra 0 e 4 per capire chi inizia
    Random rand = Random();
    int randomNumber = rand.nextInt(number);
    double angolo = 0.0;
    String img = "";

    if (number > 2)
    {
      if (randomNumber == 1) angolo = pi / 2;
      if (randomNumber == 2) angolo = pi;
      if (randomNumber == 3) angolo = 3 * pi / 2;

      // Genera un numero casuale tra 0 e 1 per capire l'ordine dei giocatori
      randomNumber = rand.nextInt(2);
      if (randomNumber == 0) img = 'assets/frecce.png';
      if (randomNumber == 1) img = 'assets/frecce_rot.png';
    }
    else
    {
      if (randomNumber == 1) angolo = pi;
      img = 'assets/freccia.png';
    }

    // Crea un OverlayEntry
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            // Rimuovi l'overlay quando viene toccato
            remove(); // Chiama il metodo remove
          },
          child: Container(
            color: Colors.black.withValues(alpha: 0.80), // Sfondo semi-trasparente
            child: Transform.rotate(
              angle: angolo,
              child: Center(
                child: Image.asset(
                  img, // Percorso dell'immagine
                  width: 300, // Larghezza dell'immagine
                  height: 300, // Altezza dell'immagine
                  isAntiAlias: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Aggiungi l'overlay all'albero dei widget
    Overlay.of(context).insert(overlayEntry!);

    // Dopo 2 secondi, rimuovi l'overlay se non è stato toccato
    Timer(const Duration(seconds: 20), () {
      remove(); // Chiama il metodo remove
    });
  }

  // Funzione per rimuovere l'overlay
  void remove() {
    if (overlayEntry != null && overlayEntry!.mounted) {
      overlayEntry!.remove();
    }
  }
}
