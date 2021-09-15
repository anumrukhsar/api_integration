import 'dart:convert';

import 'package:api_integration/post_data.dart';
import 'package:api_integration/widgets/post_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model/post.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Api Integration Demo',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Api Integration'),actions: [
          IconButton(onPressed: ()=>onCreatePost(context), icon: Icon(Icons.add))
        ],),
        body: FutureBuilder<List<Post>>(
            future: fetchPosts(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              } else if (snapshot.hasData) {
                print(snapshot.data.toString());
                return Container(
                  child: PostWidget(posts: snapshot.data!)
                );
              } else {
                return Center(child: const CircularProgressIndicator());
              }
            }));
  }
}

Future<List<Post>> fetchPosts(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  return compute(parsePosts, response.body);
}

// Cast Response to Object
List<Post> parsePosts(String responseBody) {
  final parseVal = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parseVal.map<Post>((json) => Post.fromJson(json)).toList();
}

//CreatePost
void onCreatePost(BuildContext context){
Navigator.push(context, MaterialPageRoute(builder: (context)=>PostData()));
}
