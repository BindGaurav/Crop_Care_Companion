import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define your color palette
const background = Color(0xFF121212);
const white = Colors.white;
const userChat = Color(0xFF007AFF);
const resChat = Color(0xFFE0E0E0);

// Define your text styles
final messageText = const TextStyle(
  fontSize: 16.0,
  color: white,
);

final dateText = TextStyle(
  fontSize: 12.0,
  color: white.withOpacity(0.6),
);
final promptText = GoogleFonts.poppins(
  fontSize: 16.0,
  color: white,
);

final hintText = GoogleFonts.poppins(
  fontSize: 16.0,
  color: white.withOpacity(0.6),
);

// Define your spacing constants
const xsmall = 4.0;
const small = 8.0;
const medium = 16.0;
const large = 24.0;
const xlarge = 32.0;
