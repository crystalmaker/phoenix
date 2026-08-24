import 'package:flutter/material.dart';


class RegistroEventi extends StatelessWidget {
  final List<String> eventi;

  final String tempo;
  const RegistroEventi({
    super.key,
    required this.eventi,
    required this.tempo,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.85),
          toolbarHeight: 70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Registro eventi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),

              Text(
                "Tempo di gioco:  $tempo     ",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.black.withValues(alpha: 0.75),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse : true,
                  itemCount: eventi.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        eventi[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(220, 240, 240, 240),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
                      color: Colors.redAccent,
                      width: 3
                    ),
                  ),
                ),
                child: Text("Chiudi log",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        )
    );
  }
}