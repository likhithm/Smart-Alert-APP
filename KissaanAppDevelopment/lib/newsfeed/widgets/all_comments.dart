import 'package:flutter/material.dart';
import 'package:kissaan_flutter/locale/locales.dart';
import 'package:kissaan_flutter/newsfeed/model_classes/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllComments extends StatefulWidget {

  final Post post;
  final String postID;
  final String userName;
  final String userID;
  final List<Map<dynamic, dynamic>> comments;

  AllComments(this.post, this.postID, this.userName, this.userID)
      : comments = post.comments;

  @override
  State<StatefulWidget> createState() {
    return _AllCommentsState();
  }
}

class _AllCommentsState extends State<AllComments> {
  TextEditingController txtController = new TextEditingController();
  bool isPosting = false, isReply = false;
  String receiveUser = '';
  FocusNode focusNode;
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    focusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    txtController.dispose();
    focusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 15.0),
        child: Column(
          children: <Widget>[
            getCommentsSpan(context),
            _buildCommentField(context)
          ],
        )
    );
  }

  Widget getCommentsSpan(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: (widget.post.comments.length > 2
            ? 2 
            : widget.post.comments.length
          )
              * MediaQuery.of(context).size.height*0.122
      ),
      child: ListView.builder(physics: AlwaysScrollableScrollPhysics(),
        controller: controller,
        itemCount: widget.comments.length,
        itemBuilder: (context, i) {
          Map<String, String> currentComment = Map<String, String>.from(widget.comments[i]);

          String title = currentComment['userName'] + 
            (currentComment['reply'] != null
              ? '@' + currentComment['reply'] 
              : ''
            );

            return InkWell(
              onTap: () {
                _reply(currentComment['userName']);
              },
              child: Container(
                padding: const EdgeInsets.all(0.0),
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 10.0),
                decoration: BoxDecoration (
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Color(0xffdad0ce)
                ),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(
                    currentComment['message'] + '\n',
                    style: const TextStyle(
                      fontSize: 14.0
                    ),
                  ),
                ),
              )
            );

        },
      ),
    );
    
  }

  void _reply(String userName) {
    setState(() {
      txtController.text = AppLocalizations.of(context).reply +' ' + userName + ": ";
      FocusScope.of(context).requestFocus(focusNode);
      isReply = true;
      receiveUser = userName;
    });
  }

  Widget _buildCommentField(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
            constraints: BoxConstraints(maxWidth: 2 * width/3.3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
               borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context).enterComments,
              ),
              
              controller: txtController,
            ),
            
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              size: 25.0,
              color: Colors.blue
            ),
            onPressed: _postComment
          )
        ],
      ),
    );
  }

  void _postComment() async{
    if(isPosting)
      return;
    else
      isPosting = false;
    DocumentReference ref = Firestore.instance
        .collection('posts')
        .document(widget.postID);
    Map<String, List<Map<dynamic, dynamic>>> resData = Map();
    List<Map<dynamic, dynamic>> updateMap = widget.post.comments;
    Map<String, String> data = new Map();
    data.putIfAbsent('userName', ()=>widget.userName);
    data.putIfAbsent('userID', ()=>widget.userID);
    data.putIfAbsent('message', (){
      String retStr = txtController.text.toString();
      if(isReply)
        retStr = retStr.substring(7 + receiveUser.length, retStr.length);
      return retStr;
    });
    if(isReply) {
      data.putIfAbsent('reply', () => receiveUser);
      isReply = false;
    }
    updateMap.add(data);

    resData.putIfAbsent('comments', ()=>updateMap);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(ref);
      if (postSnapshot.exists) {
        await tx.update(ref, <String, dynamic>{'comments': updateMap}).then((result) {
          setState(() {
            isPosting = false;
            txtController.text = '';
          });
        });
      }
    });
  }

}