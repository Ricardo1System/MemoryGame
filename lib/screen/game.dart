import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_game/models/card_model.dart';
import 'package:memory_game/services/cache/shared_preferences.dart';
import 'package:memory_game/utils/constants.dart';

class GameView extends StatefulWidget {
  const GameView({super.key, required this.size});

  final int size;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
      List<String> imageList = [
        "assets/images/basquet_ball.png",
        "assets/images/soccer_ball.png",
        "assets/images/tenis_ball.png",
        "assets/images/voleibol_ball.png"
      ];
      List<CardModel> cardList = [];

void generateCards() {
  cardList = [];

  for (int i = 0; i < widget.size; i++) {
    int imageIndex = i % imageList.length;
    cardList.add(CardModel(
      controller: FlipCardController(),
      image: imageList[imageIndex],
      isActive: false,
    ));
    cardList.add(CardModel(
      controller: FlipCardController(),
      image: imageList[imageIndex],
      isActive: false,
    ));
  }

  cardList.shuffle(Random());
}

    List<int> cardsActived = [];
    int score = 0;
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

    Future<void> flipCard(int index) async {
     await cardList[index].controller.toggleCard();
    }

    void saveHighScore(){
      int scoreSaved = CacheService.getInteger(key: scoreConst);
      if (score > scoreSaved) {
        CacheService.saveData(key: scoreConst, value: score);
      }
    }

    @override
    void initState() {
      startTime();
      generateCards();
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
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text('Score:  ${score.toString()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          height:MediaQuery.of(context).size.height-90,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:  widget.size <= 6 ? 3 : 4,
              // mainAxisSpacing: 0.0,
              // // childAspectRatio: 1,
              // mainAxisExtent: null,
              // crossAxisSpacing: 0.0,
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
                              fontSize: widget.size <= 6 ? 13.0: 8),
                          children: [
                            TextSpan(
                              text: "Game",
                              style: GoogleFonts.aDLaMDisplay(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: widget.size <= 6 ? 13.0: 8),
                            )
                          ])),
                    ),
                  ),
                ),
                flipOnTouch: cardList[index].isActive == true? false : true,
                onFlipDone: (isFront) async {
                  if (isTime) {
                    if (!isFront) {
                   cardsActived.add(index);
                  }
                    if (isFront) {
                   cardsActived.remove(index);
                  }
                  if (cardsActived.length == 2) {
                    if (cardList[cardsActived.first].image == cardList[cardsActived.last].image) {
                      for (var card in cardsActived) {
                        setState(() {
                          score = score + 5;
                          saveHighScore();
                          cardList[card].isActive = true;
                        });
                      }
                    }else{
                      for (var card in cardsActived) {
                       await flipCard(card);
                      } 
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
