import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upculture/local_database/key_constants.dart';
import 'package:upculture/local_database/my_shared_preference.dart';
import 'package:upculture/model/artist/chatmodal.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/utils/mydatabase.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

// class ChatMessage {
//   final String id;
//   final String text;
//   final String sender;
//   final DateTime timestamp;

//   ChatMessage({
//     required this.id,
//     required this.text,
//     required this.sender,
//     required this.timestamp,
//   });
// }

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _controller = TextEditingController();
//   final _currentUserId =
//       MySharedPreference.getInt(KeyConstants.keyUserId).toString();

//   void _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     final messageId = const Uuid().v4();
//     final senderId =
//         MySharedPreference.getInt(KeyConstants.keyUserId).toString();

//     await FirebaseFirestore.instance.collection('messages').doc(messageId).set({
//       'id': messageId,
//       'text': text.trim(),
//       'sender': senderId,
//       'timestamp': FieldValue.serverTimestamp(),
//       'type': 'text',
//     });

//     _controller.clear();
//   }

//   Widget _buildMessageBubble(ChatMessage message) {
//     final isMe = message.sender == _currentUserId;

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blueAccent : Colors.grey[300],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           message.text,
//           style: TextStyle(color: isMe ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('messages')
//                 .orderBy('timestamp', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 print("Firestore error: ${snapshot.error}");
//                 return Center(child: Text("Error: ${snapshot.error}"));
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 print("Waiting for Firestore connection...");
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 print("No messages found");
//                 return const Center(child: Text("No messages yet"));
//               }

//               final docs = snapshot.data!.docs;

//               return ListView.builder(
//                 reverse: true,
//                 itemCount: docs.length,
//                 itemBuilder: (context, index) {
//                   final data = docs[index].data() as Map<String, dynamic>;

//                   return _buildMessageBubble(ChatMessage(
//                     id: data['id'],
//                     text: data['text'] ?? '',
//                     sender: data['sender'],
//                     timestamp: (data['timestamp'] as Timestamp?)?.toDate() ??
//                         DateTime.now(),
//                   ));
//                 },
//               );
//             },
//           )),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 // GestureDetector(
//                 //     onTap: () {
//                 //       _pickedFile();
//                 //     },
//                 //     child: Icon(Icons.attach_file)),
//                 // SizedBox(
//                 //   width: 10,
//                 // ),
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration:
//                         const InputDecoration(hintText: 'Type a message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.send,
//                     color: Colors.green,
//                   ),
//                   onPressed: () => _sendMessage(_controller.text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickedFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: [
//         'jpg',
//         'jpeg',
//         'png',
//         'mp4',
//         'pdf',
//         'docx',
//         'mp3',
//         'wav'
//       ],
//     );

//     if (result != null && result.files.single.path != null) {
//       final file = File(result.files.single.path!);
//       final fileName = path.basename(file.path);
//       final fileExtension =
//           path.extension(file.path).toLowerCase().replaceAll('.', '');
//       final storageRef = FirebaseStorage.instance.ref('chat_files/$fileName');

//       try {
//         await storageRef.putFile(file);
//         final downloadUrl = await storageRef.getDownloadURL();

//         // Send the file message to Firestore
//         final messageId = const Uuid().v4();

//         await FirebaseFirestore.instance
//             .collection('messages')
//             .doc(messageId)
//             .set({
//           'id': messageId,
//           'sender':
//               MySharedPreference.getInt(KeyConstants.keyIsLogin).toString(),
//           'timestamp': FieldValue.serverTimestamp(),
//           'type': 'file',
//           'fileUrl': downloadUrl,
//           'fileName': fileName,
//           'fileType': fileExtension,
//         });

//         print('File uploaded: $downloadUrl');
//       } catch (e) {
//         print('Upload failed: $e');
//       }
//     }
//   }
// }

class ChatScreenWithSql extends StatefulWidget {
  final String currentUser; // 'admin' or 'artist'
  final String chattingWith; // 'artist' or 'admin'

  const ChatScreenWithSql(
      {required this.currentUser, required this.chattingWith});

  @override
  State<ChatScreenWithSql> createState() => _ChatScreenWithSqlState();
}

