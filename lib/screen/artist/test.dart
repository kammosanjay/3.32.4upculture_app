import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:upculture/controller/artist/artist_home_controller.dart';
import 'package:upculture/model/artist/newchatmodal.dart';
import 'package:upculture/model/artist/request/chat_request_modal.dart';
import 'package:upculture/network/api_client.dart';
import 'package:upculture/network/api_constants.dart';

import 'package:upculture/resources/my_assets.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:upculture/resources/my_font.dart';
import 'package:upculture/resources/my_font_weight.dart';
import 'package:upculture/screen/artist/chatbubble.dart';

import 'package:upculture/utils/newdatabaseHelper.dart';

class ChatBotScreen extends StatefulWidget {
  final String? userId;

  const ChatBotScreen({super.key, this.userId});
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  late List<ChatMessageTest> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _programNameController = TextEditingController();
  final TextEditingController _programDateController = TextEditingController();
  late TextEditingController _mobileController = TextEditingController();
  final _nameController = TextEditingController();
  bool ontappedAdmin = false;
  final _queryController = TextEditingController();

  // Predefined messages to show on first open.

  List<String> certKeywords = [
    'certificate',
    'cert',
    'cer',
    'cre',
    'mujhe certificate chahiye',
    'mujhe program ka certificate chahiye',
    'main certificate chahata hoon',
    'maine ko program kiya tha',
    'certi',
    'certificat',
    'cerificate',
    'certifcate',
    'enquiry',
    'enq',
    'inquiry',
    'enqiry',
    'enquary',
    'certificate enquiry',
    'enquiry certificate',
    'certificate-enquiry',
    'certificate, enquiry',
    'certificate: enquiry',
    'certificate enquiry form',
    'enquiry for certificate',
    'want certificate',
    'need certificate',
    'certificate request',
    'apply certificate',
    'get certificate',
    'about certificate',
    'request certificate',
    'how to get certificate',
  ];
  bool isCertificateEnquiry(String input) {
    return certKeywords.any((word) => input.toLowerCase().contains(word));
  }

  void _sendMessage() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    ChatMessageTest userMessage = ChatMessageTest(
        sender: 'User',
        text: text,
        timestamp: DateTime.now().toIso8601String());
    print("User Message===> ${userMessage.toMap()}");

