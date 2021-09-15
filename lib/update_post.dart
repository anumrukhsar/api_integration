import 'dart:convert';

import 'package:api_integration/widgets/post_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/post.dart';

class UpdatePost extends StatefulWidget{
  final id;
  const UpdatePost({this.id});
  @override
  State<UpdatePost> createState() {
    return UpdatePostState(id:id);
  }
}

class UpdatePostState extends State<UpdatePost>{
  final id;
  var titleEditingController = TextEditingController();
  var bodyEditingController = TextEditingController();
  Future<Post>? editedPost;
  UpdatePostState({this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Post'),),
      body:Container(
        padding: EdgeInsets.all(20.0),
        child:
        editedPost == null ?
        buildForm() : buildFutureBuilder(),
      ));
  }
  Column buildForm() {
    return Column(
      children: [
        TextFormField(
          controller: titleEditingController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 1,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            icon: Icon(Icons.title),
            hintText: 'Title',
            labelText: 'Title',
          ),

          validator: (String? value) {
            return (value != null && value.length < 2)
                ? 'Title must be 3 or more chars long'
                : null;
          },
        ),
        TextFormField(
          controller: bodyEditingController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 1,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            icon: Icon(Icons.description),
            hintText: 'Body',
            labelText: 'Body',
          ),

          validator: (String? value) {
            return (value != null && value.length < 2)
                ? 'Body must be 20 or more chars long'
                : null;
          },
        ),
        ElevatedButton(onPressed: () => onUpdate(), child: Text('Update'))
      ],
    );
  }

  FutureBuilder<Post> buildFutureBuilder() {
    return FutureBuilder<Post>(
      future: editedPost,
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        } else if (snapshot.hasData) {
          print(snapshot.data.toString());
          return Center(
            child:Column(children:[ PostDetailWidget(postObj: snapshot.data!,),
              Text('Post Updated Successfully',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.green),),]),
          );
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }

  void onUpdate() {
    var title = titleEditingController.text;
    var body = bodyEditingController.text;
    print('Title:${title}\n');
    print('Body:${body}\n');
    if(title.isNotEmpty && body.isNotEmpty) setState(() {
      editedPost = updatePost(title,body,id);
    });
  }
}

Future<Post> updatePost(String title, String bodyVal,int id) async {
  final response = await http.put(Uri.parse(
      'https://jsonplaceholder.typicode.com/posts/$id'),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String,dynamic>{

      'title': title,
      'body':bodyVal,
      'userId':101,

    }),
  );
  if(response.statusCode==200){
    return Post.fromJson(jsonDecode(response.body));
  }
  else{
    throw Exception('Failed to create post');
  }
}
