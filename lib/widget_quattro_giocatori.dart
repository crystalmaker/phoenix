import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/registro_eventi.dart';
import 'pulsanti_commander.dart';
import 'image_button.dart';

class CounterWidget extends StatefulWidget {
  final Color randomColor;
  final String sfondo;
  final String gameover;
  final double boxLeft;
  final double boxTop;
  const CounterWidget({
    super.key,
    required this.randomColor,
    required this.sfondo,
    required this.gameover,
    required this.boxLeft,
    required this.boxTop,
  });

  @override
  CounterWidgetState createState() => CounterWidgetState();
}

class CounterWidgetState extends State<CounterWidget> {
  Timer? _timer; // Riferimento al Timer
  int totale = 40; // Valore iniziale del contatore
  int contatore = 0; // Contatore per il corretto posizionamento dei pulsanti
  bool gameLost = false;

  // Variabili per tenere il conto dei click
  int sommaClick = 0;
  Timer? _clickTimer;
  bool mostraSommaClick = false;

  // Stati dei pulsanti - elenco per il log
  List<bool> statiPulsanti = [false, false, false, false]; // Aggiungi più booleani se necessario
  List<int> danniComandante = [0, 0, 0, 0];
  List<Widget> buttons = [];
  List<String> eventi = [];

  // Fa partire il timer della partita
  DateTime inizioPartita = DateTime.now();

  String tempoPartita() {

    final durata = DateTime.now().difference(inizioPartita);
    final ore = durata.inHours;
    final minuti = durata.inMinutes.remainder(60);
    final secondi = durata.inSeconds.remainder(60);

    return "${ore.toString().padLeft(2, '0')}:"
        "${minuti.toString().padLeft(2, '0')}:"
        "${secondi.toString().padLeft(2, '0')}";
  }

