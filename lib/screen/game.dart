import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_game/models/card_model.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
      List<CardModel> cardList = [
      CardModel(index: 0, image: "assets/images/basquet_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 1, image: "assets/images/basquet_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 2, image: "assets/images/soccer_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 3, image: "assets/images/soccer_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 4, image: "assets/images/tenis_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 5, image: "assets/images/tenis_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 6, image: "assets/images/voleibol_ball.png", isActive: false, controller: FlipCardController()),
      CardModel(index: 7, image: "assets/images/voleibol_ball.png", isActive: false, controller: FlipCardController()),
    ];

    List<CardModel> cardsActived = [];

    bool isTime = false;
    Timer? _timer;

    void startTime(){
      _timer = Timer(const Duration(seconds: 3), () {
        setState(() {
          cardsActived.clear();
          isTime = true;
        });
      },);
      
    }

    @override
    void initState() {
      startTime();
      super.initState();
    }

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: cardList.length,
            itemBuilder: (context, index) {
              return FlipCard(
                key: Key(index.toString()),
                controller: cardList[index].controller,
                fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                direction: FlipDirection.HORIZONTAL, // default
                side: CardSide.FRONT, // The side to initially display.
                front: Card(
                  color: cardList[index].isActive == true? Colors.green : Colors.white,
                  child: Column(
                    children: [
                      Image.asset(cardList[index].image),
                    ],
                  ),
                ),
                back: Card(
                  color: Colors.blue,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: Center(
                      child: Text.rich(TextSpan(
                          text: "Memory ",
                          style: GoogleFonts.aboreto(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 13.0),
                          children: [
                            TextSpan(
                              text: "Game",
                              style: GoogleFonts.aDLaMDisplay(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13.0),
                            )
                          ])),
                    ),
                  ),
                ),
                flipOnTouch: cardList[index].isActive == true? false : true,
                onFlipDone: (isFront) {
                  if (isTime) {
                    if (!isFront) {
                   cardsActived.add(cardList[index]);
                  }
                    if (isFront) {
                   cardsActived.remove(cardList[index]);
                  }
                  if (cardsActived.length == 2) {
                    if (cardsActived.first.image == cardsActived.last.image) {
                      for (var card in cardsActived) {
                        setState(() {
                          cardList[card.index].isActive = true;
                        });
                      }
                    }else{
                      setState(() {
                        cardsActived.first.controller.state?.activate();
                        cardsActived.last.controller.state?.isFront = false;
                      });
                    }
                    cardsActived.clear();
                  }
                  }
                },
                autoFlipDuration: const Duration(
                    seconds:
                        2), // The flip effect will work automatically after the 2 seconds
              );
            },
          ),
        ),
      ),
    );
  }
}
