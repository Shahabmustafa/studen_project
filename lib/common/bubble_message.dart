import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key,
    required this.content,
    required this.isMe,
    required this.timeStep,
  });
  final String content;
  final bool isMe;
  final String timeStep;


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: isMe ?
          const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ) :
          const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: isMe ? Colors.grey : Colors.blueAccent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )
            ),
            Text(
              timeStep.toString(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}