import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'griglia_due_giocatori.dart';
import 'griglia_tre_giocatori.dart';
import 'griglia_quattro_giocatori.dart';
import 'pulsanti_commander.dart';
import 'griglia_tavoli.dart';

// Mappa per tenere traccia di istanze di diversi tipi
final Map<String, Widget> istanze = {};
late int numeroTavoli;
late String periodo;
late List<List<int>> matricePlayer;
late List<List<String>> matriceAbbinamenti;
late List<List<String>> matriceAbbinamentiMemoria;
late List<int> matriceTavoli;
bool grigliaSalvata = false;
Random rand = Random();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  late List<String> gifImages;
  late double gifHeight;
  late double gifWidth;
  late double gifPosX;
  late double gifPosY;
  late String sfondo_1;
  late String sfondo_2;
  List<bool> statiPulsanti = [true, false, false]; // Aggiungi più booleani se necessario
  late int numeroGiocatori;
  final TextEditingController controller = TextEditingController();
  bool mostraSfondo2 = false;


  // Resetta gli altri pulsandi dei danni da comandante quando ne viene premuto uno
  void _toggleButton(int index) {
    setState(() {
      statiPulsanti[index] = !statiPulsanti[index];
      if(index != 0) statiPulsanti[0] = false;
      if(index != 1) statiPulsanti[1] = false;
      if(index != 2) statiPulsanti[2] = false;
    });
  }

  // Elimina l'istanza della griglia di combinazioni da torneo
  void _resetGriglia(String stringa) {
    setState(() {
      if (stringa == "griglia") {
        grigliaSalvata = false;
        istanze.remove('griglia');
        controller.clear();
      }
    });
  }

  void _avviaAnimazioneSfondo() async {

    while (mounted) {
      // Numero casuale tra 3 e 6 secondi
      final secondi = 3 + rand.nextInt(4);

      // Aspetta l'intervallo casuale
      await Future.delayed(Duration(seconds: secondi));

      if (!mounted) return;

      // Mostra sfondo2
      setState(() {
        mostraSfondo2 = true;
      });

      // Numero casuale di millisecondi di ammicco
      final millisecondi = 300 + rand.nextInt(600);

      // Rimane visibile per 1 secondo
      await Future.delayed(Duration(milliseconds: millisecondi));

      if (!mounted) return;

      // Torna a sfondo normale
      setState(() {
        mostraSfondo2 = false;
      });
    }
  }

  String calcolaPeriodo() {
    final oggi = DateTime.now();
    final giorno = oggi.day;
    final mese = oggi.month;

    // Tema Befana: Per tutto gennaio
    if (mese == 1 && giorno >= 1) {
      return "befana";
    }

    // Tema Primavera: Dal 1 aprile al 31 maggio
    if ((mese == 4 && giorno >= 1) || (mese == 5 && giorno <= 31)) {
      return "primavera";
    }

    // Tema Autunno: Dal 15 settembre al 14 ottobre
    if ((mese == 9 && giorno >= 15) || (mese == 10 && giorno <= 14)) {
      return "autunno";
    }

    // Tema Halloween: Dal 15 ottobre al 15 novembre
    if ((mese == 10 && giorno >= 15) || (mese == 11 && giorno <= 15)) {
      return "halloween";
    }

    // Tema Natale: Dal 15 dicembre al 31 dicembre
    if (mese == 12 && giorno >= 15) {
      return "natale";
    }

    // Negli altri periodi
    return "normale";
  }

  void aggiornaGrafica() {
    periodo = calcolaPeriodo();
    gifImages = [
      'assets/gif/fiamma1.png',
      'assets/gif/fiamma2.png',
      'assets/gif/fiamma3.png',
      'assets/gif/fiamma4.png',
      'assets/gif/fiamma5.png',
      'assets/gif/fiamma6.png',
      'assets/gif/fiamma7.png',
      'assets/gif/fiamma8.png',
      'assets/gif/fiamma9.png',
      'assets/gif/fiamma10.png',
      'assets/gif/fiamma11.png',
      'assets/gif/fiamma12.png',
      'assets/gif/fiamma13.png',
    ];
    if (periodo == "normale") {
      sfondo_1 = "assets/sfondo.png";
      sfondo_2 = "assets/sfondo2.png";
      gifHeight = 70;
      gifWidth = 30;
      // Gif normale con fiamma
    }
    else if (periodo == "primavera") {
      sfondo_1 = "assets/sfondo_primavera.png";
      sfondo_2 = "assets/sfondo_primavera2.png";
      gifHeight = 70;
      gifWidth = 30;
      // Gif normale con fiamma
    }
    else if (periodo == "autunno") {
      sfondo_1 = "assets/sfondo_autunno.png";
      sfondo_2 = "assets/sfondo_autunno2.png";
      gifHeight = 70;
      gifWidth = 30;
      // Gif normale con fiamma
    }
    else if (periodo == "halooween") {
      sfondo_1 = "assets/sfondo_halloween.png";
      sfondo_2 = "assets/sfondo_halloween2.png";
      gifHeight = 100;
      gifWidth = 100;
      gifImages = [
        'assets/gif/zucca1.png',
        'assets/gif/zucca2.png',
        'assets/gif/zucca3.png',
        'assets/gif/zucca4.png',
        'assets/gif/zucca5.png',
        'assets/gif/zucca6.png',
        'assets/gif/zucca7.png',
        'assets/gif/zucca8.png',
        'assets/gif/zucca9.png',
        'assets/gif/zucca10.png',
        'assets/gif/zucca11.png',
        'assets/gif/zucca12.png',
      ];
    }
    else if (periodo == "natale") {
      sfondo_1 = "assets/sfondo_natale.png";
      sfondo_2 = "assets/sfondo_natale2.png";
      gifHeight = 70;
      gifWidth = 30;
      // Gif normale con fiamma
    }
    else if (periodo == "befana") {
      sfondo_1 = "assets/sfondo_befana.png";
      sfondo_2 = "assets/sfondo_befana2.png";
      gifHeight = 100;
      gifWidth = 100;
      gifImages = [
        'assets/gif/pipistrello1.png',
        'assets/gif/pipistrello2.png',
        'assets/gif/pipistrello3.png',
        'assets/gif/pipistrello4.png',
        'assets/gif/pipistrello5.png',
        'assets/gif/pipistrello6.png',
        'assets/gif/pipistrello7.png',
        'assets/gif/pipistrello8.png',
        'assets/gif/pipistrello7.png',
        'assets/gif/pipistrello6.png',
        'assets/gif/pipistrello5.png',
        'assets/gif/pipistrello4.png',
        'assets/gif/pipistrello3.png',
        'assets/gif/pipistrello2.png',
        'assets/gif/pipistrello1.png',
        'assets/gif/pipistrello2.png',
        'assets/gif/pipistrello3.png',
        'assets/gif/pipistrello4.png',
        'assets/gif/pipistrello5.png',
        'assets/gif/pipistrello6.png',
        'assets/gif/pipistrello7.png',
        'assets/gif/pipistrello8.png',
        'assets/gif/pipistrello7.png',
        'assets/gif/pipistrello6.png',
        'assets/gif/pipistrello5.png',
        'assets/gif/pipistrello4.png',
        'assets/gif/pipistrello3.png',
        'assets/gif/pipistrello2.png',
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    // Nasconde la barra di stato
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Crea il controller dell'animazione della fiammella

    aggiornaGrafica();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Durata dell'animazione
    )..repeat(); // Ripete l'animazione
    _animation = IntTween(begin: 0, end: gifImages.length - 1).animate(_controller);

    _avviaAnimazioneSfondo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-carica tutte le immagini della sequenza per evitare lo sfarfallio iniziale
    for (String imagePath in gifImages) {
      precacheImage(AssetImage(imagePath), context);
    }
    // Pre-carica anche gli sfondi
    precacheImage(AssetImage(sfondo_1), context);
    precacheImage(AssetImage(sfondo_2), context);
  }

  @override
  Widget build(BuildContext context) {
    // Ottiene le dimensioni dello schermo
    final size = MediaQuery.of(context).size;
    gifPosY = 5 - gifHeight + (85 * (size.height / 411.428));
    gifPosX = -(gifWidth/2) + (40 * (size.width / 866.285));

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              sfondo_1,
              fit: BoxFit.fill,
            ),
          ),

          Positioned.fill(
              child: Opacity(
                opacity: mostraSfondo2 ? 1.0 : 0.0, //Se mostrasfondo2 è true mette opacità allo sfondo a 1.0
                child: Image.asset(
                  sfondo_2,
                  fit: BoxFit.fill,
                ),
              )
          ),

          // Animazione della fiammella sovrapposta allo sfondo
          Positioned(
            top: gifPosY, // Posizionamento dall'alto
            left: gifPosX,
            child: Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.75, // Imposta l'opacità al 75%
                    child: Image.asset(
                      gifImages[_animation.value], // Mostra l'immagine corrente dell'animazione
                      width: gifWidth, // Dimensioni dell'animazione
                      height: gifHeight,
                      isAntiAlias: true,
                      gaplessPlayback: true, // Mantiene il frame precedente finché il nuovo non è pronto
                    ),
                  );
                },
              ),
            ),
          ),

          // Contenitore di numero dei giocatori, scritte e pulsanti
          Positioned(
            top: 40,
            right: 6,
            child: Container(
              width: size.width / 4,
              height: size.height / 2.6,
              decoration: BoxDecoration(
                color: const Color.fromARGB(122, 40, 224, 208),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              //Testo Giocatori
              child: Center(
                child: Stack(
                  children: [
                    // Pulsante di Reset Griglia Giocatori
                    Align(
                      alignment: const Alignment(0.92, 0.70), // Posiziona il pulsante per partita a 4 giocatori
                      child: grigliaSalvata ? SizedBox(
                        width: 40,
                        height: 40,
                        child: LightButton(
                          initialImage: "assets/reset_s.png",
                          onImage: "assets/reset_a.png",
                          isIlluminated: !grigliaSalvata,
                          onPressed: () => _resetGriglia("griglia"),
                          text: '',
                        ),
                      ) :Container(),
                    ),
                    //Testo Genera Tavoli
                    Align(
                      alignment: const Alignment(0, -0.95), // Posiziona il primo testo leggermente sopra il centro
                      child: Text(
                        "GENERA TAVOLI",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: size.width / 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Pulsante "Genera tavoli" posizionato in basso al centro
                    Align(
                      alignment: const Alignment(0, 0.85), // Posiziona il secondo testo sotto il primo
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            fontFamily: 'Arial', // Specifica il font per il Web
                          ),
                          foregroundColor: Colors.yellow, // Colore del testo
                          backgroundColor: Colors.purple, // Colore di sfondo
                          side: const BorderSide(
                            color: Color.fromARGB(200, 60, 60, 60),
                            width: 3.0,          // Spessore del bordo
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Arrotondamento del bordo
                          ),
                        ),
                        onPressed: () {
                          if (numeroGiocatori > 5) {
                            // Gestisce Istanza di GrigliaTavoli
                            if (!istanze.containsKey('griglia')) {
                              istanze['griglia'] = GrigliaTavoli(numeroGiocatori: numeroGiocatori);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => istanze['griglia']!),
                            );
                          }
                        },
                        child: Text(grigliaSalvata ? 'Tavoli' : 'Genera'), // Testo del pulsante che cambia in base a grigliaSalvata
                      ),
                    ),

                    // Casella di testo per inserire manualmente il numero dei giocatori per la generazione dei tavoli
                    Align(
                      alignment: const Alignment(-0.9, -0.15),
                      child: SizedBox(
                        width: 55,
                        height: 40,
                        child: TextField(
                          controller: controller,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                            hintText: '',
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Arial',
                          ),
                          onChanged: (value) {
                            setState(() {
                              numeroGiocatori = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ),

                    // Testo "n° Giocatori" a fianco della casella
                    Align(
                      alignment: const Alignment(0.7, -0.15), // Posiziona il primo testo leggermente sopra il centro
                      child: Text(
                        "n° Giocatori",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: size.width / 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenitore della creazione dei tavoli in base al numero di giocatori
          Positioned(
            top: 58 + size.height / 2.6,
            right: 6,
            child: Container(
              width: size.width / 4,
              height: size.height / 2.6,
              decoration: BoxDecoration(
                color: const Color.fromARGB(122, 40, 224, 208),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),

              child: Center(
                child: Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0, -1.06), // Posiziona il primo testo leggermente sopra il centro
                      child: Text(
                        "PARTITA",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: size.width / 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Pulsante "Gioca" posizionato in basso al centro
                    Align(
                      alignment: const Alignment(0, 0.85), // Posiziona il secondo testo sotto il primo
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                            fontFamily: 'Arial', // Specifica il font per il Web
                          ),
                          foregroundColor: Colors.yellow, // Colore del testo
                          backgroundColor: Colors.purple, // Colore di sfondo
                          side: const BorderSide(
                            color: Color.fromARGB(200, 60, 60, 60),
                            width: 3.0,          // Spessore del bordo
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Arrotondamento del bordo
                          ),
                        ),
                        onPressed: () {
                          if (statiPulsanti[0] == true) {
                            // Pulsante quattro giocatori premuto
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GrigliaQuattro(),
                              ),
                            );
                          }
                          if (statiPulsanti[1] == true) {
                            // Pulsante tre giocatori premuto
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GrigliaTre(),
                              ),
                            );
                          }
                          if (statiPulsanti[2] == true) {
                            // Pulsante due giocatori premuto
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GrigliaDue(),
                              ),
                            );
                          }
                        },
                        child: const Text('Nuova'), // Testo del pulsante Nuova Partita
                      ),
                    ),

                    // 4 Giocatori
                    Align(
                      alignment: const Alignment(-0.9, -0.1), // Posiziona il pulsante per partita a 4 giocatori
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: LightButton(
                          initialImage: "assets/4_s.png",
                          onImage: "assets/4_a.png",
                          isIlluminated: statiPulsanti[0],
                          onPressed: () => _toggleButton(0),
                          text: '',
                        ),
                      ),
                    ),

                    // 3 Giocatori
                    Align(
                      alignment: const Alignment(-0.0, -0.1), // Posiziona il pulsante per partita a 3 giocatori
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: LightButton(
                          initialImage: "assets/3_s.png",
                          onImage: "assets/3_a.png",
                          isIlluminated: statiPulsanti[1],
                          onPressed: () => _toggleButton(1),
                          text: '',
                        ),
                      ),
                    ),

                    // 2 Giocatori
                    Align(
                      alignment: const Alignment(0.9, -0.1), // Posiziona il pulsante per partita a 2 giocatori
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: LightButton(
                          initialImage: "assets/2_s.png",
                          onImage: "assets/2_a.png",
                          isIlluminated: statiPulsanti[2],
                          onPressed: () => _toggleButton(2),
                          text: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}