class _ChatScreenWithSqlState extends State<ChatScreenWithSql> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _showSuggestions = true;

  void _loadMessages() async {
    final msgs = await ChatDatabase.getMessagesForUsers(
      widget.currentUser,
      widget.chattingWith,
    );

    // If no messages yet, add predefined ones
    if (msgs.isEmpty) {
      final now = DateTime.now();

      // final welcomeMsg = ChatMessage(
      //   id: const Uuid().v4(),
      //   sender: 'admin',
      //   receiver: widget.currentUser,
      //   message: "🎉 Welcome to the artist chat! Feel free to share your work.",
      //   type: 'text',
      //   timestamp: now,
      // );

      final imageMsg = ChatMessage(
        id: const Uuid().v4(),
        sender: 'admin',
        receiver: widget.currentUser,
        message: "Sample artwork", // optional caption
        type: 'image',
        filePath: 'assets/sample.jpg', // <-- Add a sample image in assets
        timestamp: now.add(Duration(seconds: 1)),
      );

      final docMsg = ChatMessage(
        id: const Uuid().v4(),
        sender: 'admin',
        receiver: widget.currentUser,
        message: "📄 Guidelines.pdf",
        type: 'file',
        filePath: 'assets/Guidelines.pdf', // <-- Add a sample doc in assets
        timestamp: now.add(Duration(seconds: 2)),
      );

      // await ChatDatabase.insertMessage(welcomeMsg);
      await ChatDatabase.insertMessage(imageMsg);
      await ChatDatabase.insertMessage(docMsg);
    }

    // Reload from DB
    final updatedMsgs = await ChatDatabase.getMessagesForUsers(
      widget.chattingWith,
      widget.currentUser,
    );

    setState(() {
      _messages = updatedMsgs;
      _showSuggestions = updatedMsgs.isEmpty;
    });

    // Wait for UI to rebuild and scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: const Uuid().v4(),
      sender: widget.currentUser,
      receiver: widget.chattingWith,
      message: text,
      type: 'text',
      timestamp: DateTime.now(),
    );

    await ChatDatabase.insertMessage(newMessage);
    _controller.clear();
    _loadMessages(); // This also triggers scroll
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0, // Since it's reversed, scroll to 0
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickAndSendFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'mp3',
        'wav',
        'pdf',
        'docx',
        'mp4'
      ],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final ext = file.path.split('.').last.toLowerCase();

      String type = 'file';
      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        type = 'image';
      } else if (['mp3', 'wav'].contains(ext)) {
        type = 'audio';
      }

      final newMessage = ChatMessage(
        id: const Uuid().v4(),
        sender: widget.currentUser,
        receiver: widget.chattingWith,
        message: '📎 ${file.path.split('/').last}', // Optional text
        type: type,
        filePath: file.path,
        timestamp: DateTime.now(),
      );

      await ChatDatabase.insertMessage(newMessage);
      _loadMessages();
    }
  }

  final List<String> _predefinedMessages = [
    "hi, we're here to help you",
    "select one of the option given below",
    "Cerficate Enquiry",
    "Program Enquiry",
    "Payment Enquiry",
    "Message to Admin"
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && _showSuggestions) {
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            _showSuggestions = false;
          });
        });
      }
    });
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isMe = msg.sender == widget.currentUser;

    Widget content;
    switch (msg.type) {
      case 'image':
        content = Image.file(
          File(msg.filePath!),
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        );
        break;
      case 'audio':
        content = Row(
          children: [
            const Icon(Icons.audiotrack),
            const SizedBox(width: 8),
            Expanded(child: Text(msg.message)),
          ],
        );
        break;
      case 'file':
        content = Row(
          children: [
            const Icon(Icons.insert_drive_file),
            const SizedBox(width: 8),
            Expanded(child: Text(msg.message)),
          ],
        );
        break;
      default:
        content = Text(
          msg.message,
          style: TextStyle(color: isMe ? Colors.black : Colors.red),
        );
    }

    final messageBubble = Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? MyColor.appColor.withAlpha(20) : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
          ),
        ),
        child: content,
      ),
    );

    if (!isMe) return messageBubble;

    return GestureDetector(
      onLongPress: () => _confirmDelete(msg),
      child: messageBubble,
    );
  }

  void _confirmDelete(ChatMessage msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete message?"),
        content: Text("Do you want to delete this message?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ChatDatabase.deleteMessageById(msg.id);
              _loadMessages();
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEnquiryOption(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: Container(
          // margin: const EdgeInsets.only(left: 10,right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showCertificateForm() {
    final _programNameController = TextEditingController();
    final _programDateController = TextEditingController();
    final _mobileController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Certificate Request",
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
                    labelText: 'Program Name '),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _programDateController,
                decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    labelText: 'Program Date '),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                    labelText: 'Applicant Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Optionally, send these as a message
                _sendMessage("📄 Certificate Enquiry\n\n"
                    "Program: ${_programNameController.text}\n"
                    "Date: ${_programDateController.text}\n"
                    "Mobile: ${_mobileController.text}");
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

  void _showUpcomingPrograms() {
    // For demo, hardcoded date. Replace with actual logic from database if needed.
    String upcomingDate = "15 June 2025";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Upcoming Program"),
        content: Text("Next Program Date: $upcomingDate"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPaymentForm() {
    final _nameController = TextEditingController();
    final _mobileController = TextEditingController();
    final _programNameController = TextEditingController();
    final _queryController = TextEditingController();

    showDialog(
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
                Navigator.pop(context);
                // Optionally, send a message
                _sendMessage("💳 Payment Enquiry\n\n"
                    "Name: ${_nameController.text}\n"
                    "Mobile: ${_mobileController.text}\n"
                    "Program: ${_programNameController.text}\n"
                    "Query: ${_queryController.text}");
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  child: Image.asset(
                    "assets/images/up_gov_logo.png",
                    height: 60,
                    color: Colors.white,
                  ),
                )),
            elevation: 0,
            title: Text("Chat with ${widget.chattingWith}"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Visibility(
                visible: _messages.length > 0 ? false : true,
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      
                      height: 60,
                      decoration: BoxDecoration(
                          // color: Colors.blue.withAlpha(20),
                          color:
                              Color.fromARGB(255, 252, 192, 151).withAlpha(10),
                          boxShadow: [
                            BoxShadow(
                                color: MyColor.appColor.withAlpha(40),
                                
                                offset: Offset(1, 1)),
                            BoxShadow(
                         
                                color: Color.fromARGB(255, 211, 236, 249),
                                offset: Offset(-3, -3))
                          ],
         
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Center(
                        child: Text(_predefinedMessages[0].toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // color: MyColor.appColor
                                color: Color.fromARGB(255, 68, 64, 62))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      height: 60,
                      decoration: BoxDecoration(
                          // color: Colors.blue.withAlpha(20),
                          color:
                              Color.fromARGB(255, 252, 192, 151).withAlpha(10),
                          boxShadow: [
                            BoxShadow(
                                color: MyColor.appColor.withAlpha(40),
                                offset: Offset(1, 1)),
                            BoxShadow(
                                color: Color.fromARGB(255, 211, 236, 249),
                                offset: Offset(-3, -3))
                          ],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Center(
                          child: Text(_predefinedMessages[1].toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 68, 64, 62)))),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      height: 200,
                      decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 252, 192, 151).withAlpha(10),
                          boxShadow: [
                            BoxShadow(
                                color: MyColor.appColor.withAlpha(40),
                                offset: Offset(1, 1)),
                            BoxShadow(
                                color: Color.fromARGB(255, 211, 236, 249),
                                offset: Offset(-3, -3))
                          ],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: _buildEnquiryOption(
                                    "Certificate Enquiry",
                                    () => _showCertificateForm()),
                              ),
                              // const SizedBox(width: 10),
                              Expanded(
                                child: _buildEnquiryOption("Program Enquiry",
                                    () => _showUpcomingPrograms()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: _buildEnquiryOption("Payment Enquiry",
                                    () => _showPaymentForm()),
                              ),
                              // const SizedBox(width: 10),
                              Expanded(
                                child: _buildEnquiryOption(
                                    "Others", () => _sendMessage("")),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 👇 Chat Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    print(index);
                    return _buildMessageBubble(
                      
                      _messages[_messages.length - 1 - index],
                    );
                  },
                ),
              ),

              // 👇 Message Input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: _pickAndSendFile,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30))),
                    )),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _sendMessage(_controller.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
