

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_game/main.dart';
import 'package:memory_game/screen/game.dart';
import 'package:memory_game/services/cache/shared_preferences.dart';
import 'package:memory_game/utils/constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with RouteAware{
  int scoreCache = CacheService.getInteger(key: scoreConst);
  SizeGame selectedMode = SizeGame.easy;
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    refresh();
  }

  refresh(){
    setState(() {
      scoreCache = CacheService.getInteger(key: scoreConst);
    });
  }

  int getMode(SizeGame option){
    switch (option) {
      case SizeGame.easy:
        return 4;
      case SizeGame.medium:
        return 6;
      case SizeGame.hard:
        return 8;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            backgroundColor: WidgetStatePropertyAll(Colors.blue)
          ),
          onPressed: () {
            refresh();
          CacheService.saveData(key: scoreConst, value: 0);
        }, child: const Text("Reset")),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GameView(size: getMode(selectedMode),),));
              },
              child: const CustomTitle()),
            RecordsWidget(scoreCache: scoreCache,),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0)),
              child: DropdownButton<SizeGame>(
                borderRadius: BorderRadius.circular(20.0),
                dropdownColor: Colors.blue,
                menuWidth: MediaQuery.of(context).size.width * 0.5,
                value: selectedMode,
                iconSize: 0.0,
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onChanged: (SizeGame? newValue) {
                  setState(() {
                    selectedMode = newValue!;
                  });
                },
                items: SizeGame.values.map((SizeGame option) {
                  return DropdownMenuItem<SizeGame>(
                    value: option,
                    child: Text(
                      option.name.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class RecordsWidget extends StatelessWidget {
  const RecordsWidget({
    super.key, required this.scoreCache,
  });
  final int scoreCache;

  @override
  Widget build(BuildContext context) {
    String scoreResult = (scoreCache).toString();
    return  Column(
      children: [
        Text.rich(TextSpan(text: "High score:  ", style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w600), children: [
          TextSpan(text: scoreResult)
        ])),
      ],
    );
  }
}

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
          color: Colors.blue[500],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.blue, blurRadius: 5.0, blurStyle: BlurStyle.normal, offset: Offset(0, 2))
          ]),
      child: Text.rich(TextSpan(
          text: "Memory ",
          style: GoogleFonts.aboreto(
              color: Colors.white, fontStyle: FontStyle.italic, fontSize: 25.0),
          children: [
            TextSpan(
              text: "Game",
              style: GoogleFonts.aDLaMDisplay(
                  color: Colors.white, fontStyle: FontStyle.italic, fontSize: 25.0),
            )
          ])),
    );
  }
}