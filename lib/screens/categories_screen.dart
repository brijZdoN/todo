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

  var _editCategoryName = TextEditingController();
  var _editCategoryDescription = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    getAllCategories();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.forEach((category)
    {

      setState(() {
        var model = Category();
        model.name = category['name'];
        model.description = category['description'];
        model.id = category['id'];
        _categoryList.add(model);
      });



    });
  }
  _showFormInDialog(BuildContext context)
  {
    return showDialog(context: context, barrierDismissible: true ,builder:(param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            onPressed: (){
                Navigator.pop(context);
            },
            child: Text("Cancel"),

          ),
          FlatButton(
            onPressed: () async {
             _category.name = _categoryName.text;
             _category.description = _categoryDescription.text;
            var result = await _categoryService.saveCategory(_category);
            if(result>0)
              {
                _categoryList.clear();
                getAllCategories();
                Navigator.pop(context);

              }


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
  _editFormInDialog(BuildContext context) {
    return showDialog(
        context: context, barrierDismissible: true, builder: (param) {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),

          ),
          FlatButton(
            onPressed: () async {
              _category.name = _categoryName.text;
              _category.description = _categoryDescription.text;
              var result = await _categoryService.saveCategory(_category);
              if(result>0)
                {
                  Navigator.pop(context);
                  _showSnackBarMessage(Text("Successfully Updated"));

                }
            },

            child: Text("Update"),
          )
        ],
        title: Text("Category Edit form"), content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _editCategoryName,
              decoration: InputDecoration(
                  labelText: "Category Name",
                  hintText: "Write Category Name"
              ),
            ),
            TextField(
              controller: _editCategoryDescription,
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
  _editCategory(BuildContext context ,categoryId) async {
    var category = await _categoryService.getCategoryById(categoryId);
    setState(() {
      _editCategoryName.text = category[0]['name'];
      _editCategoryDescription.text = category[0]['description'];
    });
    _editFormInDialog(context);
  }
  //snackBar on successfully update message
  _showSnackBarMessage(message)
  {
    var _snackBar = SnackBar(
      content: message,
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(_snackBar);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: RaisedButton(
          elevation: 0.0,
          color: Colors.red,
          child: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
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
                    leading: IconButton(icon: Icon(Icons.edit), onPressed: (){
                      _editCategory(context, _categoryList[index].id);
                    }),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_categoryList[index].name),
                        IconButton(icon: Icon(Icons.delete),onPressed:
                            ()
                        {
                          _categoryList.removeAt(index);

                        },)
                      ],
                    ),))
                ],
            );
          } ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _showFormInDialog(context);
        },child: Icon(Icons.add),),
    );
  }
}