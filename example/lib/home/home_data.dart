
List<Message> _messages;

class Message {
  String avatar;
  String title;
  String subTitle;
  DateTime time;
  Message(this.avatar,this.title,this.subTitle,this.time,);

  static List<Message> getMessages() {
    _messages ??= List.generate(50, (i) => Message("images/avatar/avatar_${i % 20 + 1}.jpg", "My Friend-${i + 1}", "Message ${i + 1}", DateTime.now()));
    return _messages;
  }
}

class GroupMessage {
  List<Message> messages;
  GroupMessage(this.messages);
}

List<BannerItem> _bannerItems;

class BannerItem {
  String avatar;
  String title;

  BannerItem(this.avatar, this.title);

  static List<BannerItem> getBannerItems() {
    _bannerItems ??= List.generate(5, (i) => BannerItem("images/avatar/avatar_${i + 1}.jpg", "My Friend-${i + 1}"));
    return _bannerItems;
  }
}

