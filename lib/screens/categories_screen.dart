import 'package:flutter/material.dart';
import 'package:todo/screens/home_screen.dart';
class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
{
  _showDialog(BuildContext context)
  {
    return showDialog(context: context, barrierDismissible: true ,builder:(param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            onPressed: (){

            },
            child: Text("Cancel"),

          ),
          FlatButton(
            onPressed: (){

            },
            child: Text("Save"),
          )
        ],
        title: Text("Category form"),content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Category Name",
                hintText: "Write Category Name"
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Category Description",
                  hintText: "Write Category Description"
              ),
            )
          ],
        ),
      ),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          elevation: 0.0,
          color: Colors.red,
          child: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
          }  ,
        ),
        title:Text("Categories SCreen")
        ),
        body: Center(child:Text("Welcome to Categories Screen ")),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _showDialog(context);
        },child: Icon(Icons.add),),
    );
  }
}