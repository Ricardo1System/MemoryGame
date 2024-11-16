
import 'package:flip_card/flip_card_controller.dart';

class CardModel {
  final int index;
  final String image;
  final FlipCardController controller;
  bool isActive;

  CardModel({required this.controller, required this.index,required this.image,  required this.isActive});
}