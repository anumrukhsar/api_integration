import 'package:api_integration/update_post.dart';
import 'package:flutter/material.dart';

import '../detail_page.dart';
import '../model/post.dart';

class PostWidget extends StatelessWidget {
  final List<Post> posts;

  const PostWidget({required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        posts[index].id.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text(posts[index].title),
                    subtitle: Text(posts[index].body),
                    trailing: IconButton(onPressed:()=>editPost(posts[index].id,context), icon: Icon(Icons.edit),),
                    onTap: () => {
                         onListItemTap(posts[index].id,context),
                        })),
          );
        });
  }
  void onListItemTap(int id,BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailPage(postObjId: id)));
  }
  void editPost(int id,BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdatePost(id:id)));
  }
}
