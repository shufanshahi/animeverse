import 'package:flutter/material.dart';
import 'dart:math';

class ProfileAvatarGenerator {
  static final Random _random = Random();
  
  // Collection of animal-themed profile icons
  static final List<IconData> _profileIcons = [
    Icons.pets, // paw print
    Icons.flutter_dash, // Dash mascot (bird-like)
    Icons.emoji_nature, // nature/animal
    Icons.cruelty_free, // bunny symbol
    Icons.catching_pokemon, // creature
    Icons.sentiment_very_satisfied, // happy face (animal-like)
    Icons.mood, // cute expression
    Icons.eco, // nature/wildlife
    Icons.park, // animals in park
    Icons.forest, // forest animals
    Icons.water_drop, // water animals like fish
    Icons.local_florist, // bee (flower pollinator)
    Icons.wb_sunny, // lion (sunny like mane)
    Icons.nights_stay, // nocturnal animals like owl
    Icons.grain, // farm animals
    Icons.grass, // field animals like rabbits
    Icons.waves, // sea creatures
    Icons.ac_unit, // arctic animals like polar bears
    Icons.favorite, // love for animals
    Icons.auto_awesome, // magical creatures
  ];

  // Collection of nature-inspired avatar colors
  static final List<Color> _avatarColors = [
    Colors.orange, // fox, tiger
    Colors.brown, // bear, deer
    Colors.green, // frog, turtle
    Colors.blue, // whale, dolphin
    Colors.grey, // elephant, wolf
    Colors.yellow, // chick, lion
    Colors.pink, // flamingo, pig
    Colors.purple, // butterfly, exotic birds
    Colors.teal, // peacock, tropical fish
    Colors.indigo, // deep sea creatures
    Colors.amber, // honey bee, golden retriever
    Colors.lime, // chameleon, parrot
    Colors.deepOrange, // tiger, goldfish
    Colors.lightBlue, // penguin, seal
    Colors.lightGreen, // tree frog, grasshopper
  ];

  /// Generate a random profile avatar
  static Widget generateRandomAvatar({
    double size = 80,
    String? seed, // Optional seed for consistent randomization
  }) {
    // Use seed for consistent randomization if provided
    final random = seed != null ? Random(seed.hashCode) : _random;
    
    final icon = _profileIcons[random.nextInt(_profileIcons.length)];
    final color = _avatarColors[random.nextInt(_avatarColors.length)];
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: size * 0.6,
        color: color,
      ),
    );
  }

  /// Generate a consistent avatar based on email (same email = same avatar)
  static Widget generateConsistentAvatar({
    required String email,
    double size = 80,
  }) {
    return generateRandomAvatar(
      size: size,
      seed: email, // Use email as seed for consistency
    );
  }

  /// Generate a completely random avatar (different each time)
  static Widget generateTrulyRandomAvatar({
    double size = 80,
  }) {
    return generateRandomAvatar(size: size);
  }
}