import 'package:api_integration/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetailWidget extends StatelessWidget{
  final Post postObj;
  const PostDetailWidget({required this.postObj});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SubItemWidget(label: 'Id',val:postObj.id.toString()),
            SizedBox(height: 10,),
            SubItemWidget(label: 'Title',val:postObj.title),
            SizedBox(height: 10,),
            SubItemWidget(label: 'Body',val:postObj.body),

          ],
        ),
      ),
    );
  }

}

class SubItemWidget extends StatelessWidget{
  final label;
  final val;
  const SubItemWidget({this.label,this.val});
  @override
  Widget build(BuildContext context) {
   return  Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Expanded(flex:2,child: Text(
         '$label:',
         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
       ),),
       Expanded(flex:8,child: Text(
         val,
         style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
       ),),
     ],
   );
  }
}