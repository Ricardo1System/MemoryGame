

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_game/screen/game.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GameView(),));
              },
              child: const CustomTitle()),
          ],
        ),
      ),
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