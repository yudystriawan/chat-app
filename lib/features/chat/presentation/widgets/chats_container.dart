import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_bubble.dart';

class ChatsContainer extends StatelessWidget {
  const ChatsContainer({
    Key? key,
    required this.chats,
  }) : super(key: key);

  final List<ChatBubble> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      reverse: true,
      itemCount: chats.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 12.w);
      },
      itemBuilder: (BuildContext context, int index) {
        return chats[index];
      },
    );
  }
}
