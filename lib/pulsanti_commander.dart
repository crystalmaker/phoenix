import 'package:flutter/material.dart';

class LightButton extends StatelessWidget {
  final String initialImage; // Immagine iniziale (spento, rosso, ecc.)
  final String onImage; // Immagine per lo stato acceso
  final bool isIlluminated; // Stato del pulsante
  final VoidCallback onPressed; // Callback per il pulsante
  final String text;

  const LightButton({
    super.key,
    required this.initialImage, // Richiede un'immagine iniziale
    required this.onImage, // Richiede un'immagine per lo stato acceso
    required this.isIlluminated, // Stato del pulsante
    required this.onPressed, // Callback per il pulsante
    required this.text, // Callback per il pulsante
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Usa il callback passato
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Rimuove il padding
        elevation: 0, // Rimuove l'elevazione per evitare ombre attorno
        backgroundColor: Colors.transparent, // Sfondo trasparente per rimuovere il bordo
        shadowColor: Colors.transparent, // Rimuove il colore dell'ombra
      ),
      child: Stack(
        alignment: Alignment.center, // Centra il testo sopra l'immagine
        children: [
          isIlluminated
              ? Image.asset(onImage) // Immagine per lo stato acceso
              : Image.asset(initialImage), // Immagine per lo stato spento o rosso
          Text(
            text, // Testo da visualizzare
            style: const TextStyle(
              color: Colors.black, // Colore del testo
              fontSize: 18, // Dimensione del testo
              fontWeight: FontWeight.bold, // Stile del testo
              fontFamily: 'Arial', // Aggiunto per compatibilità Web
            ),
          ),
        ],
      ),
    );
  }
}
