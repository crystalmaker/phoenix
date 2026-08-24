import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pulsanti_commander.dart';
import 'pagina_principale.dart';

late int colonneVisibili;
bool buttonLight = false;

class GrigliaTavoli extends StatefulWidget {
  final int numeroGiocatori;
  const GrigliaTavoli({super.key, required this.numeroGiocatori});

  @override
  GrigliaTavoliState createState() => GrigliaTavoliState();
}

class GrigliaTavoliState extends State<GrigliaTavoli> {
  Timer? _timer; // Riferimento al Timer
  @override
  void initState() {
    super.initState();
    if (grigliaSalvata == true) {
      return;
    }
    // Creazione delle matrici, se non ne ho già generate in precedenza
    colonneVisibili = 0;
    numeroTavoli = calcolaNumeroTavoli(widget.numeroGiocatori);
    generaMatriceTavoli(widget.numeroGiocatori);
    final random = Random();
    // Generazione della matrice
    matricePlayer = List.generate(10, (_) {
        // Lista dei numeri da 1 a numeroGiocatori
        List<int> numeri = List.generate(widget.numeroGiocatori, (index) => index + 1);

        // Mescola la lista per ottenere abbinamenti random per tutti i round da 1 a 10
        numeri.shuffle(random);

        return numeri;
      },
    );
    modificaMatricePlayer(widget.numeroGiocatori);
    generaAccoppiamentoGiocatori(widget.numeroGiocatori);
    grigliaSalvata = true;
    // Timer per aggiornare la grafica ogni decimo di secondo
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {}); // Aggiorna lo stato se il widget è ancora montato
      } else {
        timer.cancel(); // Annulla il timer se il widget non è più montato
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annulla il Timer per evitare chiamate a setState()
    super.dispose();
  }

  // Fornisce il numero di tavoli corretto in base alla quantità di giocatori disponibili
  int calcolaNumeroTavoli(int numeroGiocatori) {
    if (numeroGiocatori >= 6 && numeroGiocatori <= 8) return 2;
    if (numeroGiocatori >= 9 && numeroGiocatori <= 12) return 3;
    if (numeroGiocatori >= 13 && numeroGiocatori <= 16) return 4;
    if (numeroGiocatori >= 17 && numeroGiocatori <= 20) return 5;
    if (numeroGiocatori >= 21 && numeroGiocatori <= 24) return 6;
    if (numeroGiocatori >= 25 && numeroGiocatori <= 28) return 7;
    if (numeroGiocatori >= 29 && numeroGiocatori <= 32) return 8;
    if (numeroGiocatori >= 33 && numeroGiocatori <= 36) return 9;
    if (numeroGiocatori >= 37 && numeroGiocatori <= 40) return 10;
    return 1; // Valore di default
  }

  // Fornisce la matrice del numero di giocatori per ogni tavolo, in base al numero di giocatori
  void generaMatriceTavoli(int numeroGiocatori) {
    matriceTavoli = []; // Inizializza la matrice
    int t = 0;

    double ntavolida4 = numeroGiocatori / 4;
    double ntavolida3 = 0;
    if (numeroGiocatori % 4 == 3) {
      ntavolida4 -= 0.75;
      ntavolida3 = 1;
    } else {
      if (numeroGiocatori % 4 == 2) {
        ntavolida4 -= 1.50;
        ntavolida3 = 2;
      } else if (numeroGiocatori % 4 == 1) {
        ntavolida4 -= 2.25;
        ntavolida3 = 3;
      }
    }
    // Conversione da double a Int
    int tavolida4 = ntavolida4.toInt();
    int tavolida3 = ntavolida3.toInt();
    // Inserisco il numero di giocatori per tavolo nella matrice
    while (true){
      if (t < tavolida4){
        matriceTavoli.add(4);
      }
      else
        {
          if (t < tavolida4 + tavolida3){
            matriceTavoli.add(3);
          }
          else {
            break;
          }
        }
      t++;
    }
  }

  // Passo dal random totale ad una miglior sequenza random in base al numero di giocatori
  void modificaMatricePlayer(int numeroGiocatori) {
    final random = Random();
    if (numeroGiocatori == 7 || numeroGiocatori == 8) {
      return;
    }
    if (numeroGiocatori == 9) {
      List<int> matrix = [0,1,2,3]; // Mescolo 4 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 2, 6, 7, 3, 4, 8];
      List<int> riga1 = [2, 5, 8, 3, 6, 9, 1, 4, 7];
      List<int> riga2 = [4, 5, 6, 7, 8, 9, 1, 2, 3];
      List<int> riga3 = [1, 6, 8, 2, 4, 9, 3, 5, 7];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[2].setAll(0, riga2);
      matricePlayer[3].setAll(0, riga3);
    }
    if (numeroGiocatori == 10) {
      List<int> matrix = [0,1,2,3]; // Mescolo 3 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 2, 6, 10, 3, 4, 7, 8];
      List<int> riga1 = [1, 6, 8, 10, 2, 7, 4, 3, 5, 9];
      List<int> riga2 = [3, 4, 6, 8, 1, 7, 9, 2, 5, 10];
      List<int> riga3 = [1, 2, 3, 4, 8, 9, 10, 5, 6, 7];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[3].setAll(0, riga3);
    }
    if (numeroGiocatori == 11) {
      List<int> matrix = [0,1,2,3]; // Mescolo 3 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 10, 2, 6, 7 ,11, 3, 4, 8];
      List<int> riga1 = [1, 3, 6, 8, 2, 5, 10, 11, 4, 7, 9];
      List<int> riga2 = [3, 7, 9, 11, 4, 6, 8, 10, 1, 2, 5];
      List<int> riga3 = [5, 6, 7, 8, 1, 2, 3, 4, 9, 10, 11];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[3].setAll(0, riga3);
    }
    if (numeroGiocatori == 12) {
      List<int> matrix = [0,1,2]; // Mescolo 3 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [2, 7, 10, 12, 3, 4, 8, 11, 1, 5, 9, 6];
      List<int> riga1 = [1, 7, 8, 11, 2, 4, 9, 10, 3, 5, 6, 12];
      List<int> riga2 = [5, 6, 7, 8, 1, 2, 3, 4, 9, 10, 11, 12];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[2].setAll(0, riga2);
    }
    if (numeroGiocatori == 13) {
      List<int> matrix = [0,1,2,3]; // Mescolo 3 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 12, 2, 6, 10, 3, 7, 11, 4, 8, 13];
      List<int> riga1 = [1, 6, 10, 13, 2, 7, 11, 3, 8, 12, 4, 5, 9];
      List<int> riga2 = [1, 7, 11, 8, 2, 3, 12, 4, 6, 9, 5, 10, 13];
      List<int> riga3 = [1, 2, 3, 4, 11, 12, 13, 5, 6, 7, 8, 9, 10];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[3].setAll(0, riga3);
    }
    if (numeroGiocatori == 14) {
      List<int> matrix = [0,1,2,3]; // Mescolo 3 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 12, 2, 6, 10, 13, 3, 7, 11, 4, 8, 14];
      List<int> riga1 = [1, 6, 11, 14, 2, 7, 12, 9, 3, 8, 13, 4, 5, 10];
      List<int> riga2 = [1, 7, 10, 13, 2, 5, 8, 14, 3, 4, 9, 6, 11, 12];
      List<int> riga3 = [1, 2, 3, 4, 11, 12, 13, 14, 5, 6, 7, 8, 9, 10];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[3].setAll(0, riga3);
    }
    if (numeroGiocatori == 15) {
      List<int> matrix = [0,1,2,3]; // Mescolo 3 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12];
      List<int> riga1 = [1, 6, 11, 12, 2, 7, 13, 15, 9, 3, 8, 14, 4, 10, 5];
      List<int> riga2 = [1, 7, 14, 10, 2, 5, 8, 9, 3, 6, 12, 13, 4, 11, 15];
      List<int> riga3 = [1, 2, 3, 4, 13, 14, 15, 9, 10, 11, 12, 5, 6, 7, 8];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[3].setAll(0, riga3);
    }
    if (numeroGiocatori == 16) {
      List<int> matrix = [0,1,2,3,4]; // Mescolo 4 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16];
      List<int> riga1 = [4, 10, 5, 15, 2, 7, 13, 12, 1, 6, 11, 16, 9, 3, 8, 14];
      List<int> riga2 = [1, 7, 12, 15, 2, 8, 9, 16, 3, 5, 10, 13, 4, 6, 11, 14];
      List<int> riga3 = [2, 5, 11, 15, 1, 8, 10, 14, 4, 7, 9, 13, 3, 6, 12, 16];
      List<int> riga4 = [1, 2, 3, 4, 13, 14, 15, 16, 9, 10, 11, 12, 5, 6, 7, 8];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[matrix[3]].setAll(0, riga3);
      matricePlayer[4].setAll(0, riga4);
    }
    if (numeroGiocatori == 17) {
      List<int> matrix = [0,1,2,3,4]; // Mescolo 4 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 12, 2, 6, 10, 13, 3, 7, 11, 4, 8, 15, 14, 16, 17];
      List<int> riga1 = [1, 6, 11, 15, 2, 7, 12, 16, 3, 8, 13, 4, 9, 14, 5, 10, 17];
      List<int> riga2 = [1, 7, 13, 16, 2, 8, 14, 17, 3, 9, 15, 4, 10, 12, 5, 6, 11];
      List<int> riga3 = [1, 8, 14, 17, 2, 9, 15, 6, 3, 10, 16, 4, 11, 12, 5, 7, 13];
      List<int> riga4 = [5, 6, 7, 8, 1, 2, 3, 4, 9, 10, 11, 15, 16, 17, 12, 13, 14];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[matrix[3]].setAll(0, riga3);
      matricePlayer[4].setAll(0, riga4);
    }
    if (numeroGiocatori == 18) {
      List<int> matrix = [0,1,2,3,4]; // Mescolo 4 combinazioni
      matrix.shuffle(random);
      // Valori da assegnare alle righe della matrice esistente
      List<int> riga0 = [1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 16, 12, 17, 18];
      List<int> riga1 = [1, 6, 11, 16, 2, 7, 12, 17, 3, 8, 13, 18, 4, 9, 14, 5, 10, 15];
      List<int> riga2 = [1, 7, 13, 18, 2, 8, 14, 15, 3, 9, 16, 17, 4, 10, 11, 5, 6, 12];
      List<int> riga3 = [1, 8, 14, 17, 2, 9, 15, 16, 3, 10, 12, 18, 4, 5, 13, 6, 7, 11];
      List<int> riga4 = [5, 6, 7, 8, 1, 2, 3, 4, 9, 10, 11, 15, 16, 17, 12, 13, 14, 18];

      // Assegna i valori alle righe della matrice esistente
      matricePlayer[matrix[0]].setAll(0, riga0);
      matricePlayer[matrix[1]].setAll(0, riga1);
      matricePlayer[matrix[2]].setAll(0, riga2);
      matricePlayer[matrix[3]].setAll(0, riga3);
      matricePlayer[4].setAll(0, riga4);
    }
  }

  // Crea le stringhe degli abbinamenti che verranno mandate a video nella tabella
  void generaAccoppiamentoGiocatori(int numeroGiocatori) {
    matriceAbbinamenti = List.generate(10, (_) => List.filled(matriceTavoli.length, "- - - -"));
    matriceAbbinamentiMemoria = List.generate(10, (_) => List.filled(matriceTavoli.length, ""));

    for (int round = 0; round < 10; round++) { // 10 Round
      int index = 0; // Indice di matricePlayer
      for (int tavoloNum = 0; tavoloNum < matriceTavoli.length; tavoloNum++) { // numero del tavolo
        for (int playerPerTavolo = 0; playerPerTavolo < matriceTavoli[tavoloNum]; playerPerTavolo++) { // numero di giocatori per tavolo
          if (matriceAbbinamentiMemoria[round][tavoloNum] == "") {
            matriceAbbinamentiMemoria[round][tavoloNum] = "${matricePlayer[round][index]}";
          }
          else {
            matriceAbbinamentiMemoria[round][tavoloNum] = "${matriceAbbinamentiMemoria[round][tavoloNum]} - ${matricePlayer[round][index]}";
          }
          index++;
        }
      }
    }
  }

  // Funzione addColonna con gestione di light
  void addColonna() {
    setState(() {
      buttonLight = true; // Attiva la luce
    });
   // Disattiva la luce dopo 200 ms
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        buttonLight = false; // Disattiva la luce
        colonneVisibili++;
      });
    });

    for (int i = 0; i < matriceAbbinamenti[0].length; i++) {
      matriceAbbinamenti[colonneVisibili][i] = matriceAbbinamentiMemoria[colonneVisibili][i];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nasconde la barra di stato
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    int n = widget.numeroGiocatori;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, // Colore della barra (personalizzabile)
        toolbarHeight: 55,
        centerTitle: true, // Centra il titolo
        title: Text(
          'Griglia Tavoli:  $n Giocatori',
          style: const TextStyle(
            color: Colors.yellow, // Colore del testo (personalizzabile)
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/back.png', // Percorso dell'immagine personalizzata
            width: 100,
            height: 100,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Stack(
            children: [
              Align(
                alignment: const Alignment(0.9, -0.1), // Posiziona il contenitore con pulsante e testo
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center, // Centra il testo rispetto al pulsante
                    children: [
                      LightButton(
                        initialImage: "assets/nextColumn_s.png",
                        onImage: "assets/nextColumn_a.png",
                        isIlluminated: buttonLight,
                        onPressed: () => addColonna(),
                        text: 'Round ${colonneVisibili + 1}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
        ),

      ),

      body: Stack(
        children: [
          // Immagine di sfondo
          Positioned.fill(
            child: Image.asset(
              'assets/sfondonero.jpg', // Percorso dell'immagine
              fit: BoxFit.cover,
            ),
          ),
          // Griglia dinamica
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double columnWidth = constraints.maxWidth / 5; // Larghezza di ciascuna colonna visibile

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Abilita lo scorrimento orizzontale
                  child: SizedBox(
                    width: columnWidth * 10.2, // Larghezza totale della griglia
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical, // Abilita lo scorrimento verticale
                      child: Column(
                        children: [
                          // Aggiungi le intestazioni sopra ogni colonna
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              children: List.generate(
                                matriceAbbinamenti.length,
                                    (colIndex) => Container(
                                  width: columnWidth,
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Transform.translate(
                                    offset: const Offset(18, 10), // Sposta di 10 pixel verso destra
                                    child: Center(
                                      child: Text(
                                        'Turno ${colIndex + 1}', // Testo sopra ogni colonna
                                        style: const TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Griglia principale con valori
                          GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            physics: const NeverScrollableScrollPhysics(), // Disabilita lo scrolling verticale della GridView
                            shrinkWrap: true,
                            itemCount: numeroTavoli * matriceAbbinamenti.length, // Numero totale di celle
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 10, // Numero di righe
                              childAspectRatio: 2.4,
                            ),
                            itemBuilder: (context, index) {
                              // Calcola la riga e la colonna corrispondente nella matrice
                              int rowIndex = index ~/ matriceAbbinamenti.length; // Trova l'indice della riga
                              int colIndex = index % matriceAbbinamenti.length; // Trova l'indice della colonna

                              // Prendi il valore corrispondente dalla matrice
                              String cellValue = matriceAbbinamenti[colIndex][rowIndex];

                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[900],
                                  border: Border.all(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    cellValue, // Mostra il valore della matrice
                                    style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'Arial',),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );



  }
}
