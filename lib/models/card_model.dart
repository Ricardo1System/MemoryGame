
import 'package:flip_card/flip_card_controller.dart';

class CardModel {
  final String image;
  final FlipCardController controller;
  bool isActive;

  CardModel({required this.controller,required this.image,  required this.isActive});
}