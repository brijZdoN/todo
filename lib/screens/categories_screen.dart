import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/services/category_service.dart';
class CategoriesScreen extends StatefulWidget {

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
{
  var _categoryName=TextEditingController();
  var _categoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  List<Category> _categoryList = List<Category>();

  @override
  void initState()
  {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.forEach((category)
    {

      setState(() {
        var model = Category();
        model.name = category['name'];
        _categoryList.add(model);
      });



    });
  }
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
            onPressed: () async {
             _category.name = _categoryName.text;
             _category.description = _categoryDescription.text;
            var result = await _categoryService.saveCategory(_category);
            print(result);

             },

            child: Text("Save"),
          )
        ],
        title: Text("Category form"),content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _categoryName,
              decoration: InputDecoration(
                labelText: "Category Name",
                hintText: "Write Category Name"
              ),
            ),
            TextField(
              controller: _categoryDescription,
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
        title:Text("Categories Screen")
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: List.generate(_categoryList.length, (index){
            return Column(
                children: <Widget>[
                  Card(child:ListTile(
                    leading: IconButton(icon: Icon(Icons.edit), onPressed: (){}),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_categoryList[index].name),
                        IconButton(icon: Icon(Icons.delete),onPressed: (){},)
                      ],
                    ),))
                ],
            );
          } ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _showDialog(context);
        },child: Icon(Icons.add),),
    );
  }
}