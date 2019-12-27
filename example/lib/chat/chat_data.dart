
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';


const String kMyAvatar = 'images/profile.png';
const String kMyName = 'Me';

List<String> _chatDetails = [
  'haha!','hoho~','may i help you?','nice 2 meet you',
  'hello','it is fun','you looks like a joke','lol', 'need 2 go now',
  'dart is good','flutter is good','Nice day! isn`t it?','no',
  'i don`t think so!','are you ok?','nice','you are so funny!',
];
Random random = Random(DateTime.now().millisecondsSinceEpoch);

Map<String, List<ChatDetail>> _cachedChatDetails = {};

class ChatDetail<T> {
  bool current;
  T content;

  ChatDetail(this.content, {this.current: true});

  static List<ChatDetail> getInitChatDetails(String friendName) {
    _cachedChatDetails[friendName] ??= (){
      List<ChatDetail> list = [];
      for(var i = 1; i <= 50; i++) {
        if(random.nextInt(100) < 20) {
          list.add(TimeMessage(DateTime.now()));
        }
        list.add(randomChatDetail(i % 2 == 0));
      }
      return list;
    }();
    return _cachedChatDetails[friendName];
  }

  static ChatDetail randomChatDetail(bool current) {
    int v = random.nextInt(100);
    if (v < 50) {
      return EmojiChatDetail(Emoji(random.nextInt(emojiTotalCount)), current: current);
    }
    return StringChatDetail(_chatDetails[random.nextInt(_chatDetails.length)], current: current);
  }

}

class StringChatDetail extends ChatDetail<String>{

  StringChatDetail(content, {bool current: true,}): super(content, current: current);

}

const emojiTotalCount = 116;
class Emoji {
  int code;
  Emoji(this.code);

  String get file {
    return 'images/emoji/emoji_${code < 10 ? '0' : ''}$code.png';
  }
}


class ImageChatDetail extends ChatDetail<File> {
  ImageChatDetail(File content, {bool current: true,}) : super(content, current: current);
  static File getRandomImageFile(BuildContext context) {
  }
}

class EmojiChatDetail extends ChatDetail<Emoji> {
  EmojiChatDetail(Emoji content, {bool current: true,}) : super(content, current: current);
}

class TimeMessage extends ChatDetail<DateTime> {
  TimeMessage(DateTime content) : super(content);
}