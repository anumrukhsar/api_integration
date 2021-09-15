import 'dart:convert';

import 'package:api_integration/widgets/post_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/post.dart';
class DetailPage extends StatefulWidget{
  final postObjId;
  const DetailPage({ this.postObjId});
  @override
  DetailPageState createState() => DetailPageState(postObjId: postObjId);

}
class DetailPageState extends State<DetailPage> {
  final postObjId;
  DetailPageState({ this.postObjId});
 var postObj;




  Future<Post> fetchPostData(int id) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

    if (response.statusCode == 200) {

      return parsePostObj(response.body);
    } else {

      throw Exception('Failed to load post');
    }
  }

Post parsePostObj(String responseBody){
    final parseData = jsonDecode(responseBody);
    return Post.fromJson(parseData);

}

@override
  void initState() {
    super.initState();
    postObj= fetchPostData(postObjId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Detail')),
      body:
      FutureBuilder<Post>(
        future: postObj,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Something went wrong'));
          }
          else if(snapshot.hasData){
            print(snapshot.data);
            return PostDetailWidget(postObj:snapshot.data!);

          }
          else{
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
