
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'chat_data.dart';

class InputState with ChangeNotifier {
  var inputType = inputTypeNone;
  var resizeToAvoidBottomPadding = false;

  void showInputForm(int type) {
    if(inputType == type) return;
    inputType = type;
    if(type == inputTypeWord) {
      Future.delayed(Duration(milliseconds: 100), () {
        resizeToAvoidBottomPadding = true;
        notifyListeners();
      });
    } else {
      resizeToAvoidBottomPadding = false;
    }
    notifyListeners();
  }
}

const inputTypeNone = 0;
const inputTypeWord = 1;
const inputTypeEmoji = 2;
const inputTypeImage = 3;

class InputBlock extends StatefulWidget {

  final Function addChatDetail;

  InputBlock(this.addChatDetail);

  @override
  State<StatefulWidget> createState() => InputBlockState();

}


class InputBlockState extends State<InputBlock> {

  var _textEditingController = TextEditingController();
  FocusNode _focus = FocusNode();
  double inputFormHeight = 0;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if(_focus.hasFocus) {
        showInputForm(inputTypeWord);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focus?.unfocus();
    _focus?.dispose();
    _textEditingController?.dispose();
  }

  void showInputForm(int type) {
    var inputState = Provider.of<InputState>(context);
    if(inputState.inputType == type) return;
    Provider.of<InputState>(context).showInputForm(type);
    if(type != inputTypeWord) {
      _focus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<InputState>(context).addListener(() {
      if(Provider.of<InputState>(context).inputType != inputTypeWord) {
        _focus.unfocus();
      }
    });
    if(inputFormHeight == 0) {
      var height = MediaQuery.of(context).viewInsets.bottom;
      inputFormHeight = height > 0 ? height : 302;
    }
    return Column(
      children: <Widget>[
        buildDefaultInputForm(context),
        Offstage(
          offstage: Provider.of<InputState>(context).inputType != inputTypeWord || Provider.of<InputState>(context).resizeToAvoidBottomPadding,
          child: Container(
            height: inputFormHeight,
          ),
        ),
        buildEmojiInputForm(),
        buildImageInputForm(),
      ],
    );
  }

  Offstage buildImageInputForm() {
    void getImage(ImageSource source) {
      ImagePicker.pickImage(source: source, imageQuality: 75).then((file) {
        if(file == null) return;
        widget.addChatDetail(TimeMessage(DateTime.now()));
        widget.addChatDetail(ImageChatDetail(file));
      });
    }

    return Offstage(
      offstage: Provider.of<InputState>(context).inputType != inputTypeImage,
      child: Container(
        color: Colors.grey[100],
        height: inputFormHeight,
        child: Container(
          padding: EdgeInsets.all(30),
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
            ),
            children: <Widget>[
              InkWell(
                onTap: (){
                  getImage(ImageSource.gallery);
                },
                child: Column(
                  children: <Widget>[
                    Image.asset("images/icon_pic.png", width: 50, height: 50,),
                    Text('Gallery', style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  getImage(ImageSource.camera);
                },
                child: Column(
                  children: <Widget>[
                    Image.asset("images/icon_camera.png", width: 50, height: 50,),
                    Text('Camera', style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Offstage buildEmojiInputForm() {
    return Offstage(
      offstage: Provider.of<InputState>(context).inputType != inputTypeEmoji,
      child: Container(
        color: Colors.grey[100],
        height: inputFormHeight,
        child: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 32,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Container(
                child: InkWell(
                  onTap: (){
                    widget.addChatDetail(EmojiChatDetail(Emoji(index + 1)));
                  },
                  child: Image.asset((Emoji(index + 1).file)),
                ),
              );
            },
            itemCount: 115,
          ),
        ),
      ),
    );
  }

  Widget buildDefaultInputForm(BuildContext context) {
    var sendInput = () {
      var value = _textEditingController?.text?.trim();
      if(value == null || value == '') return;
      _textEditingController.clear();
      widget.addChatDetail(StringChatDetail(value));
      FocusScope.of(context).requestFocus(_focus);
    };
    return Container(
      color: Colors.grey[100],
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow( color: Colors.black45, blurRadius: 5),
                  ]
              ),
              margin: EdgeInsets.all(10),
              child: TextField(
                focusNode: _focus,
                controller: _textEditingController,
                decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
                onSubmitted: (v){
                  sendInput();
                },
              ),
            ),
          ),
          buildIcon(Icon(Icons.insert_emoticon), (){
            showInputForm(inputTypeEmoji);
          }),
          Offstage(
            offstage: Provider.of<InputState>(context).inputType != inputTypeWord,
            child: buildIcon(Icon(Icons.send, color: Colors.white), sendInput, Colors.green),
          ),
          Offstage(
            offstage: Provider.of<InputState>(context).inputType == inputTypeWord,
            child: buildIcon(Icon(Icons.add), () => showInputForm(inputTypeImage)),
          ),
        ],
      ),
    );
  }

  Widget buildIcon(Widget icon, Function onTap, [Color color = Colors.white]) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow( color: Colors.black45, blurRadius: 5),
            ]
        ),
        child: icon,
      ),
    );
  }
}