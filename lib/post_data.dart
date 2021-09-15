import 'dart:convert';

import 'package:api_integration/widgets/post_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'model/post.dart';

class PostData extends StatefulWidget {
  @override
  PostDataState createState() => PostDataState();
}

class PostDataState extends State<PostData> {
  final titleEditingController = TextEditingController();
  final bodyEditingController = TextEditingController();
  Future<Post>? createdPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Post')),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child:
          createdPost == null ?
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
        ElevatedButton(onPressed: () => onSubmit(), child: Text('Submit'))
      ],
    );
  }

  FutureBuilder<Post> buildFutureBuilder() {
    return FutureBuilder<Post>(
      future: createdPost,
      builder: (context, snapshot) {
        print(snapshot.toString());
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        } else if (snapshot.hasData) {
          print(snapshot.data.toString());
          return Center(
            child:Column(children:[ PostDetailWidget(postObj: snapshot.data!,),
            Text('Post Created Successfully',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.green),),]),
          );
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }

  void onSubmit() {
    var title = titleEditingController.text;
    var body = bodyEditingController.text;
    print('Title:${title}\n');
    print('Body:${body}\n');
    if(title.isNotEmpty && body.isNotEmpty) setState(() {
      createdPost = createPost(title,body);
    });
  }
}

Future<Post> createPost(String title, String bodyVal) async {
  final response = await http.post(Uri.parse(
      'https://jsonplaceholder.typicode.com/posts'),
      headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
       body: jsonEncode(<String,dynamic>{

         'title': title,
         'body':bodyVal,
          'userId':1,

       }),
  );
  if(response.statusCode==201){
    return Post.fromJson(jsonDecode(response.body));
  }
  else{
    throw Exception('Failed to create post');
  }
}