    // setState(() {
    //   _messages.insert(0, userMessage);
    // });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _messages.insert(0, userMessage);
      });
    });
    await ChatDatabaseTwo.instance.insertMessage(userMessage);

    _controller.clear();

    // Handle predefined options
    if (text == '1') {
      // Show Certificate Request form
      Future.delayed(Duration(milliseconds: 1500), () {
        openCerDialogbyText();
      });
    } else if (text == '2') {
      // upcomingProg();
      upComingProgList();

      // _showProgramDialog(); // Show upcoming program date
    } else if (text == '3') {
      // _showPaymentDialog(); // Show Payment Request form
      paymentReq();
    } else if (text == '4') {
      // _showAdminMessageDialog(); // Show admin message form
      messagetoAdmin();
    } else {
      // Bot replies and then shows options again
      Future.delayed(Duration(milliseconds: 1000), () async {
        String botResponse = _getBotResponse(text);

        ChatMessageTest botMessage = ChatMessageTest(
            sender: 'Bot',
            text: botResponse,
            timestamp: DateTime.now().toIso8601String());

        setState(() {
          _messages.insert(0, botMessage);
        });

        await ChatDatabaseTwo.instance.insertMessage(botMessage);

        // Show options again
        _showPredefinedOptions();
      });
    }
  }

  // Example: 02:30:45 PM

  upcomingProg() {
    String upcomingDate =
        ' 15-12-2023'; // Replace with actual upcoming date logic;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("आगामी कार्यक्रम",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColor.appColor)),
        content: Text("अगले कार्यक्रम की तिथि: $upcomingDate",
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();

              Future.delayed(Duration(milliseconds: 1500), () {
                setState(() {
                  _messages.insert(
                      0,
                      ChatMessageTest(
                          sender: 'Bot',
                          text:
                              "आपके धैर्य के लिए धन्यवाद हम जल्द ही आपको अपडेट करेंगे",
                          timestamp: DateTime.now().toIso8601String()));
                });
              });
              _showPredefinedOptions();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  paymentReq() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("भुगतान अनुरोध",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColor.appColor)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'आवेदक का नाम',
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
              ),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                    labelText: 'मोबाइल नंबर',
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _programNameController,
                decoration: InputDecoration(
                    labelText: 'कार्यक्रम का नाम',
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
              ),
              TextField(
                controller: _queryController,
                decoration: InputDecoration(
                    labelText: 'आपकी क्वेरी',
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                fetchData();

                String userText =
                    "💳 Payment Enquiry\n\nName: ${_nameController.text}\nMobile: ${_mobileController.text}\nProgram Name : ${_programNameController.text}\nQuery : ${_queryController.text}";

                ChatMessageTest userMessage = ChatMessageTest(
                    sender: 'User',
                    text: userText,
                    timestamp: DateTime.now().toIso8601String());

                setState(() {
                  _messages.insert(0, userMessage);
                });
                ChatDatabaseTwo.instance.insertMessage(userMessage);

                // Save bot message after a delay
                Future.delayed(Duration(milliseconds: 1500), () {
                  ChatMessageTest botMessage = ChatMessageTest(
                      sender: 'Bot',
                      text:
                          "आपके धैर्य के लिए धन्यवाद हम जल्द ही आपको अपडेट करेंगे",
                      timestamp: DateTime.now().toIso8601String());

                  setState(() {
                    _messages.insert(0, botMessage);
                  });
                  ChatDatabaseTwo.instance.insertMessage(botMessage);
                });

                // _showPredefinedOptions();
              },
              child: Text("Submit",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColor.appColor))),
        ],
      ),
    );
  }

  messagetoAdmin() {
// message to admin
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("व्यवस्थापक को संदेश",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColor.appColor)),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'आपका संदेश',
            labelStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                fetchData();
                String userText = "Admin Message: ${_controller.text}";

                ChatMessageTest userMessage = ChatMessageTest(
                    sender: 'User',
                    text: userText,
                    timestamp: DateTime.now().toIso8601String());

                // Instantly show in UI
                setState(() {
                  _messages.insert(0, userMessage);
                });

                // Save to database
                ChatDatabaseTwo.instance.insertMessage(userMessage);
              },
              child: Text("Submit",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColor.appColor))),
        ],
      ),
    );
  }

  _showPredefinedOptions() {
    String predefinedOptions = '''
कृपया अपनी पसंद का विकल्प चुनने के लिए 1, 2, 3, या 4 टाइप करें:

1. आपके हाल के कार्यक्रम के लिए प्रमाणपत्र अनुरोध  
2. आगामी कार्यक्रम  
3. हाल ही में किए गए कार्यक्रम या शेष राशि के लिए भुगतान अनुरोध  
4. यदि आपका प्रश्न उपरोक्त विकल्पों में से किसी से संबंधित नहीं है, तो एडमिन को संदेश भेजें  
''';

    ChatMessageTest botMessage = ChatMessageTest(
        sender: 'Bot',
        text: predefinedOptions,
        timestamp: DateTime.now().toIso8601String());

    setState(() {
      _messages.insert(0, botMessage);
    });

    ChatDatabaseTwo.instance.insertMessage(botMessage);
  }

  void _deleteAllMessages() async {
    await ChatDatabaseTwo.instance.deleteAllMessages();
    setState(() {
      _messages.clear();
    });
  }

  openCerDialogbyText() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("प्रमाणपत्र अनुरोध",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColor.appColor)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _programNameController,
                decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    labelText: 'कार्यक्रम का नाम'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _programDateController,
                decoration: InputDecoration(
                    hintText: "dd-mm-yyyy",
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    labelText: 'कार्यक्रम दिनांक '),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    labelText: 'आवेदक का मोबाइल नंबर'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                String userText =
                    "📄 Certificate Enquiry\n\nProgram: ${_programNameController.text}\nDate: ${_programDateController.text}\nMobile: ${_mobileController.text}";

                ChatMessageTest userMessage = ChatMessageTest(
                    sender: 'User',
                    text: userText,
                    timestamp: DateTime.now().toIso8601String());

                // Save to database
                ChatDatabaseTwo.instance.insertMessage(userMessage);

                Future.delayed(Duration(milliseconds: 600), () {
                  setState(() {
                    _messages.insert(0, userMessage);
                  });
                });
                fetchData();
              },
              child: Text("Submit",
                  style: GoogleFonts.poppins(
                      fontSize: 18, color: MyColor.appColor))),
        ],
      ),
    );
  }

  openPayDialogbyText() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Payment Request",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColor.appColor)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Applicant Name',
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
              ),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _programNameController,
                decoration: InputDecoration(
                    labelText: 'Program Name',
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
              ),
              TextField(
                controller: _queryController,
                decoration: InputDecoration(
                    labelText: 'Your Query',
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45)),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                fetchData();

                String userText =
                    "💳 Payment Enquiry\n\nName: ${_nameController.text}\nMobile: ${_mobileController.text}\nProgram Name : ${_programNameController.text}\nQuery : ${_queryController.text}";

                ChatMessageTest userMessage = ChatMessageTest(
                    sender: 'User',
                    text: userText,
                    timestamp: DateTime.now().toIso8601String());

                setState(() {
                  _messages.insert(0, userMessage);
                });
                ChatDatabaseTwo.instance.insertMessage(userMessage);

                // Save bot message after a delay
                Future.delayed(Duration(milliseconds: 1500), () {
                  ChatMessageTest botMessage = ChatMessageTest(
                      sender: 'Bot',
                      text:
                          "आपके धैर्य के लिए धन्यवाद हम जल्द ही आपको अपडेट करेंगे",
                      timestamp: DateTime.now().toIso8601String());

                  setState(() {
                    _messages.insert(0, botMessage);
                  });
                  ChatDatabaseTwo.instance.insertMessage(botMessage);
                });
              },
              child: Text("Submit",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColor.appColor))),
        ],
      ),
    );
  }

  /// Provides a simple response logic based on the user's input.
  String _getBotResponse(String userText) {
    String input = userText.toLowerCase();
    if (isCertificateEnquiry(input)) {
      Future.delayed(Duration(seconds: 2), () {
        openCerDialogbyText();
      });
      return 'कृपया यह फॉर्म भरें, हमारी टीम आपके प्रमाणपत्र की स्थिति की जांच करेगी और आपसे संपर्क करेगी';
    } else if (input.contains('payment')) {
      Future.delayed(Duration(seconds: 2), () {
        openPayDialogbyText();
      });
      return 'कृपया यह फॉर्म भरें, हमारी टीम आपकी भुगतान स्थिति की जांच करेगी और आपसे संपर्क करेगी.';
    } else if (input.contains('hello') || input.contains('hi')) {
      return 'नमस्ते, मैं आज आपकी सहायता कैसे करूं?';
    } else {
      return 'आपके संदेश के लिए धन्यवाद। हमारी टीम जल्द ही जवाब देगी।.';
    }
  }

  Widget _buildMessage(ChatMessageTest message) {
    bool isUser = message.sender == 'User';

    Widget content;

    switch (message.type) {
      case MessageType.image:
        content = Image.file(File(message.filePath!), height: 100);
        break;
      case MessageType.pdf:
        content = Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red),
            SizedBox(width: 8),
            Expanded(child: Text(message.text)),
          ],
        );
        break;
      case MessageType.video:
        content = Row(
          children: [
            Icon(Icons.videocam, color: Colors.green),
            SizedBox(width: 8),
            Expanded(child: Text(message.text)),
          ],
        );
        break;
      case MessageType.audio:
        content = Row(
          children: [
            Icon(Icons.audiotrack, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text(message.text)),
          ],
        );
        break;
      default:
        content = RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: message.text,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
    }

    String formatTimeAMPM(String isoString) {
      final dateTime = DateTime.parse(isoString);
      final formatter = DateFormat('hh:mm:ss a'); // e.g. 02:45 PM
      return formatter.format(dateTime);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
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
                    color:
                        isUser ? MyColor.appColor.withAlpha(40) : Colors.white,
                    borderRadius: isUser
                        ? BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            // bottomRight: Radius.circular(10),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            // bottomLeft: Radius.circular(10)
                          ),
                  ),
                  child: content,
                ),
                // Display timestamp
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
                    borderRadius: isUser
                        ? BorderRadius.only(
                            topLeft: Radius.circular(10),
                            // topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : BorderRadius.only(
                            // topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                    color:
                        isUser ? MyColor.appColor.withAlpha(40) : Colors.white,
                  ),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatTimeAMPM(message.timestamp),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                      // display double tick if user message
                      Spacer(),
                      if (isUser)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            "assets/images/doubletick.png",
                            height: 10,
                            width: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the center overlay for predefined messages.
  late AnimationController _aniController;
  late Animation<double> _textAnimation;
  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _textAnimation = Tween<double>(
            begin: -200, // Start off-screen (right to left)
            end: 70)
        .animate(
      CurvedAnimation(
        parent: _aniController,
        curve: Curves.easeOut,
      ),
    );
    print("CurrentUserId===>" + widget.userId.toString());
    // Show predefined messages on first load
    _showPredefinedOptions();
    _loadMessages();
    // _mobileController = artistHomeController.profileData!.mobile_number == null
    //     ? TextEditingController()
    //     : TextEditingController(
    //         text: artistHomeController.profileData!.mobile_number.toString());
  }

  void _loadMessages() async {
    List<ChatMessageTest> savedMessages =
        await ChatDatabaseTwo.instance.fetchAllMessages();
    setState(() {
      _messages = savedMessages;
    });
  }

  ScrollController _scrollController = ScrollController();
  ArtistHomeController artistHomeController = Get.put(ArtistHomeController());

  /// Build the overall chat screen.
  @override
  Widget build(BuildContext context) {
    print("history :---->" + "${_messages.map((msg) => msg.toMap()).toList()}");

    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside the text field.
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text(
              // MyString.drawerTitle
              'drawerTitle'.tr,
              maxLines: 1,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontFamily: MyFont.roboto,
                  fontWeight: MyFontWeight.regular,
                  fontSize: 20),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: CachedNetworkImage(
                  imageUrl:
                      artistHomeController.profileData!.userProfile.toString(),
                  fit: BoxFit.cover,
                  height: 35,
                  width: 35,
                  imageBuilder: (context, imageProvider) => GestureDetector(
                    onTap: () {}, // Optional: you can remove this
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("Delete All Chats"),
                                  content: Text(
                                      "Are you sure you want to delete all chat messages?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteAllMessages();
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              });
                          // Call your function here
                        }
                      },
                      color: Colors.indigo.shade900,
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            "Delete All Chat",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      child: CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Image(
                image: upGovLogo,
                height: 30.0,
                width: 30.0,
                color: Colors.white,
              ),
            ),
          ),

          // The main layout is a Column with the chat area and the input field.
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chat messages list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),
              // if (_predefinedVisible) _buildPredefinedMessages(),

              Divider(height: 1),

              // Input field pinned to bottom
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      color: MyColor.appColor,
                      onPressed: () {
                        _pickedfile();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText: 'write a message',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: MyColor.appColor,
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  File? _selectedFile;

  _pickedfile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'docx', 'mp4', 'mp3', 'm4a'],
    );

    if (result != null && result.files.first.path != null) {
      String path = result.files.first.path!;
      if (!mounted) return;
      setState(() {
        _selectedFile = File(path);
      });

      toUploadFiles();

      String name = result.files.first.name;
      MessageType type;

      if (name.endsWith('.jpg') || name.endsWith('.png')) {
        type = MessageType.image;
      } else if (name.endsWith('.pdf') || name.endsWith('.docx')) {
        type = MessageType.pdf;
      } else if (name.endsWith('.mp4')) {
        type = MessageType.video;
      } else if (name.endsWith('.mp3') || name.endsWith('.m4a')) {
        type = MessageType.audio;
      } else {
        type = MessageType.text;
      }

      ChatMessageTest userMessage = ChatMessageTest(
        sender: 'User',
        text: name,
        type: type,
        filePath: path,
        timestamp: DateTime.now().toIso8601String(),
      );

      if (!mounted) return;
      setState(() {
        _messages.insert(0, userMessage);
      });

      await ChatDatabaseTwo.instance.insertMessage(userMessage);

      ChatMessageTest botMessage = ChatMessageTest(
          sender: 'Bot',
          text: "आपके धैर्य के लिए धन्यवाद हम जल्द ही आपको अपडेट करेंगे",
          timestamp: DateTime.now().toIso8601String());

      Future.delayed(Duration(milliseconds: 1500), () async {
        if (!mounted) return;
        setState(() {
          _messages.insert(0, botMessage);
        });

        await ChatDatabaseTwo.instance.insertMessage(botMessage);
        _showPredefinedOptions();
      });
    }
  }

  Future<void> toUploadFiles() async {
    var uri = Uri.parse(ApiConstants.chatApi);

    if (_selectedFile == null) {
      print("No file selected");
      return;
    }

    // Validate file extension based on allowed types
    final filePath = _selectedFile!.path;
    if (!['.jpg', '.png', '.pdf', '.docx', '.mp4', '.mp3', '.m4a']
        .any((ext) => filePath.endsWith(ext))) {
      print(
          "Invalid file type. Only allowed file types: jpg, png, pdf, docx, mp4, mp3, m4a");
      return;
    }

    var request = http.MultipartRequest('POST', uri);
    //send userId with request
    request.fields['user_id'] = widget.userId.toString();

    // Add the selected file to the request
    request.files.add(
      await http.MultipartFile.fromPath('attachment', filePath),
    );

    try {
      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        print("Upload success: $responseString['message']");

        if (!mounted) return;

        // Inform the user that the upload was successful
        setState(() {
          _messages.insert(
            0,
            ChatMessageTest(
                sender: 'Bot',
                text: 'फाइल सफलतापूर्वक अपलोड हो गई है।',
                type: MessageType.text,
                timestamp: DateTime.now().toIso8601String()),
          );
        });

        // Save response message to database
        await ChatDatabaseTwo.instance.insertMessage(
          ChatMessageTest(
              sender: 'Bot',
              text: 'फाइल सफलतापूर्वक अपलोड हो गई है।',
              type: MessageType.text,
              timestamp: DateTime.now().toIso8601String()),
        );

        // Clear selected file after successful upload
        _selectedFile = null;
      } else {
        print("Upload failed: ${streamedResponse.statusCode}");
      }
    } catch (e) {
      print("Error during upload: $e");
    }
  }

  Future<void> fetchData() async {
    Get.back(closeOverlays: true); // Close any overlays

    final userQuery = _controller.text;

    final response = await ApiClient().postRequestFormData(
      url: ApiConstants.chatApi,
      requestModel: ProgramEnquiryRequest(
        userId: widget.userId.toString(),
        programName: _programNameController.text,
        programDate: _programDateController.text,
        mobileNumber: _mobileController.text,
        artistName: artistHomeController.profileData!.name.toString(),
        queryDetail: _queryController.text,
        message: userQuery,
      ).toJson(),
    );

    if (response != null) {
      print("RESPONSE===> ${response['message']}");
      String message = response['message'] ?? 'No response from server';
      String msgRes = message == response['message']
          ? "आपका अनुरोध सफलतापूर्वक सहेज लिया गया है:"
          : "सर्वर में कुछ त्रुटि है, कृपया कुछ समय बाद पुनः प्रयास करें।";

      _controller.clear();

      // ⏳ After 3 seconds: show first bot confirmation message
      Future.delayed(Duration(seconds: 3), () {
        final confirmationMessage = ChatMessageTest(
          sender: 'Bot',
          text: msgRes,
          type: MessageType.text,
          timestamp: DateTime.now().toIso8601String(),
        );

        setState(() {
          _messages.insert(0, confirmationMessage);
        });

        ChatDatabaseTwo.instance.insertMessage(confirmationMessage);

        // 🤖 After 2 more seconds: show automatic bot reply
        Future.delayed(Duration(seconds: 2), () {
          final autoReply = ChatMessageTest(
            sender: 'Bot',
            text: _getBotResponse(userQuery),
            type: MessageType.text,
            timestamp: DateTime.now().toIso8601String(),
          );

          setState(() {
            _messages.insert(0, autoReply);
          });

          ChatDatabaseTwo.instance.insertMessage(autoReply);
          _showPredefinedOptions();
        });
      });
    } else {
      print("❌ Error fetching data from API");
    }
  }

  List<dynamic> upComingEvents = [];
  Future<void> upComingProgList() async {
    final respone = await ApiClient()
        .getRequestFormDataWithLoader(url: ApiConstants.programListApi);
    if (respone != null) {
      print("Upcoming Program List===>" + respone.toString());
      if (respone['code'] == 200) {
        if (respone['type'] == 'success') {
          if (respone['data'] != null && respone['data'].isNotEmpty) {
            List<dynamic> data = respone['data'];

            // add event_name to each event
            upComingEvents = data.map((e) {
              return {
                'event_name': e['event_name'] ?? 'No Name',
                'start_date': e['start_date'] ?? 'No Date',
                'end_date': e['end_date'] ?? 'No Date',

                // Add other fields if needed
              };
            }).toList();

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Upcoming Program"),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Container(
                          color: MyColor.appColor.withOpacity(0.1),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upcoming Programs",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(2),
                                },
                                children: [
                                  // Table Header
                                  TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "Start Date",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "Program Name",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "End Date",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Dynamic Rows from upComingEvents
                                  ...upComingEvents.map((event) {
                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            event['start_date'] ?? '',
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            event['event_name'] ?? '',
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            event['end_date'] ?? '',
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      ChatDatabaseTwo.instance.insertMessage(
                        ChatMessageTest(
                          sender: 'User',
                          text: upComingEvents.map((e) {
                            return "Event Name: ${e['event_name']}\n"
                                "Start Date: ${e['start_date']}\n"
                                "End Date: ${e['end_date']}";
                          }).join("\n\n"),
                          type: MessageType.text,
                          timestamp: DateTime.now().toIso8601String(),
                        ),
                      );

                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          _messages.insert(
                            0,
                            ChatMessageTest(
                              sender: 'User',
                              text: upComingEvents.map((e) {
                                return "Event Name: ${e['event_name']}\n"
                                    "Start Date: ${e['start_date']}\n"
                                    "End Date: ${e['end_date']}";
                              }).join(
                                  "\n\n"), // Separate each event with a blank line
                              type: MessageType.text,
                              timestamp: DateTime.now().toIso8601String(),
                            ),
                          );
                        });
                      });

                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          _messages.insert(
                            0,
                            ChatMessageTest(
                              sender: 'Bot',
                              text: respone['message'] ==
                                      "Upcoming or ongoing event programmes retrieved successfully."
                                  ? "आगामी या चल रहे कार्यक्रम सफलतापूर्वक प्राप्त किए गए।"
                                  : "", // Separate each event with a blank line
                              type: MessageType.text,
                              timestamp: DateTime.now().toIso8601String(),
                            ),
                          );
                        });
                        _showPredefinedOptions();
                      });
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      }
    } else {
      print("Error fetching upcoming program list");
    }
  }
}