  String oraFormattata() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";
  }

  void aggiungiLog(String testo) {
    setState(() {
      eventi.insert(0,
          "${oraFormattata()} - $testo"
      );
    });
  }

  void _registraClick(int valore) {
    setState(() {
      sommaClick += valore;
      mostraSommaClick = true;
    });

    // Ogni nuovo click azzera il conto alla rovescia
    _clickTimer?.cancel();

    _clickTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          mostraSommaClick = false;
          sommaClick = 0;
        });
      }
    });
  }

  // MODIFICA DEI PUNTI VITA
  void _modificaTotale(int quantita) {
    // setState() comunica a Flutter che abbiamo modificato dei dati utilizzati dalla schermata e quindi la schermata deve essere ridisegnata.
    setState(() {

      // Cerca il comandante selezionato (0, 1, 2), se esiste, se no restituisce -1
      int indiceComandante = statiPulsanti.indexWhere((stato) => stato);

      // Salva i punti vita prima della modifica
      int oldTotale = totale;

      // Aggiunge / sottrae la quantità passata come parametro
      totale += quantita;

      // I punti vita non possono scendere sotto zero
      if (totale <= 0) {
        totale = 0;

        // Scriviamo anche un messaggio specifico nel log.
        aggiungiLog("I punti vita sono scesi a zero.");
      }

      // Crea la finestrella della somma dei pv guadagnati o persi
      _registraClick(quantita);

      // Crea il log per la modifica effettuata
      aggiungiLog(
        "     ${quantita > 0 ? '+' : ''}$quantita "
            "${quantita.abs() == 1 ? 'punto' : 'punti'} vita     "
            "$oldTotale --> $totale",
      );

      // Check della selezione di un comandante
      if (indiceComandante == -1) {
        return;
      }

      // Salva i danni da comandante prima della modifica
      int oldDanni = danniComandante[indiceComandante];

      // Caso in cui si sta guadagnando vita
      if (quantita > 0) {

        // Ci sono danni da rimuovere?
        if (oldDanni >= quantita) {

          danniComandante[indiceComandante] -= quantita;

          // Salviamo il nuovo valore dopo la modifica.
          int newDanni = danniComandante[indiceComandante];
          // Crea il log dell'evento
          aggiungiLog(
            "     -${quantita.abs()} "
                "${quantita.abs() == 1 ? 'danno' : 'danni'} da Comandante     "
                "$oldDanni --> $newDanni",
          );
        }
      }

      // Caso in cui si sta perdendo vita
      else {

        danniComandante[indiceComandante] += quantita.abs();

        // Salva il nuovo valore dopo la modifica.
        int newDanni = danniComandante[indiceComandante];

        // Crea il log dell'evento
        aggiungiLog(
          "     +${quantita.abs()} "
              "${quantita.abs() == 1 ? 'danno' : 'danni'} da Comandante     "
              "$oldDanni --> $newDanni",
        );
      }
    });

    aggiornamenti();
  }

  void _incrementByOne() {
    _modificaTotale(1);
  }

  void _incrementByFive() {
    _modificaTotale(5);
  }

  void _decrementByOne() {
    _modificaTotale(-1);
  }

  void _decrementByFive() {
    _modificaTotale(-5);
  }

  void _pos(double interasse, double ampiezza, double spessore, double diametro, int contatore, String number, String initialImage, String onImage) {
    buttons.add(
      Stack(
        children: [
          // Contenitore di pulsante e punteggio
          Positioned(
            bottom: 16,
            left: 20 + (contatore * interasse),
            child: Container(
              width: ampiezza,
              height: spessore,
              decoration: BoxDecoration(
                color: const Color.fromARGB(180, 164, 178, 181),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 21,
            left: 28 + diametro + (contatore * interasse),
            child: Container(
              width: ampiezza - diametro - 12,
              height: spessore - 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(240, 225, 225, 225),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -7,
                    left: 14,
                    child: Text(
                      danniComandante[contatore].toString(), // Mostra il numero passato alla funzione
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: diametro - 4,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 21,
            left: 12 + (contatore * interasse),
            height: diametro,
            width: diametro * 3.8, // Allargo il diametro per rendere cliccabile un'area maggiore
            child: GestureDetector(
              onTap: () => _toggleButton(contatore),
              behavior: HitTestBehavior.translucent, // Rende cliccabile anche l'area trasparente
              child: Align(
                alignment: Alignment.centerLeft, // Mantiene il pulsante a sinistra e l'area cliccabile a destra
                child: LightButton(
                  initialImage: initialImage,
                  onImage: onImage,
                  isIlluminated: statiPulsanti[contatore],
                  onPressed: () => _toggleButton(contatore),
                  text: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleButton(int index) {
    setState(() {
      statiPulsanti[index] = !statiPulsanti[index];
      if(index != 0) statiPulsanti[0] = false;
      if(index != 1) statiPulsanti[1] = false;
      if(index != 2) statiPulsanti[2] = false;
    });

  }

  void aggiornamenti() {
    // Aggiungi il controllo se i danni hanno mandato KO il giocatore
    if (totale < 1 || danniComandante[0] > 20 || danniComandante[1] > 20 || danniComandante[2] > 20) {
      // Avvia un nuovo timer di 5 secondi
      _timer?.cancel(); // Cancella un eventuale timer esistente
      _timer = Timer(const Duration(seconds: 5), () {
        if (totale < 1 || danniComandante[0] > 20 || danniComandante[1] > 20 || danniComandante[2] > 20) {
          setState(() {
            gameLost = true;
          });
        } else {
          // Reset del conteggio, annulla il timer
          _timer?.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _clickTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    buttons = []; // Reset della lista buttons ogni volta che build viene chiamato.
    double altezza = size.height;
    double larghezza = size.width;
    double ampiezza = larghezza / 7;
    double spessore = altezza / 8.7;
    double interasse = ampiezza + 8;
    double diametro = altezza / 10.72;
    const double fontsizeButton1 = 32;
    const double fontsizeButton2 = 28;
    contatore = 0;

    // Controlla per il primo pulsante
    if (widget.randomColor != const Color.fromARGB(200, 246, 43, 43)) {
      _pos(
          interasse,
          ampiezza,
          spessore,
          diametro,
          contatore,
          buttons.length.toString(),
          'assets/rosso_s.png',
          'assets/rosso_a.png');
      contatore++;
    }

    // Controlla per il secondo pulsante
    if (widget.randomColor != const Color.fromARGB(200, 248, 248, 47)) {
      _pos(
          interasse,
          ampiezza,
          spessore,
          diametro,
          contatore,
          buttons.length.toString(),
          'assets/giallo_s.png',
          'assets/giallo_a.png');
      contatore++;
    }

    // Controlla per il terzo pulsante
    if (widget.randomColor != const Color.fromARGB(200, 44, 246, 44)) {
      _pos(
          interasse,
          ampiezza,
          spessore,
          diametro,
          contatore,
          buttons.length.toString(),
          'assets/verde_s.png',
          'assets/verde_a.png');
      contatore++;
    }

    // Controlla per il quarto pulsante
    if (widget.randomColor != const Color.fromARGB(200, 28, 105, 246)) {
      _pos(
          interasse,
          ampiezza,
          spessore,
          diametro,
          contatore,
          buttons.length.toString(),
          'assets/blu_s.png',
          'assets/blu_a.png');
    }


    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Arrotonda i bordi
            side: BorderSide(
              color: widget.randomColor, // Colore del bordo
              width: 6, // Larghezza del bordo
            ),
          ),

          margin: const EdgeInsets.all(6.0), // Margine attorno alla card

          // `Stack` per lo sfondo
          child: Stack(
            children: [
              // Immagine di sfondo, ruotata o meno di 180 gradi
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Arrotonda i bordi come la card
                child: Image.asset(
                  widget.sfondo, // Il percorso dell'immagine PNG
                  fit: BoxFit.cover, // Adatta l'immagine alle dimensioni della card
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0), // Padding interno alla card
                child: Stack(
                  children: [
                    // Posizionamento del testo centrato
                    Positioned.fill(
                      top: -5,
                      child: Align(
                        alignment: Alignment.topCenter, // Allinea al centro
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Text(  //PUNTEGGIO
                              '$totale', // Testo riempito di grigio
                              style: TextStyle(
                                fontSize: altezza / (4.0 + (totale / 240)),
                                fontFamily: 'Ravie',
                                color: const Color.fromARGB(150, 70, 70, 70),
                              ),
                            ),
                            Text(
                              '$totale',
                              style: TextStyle(
                                fontSize: altezza / (4.0 + (totale / 240)),
                                fontFamily: 'Ravie',

                                // Ombra
                                shadows: [
                                  Shadow(
                                    offset: const Offset(4, 4),
                                    blurRadius: 5,
                                    color: Colors.black.withValues(alpha: 0.7),
                                  ),
                                ],

                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = const Color.fromARGB(255, 230, 230, 230),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Posizionamento del pulsante -1
                    Positioned(
                      top: 10,
                      left: 20,
                      child: ImageButton(
                        image: 'assets/pulsante.png',
                        text: '-1',
                        width: altezza / 7.8,
                        height: altezza / 7.8,
                        onPressed: () {
                          _decrementByOne();
                        },
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: fontsizeButton1,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    // Posizionamento del pulsante -5
                    Positioned(
                      top: altezza / 5.5,
                      left: 30,
                      child: ImageButton(
                        image: 'assets/pulsante.png',
                        text: '-5',
                        width: altezza / 8.5,
                        height: altezza / 8.5,
                        onPressed: () {
                          _decrementByFive();
                        },
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: fontsizeButton2,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    // Posizionamento del pulsante +1
                    Positioned(
                      top: 10,
                      right: 20,
                      child: ImageButton(
                        image: 'assets/pulsante.png',
                        text: '+1',
                        width: altezza / 7.8,
                        height: altezza / 7.8,
                        onPressed: () {
                          _incrementByOne();
                        },
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: fontsizeButton1,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    // Posizionamento del pulsante +5
                    Positioned(
                      top: altezza / 5.5,
                      right: 30,
                      child: ImageButton(
                        image: 'assets/pulsante.png',
                        text: '+5',
                        width: altezza / 8.5,
                        height: altezza / 8.5,
                        onPressed: () {
                          _incrementByFive();
                        },
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: fontsizeButton2,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Aggiungi i pulsanti dei danni da comandante
        ...buttons,
        // Mostra il totale raggiunto dai click
        if (mostraSommaClick)
          Positioned(
            left: widget.boxLeft,
            top: widget.boxTop,
            child: IgnorePointer(
              child: Container(
                width: larghezza * 0.07,
                height: altezza * 0.08,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color.fromARGB(
                        250, 235, 235, 235),
                    width: 3,
                  ),
                ),
                child: Text(
                  sommaClick >= 0 ? '+$sommaClick' : '$sommaClick',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: altezza / 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
          ),
        // Aggiungo la scritta Game Over se vengono rispettate le condizioni per farla apparire
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Arrotonda i bordi come la card
          child: gameLost ? Image.asset(
            widget.gameover, // Il percorso dell'immagine PNG
            fit: BoxFit.cover, // Adatta l'immagine alle dimensioni della card
            width: double.infinity,
            height: double.infinity,
          ) :Container(),
        ),
        // Pulsante che fa apparire il log del giocatore
        Positioned.fill(
          top: 18,
          child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: true,
                      barrierColor: Colors.transparent,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return RegistroEventi(
                          eventi: eventi,
                          tempo: tempoPartita(),
                        );
                      },
                    ),
                  );
                },
                child: SizedBox(
                  width: altezza / 2.5,
                  height: altezza / 4,
                ),
              )
          ),
        ),
      ],
    );
  }
}