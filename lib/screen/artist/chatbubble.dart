import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upculture/model/artist/newchatmodal.dart';
import 'package:upculture/resources/my_color.dart';

class ChatBubble extends StatefulWidget {
  final bool isUser;
  final Widget content;
  final ChatMessageTest message;

  const ChatBubble({
    super.key,
    required this.isUser,
    required this.content,
    required this.message,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  String formatTimeAMPM(String isoString) {
    final dateTime = DateTime.parse(isoString);
    final formatter = DateFormat('hh:mm:ss a'); // e.g. 02:45 PM
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _offsetAnimation = Tween<Offset>(
      begin: widget.isUser ? Offset(1.0, 0.0) : Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.isUser;
    final content = widget.content;
    final message = widget.message;

    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Image.asset(
                      "assets/images/bot.png",
                      height: 15,
                      width: 15,
                    ),
                  SizedBox(height: 8),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isUser
                            ? MyColor.appColor.withOpacity(0.5)
                            : Colors.blueGrey.shade100,
                        width: .8,
                      ),
                      color: isUser
                          ? MyColor.appColor.withAlpha(40)
                          : Colors.white,
                      borderRadius: isUser
                          ? BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                    ),
                    child: content,
                  ),
                  SizedBox(height: 4),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.23,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isUser
                            ? MyColor.appColor.withOpacity(0.5)
                            : Colors.blueGrey.shade100,
                        width: .8,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isUser
                          ? MyColor.appColor.withAlpha(40)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          formatTimeAMPM(message.timestamp),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        if (isUser)
                          Image.asset(
                            "assets/images/doubletick.png",
                            height: 10,
                            width: 10,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
