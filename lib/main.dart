import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(PhotoGalleryApp());

class PhotoGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Just a normal photo gallery')),
        body: Gallery(),
      ),
    );
  }
}

class Gallery extends StatefulWidget{
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool loading;
  List<String> idPhoto;

  @override
  void initState(){
    loading =true;
    idPhoto = [];

    _loadImageIds();

    super.initState();
  }

  void _loadImageIds() async {
    final response = await http.get('https://picsum.photos/v2/list');
    final json = jsonDecode(response.body);
    List<String> _idPhoto = [];
    for (var image in json){
      _idPhoto.add(image['id']);
    }
    setState(() {
      loading = false;
      idPhoto = _idPhoto;
    });
  }

  @override
  Widget build(BuildContext context){
    if(loading){
      return Center(child: CircularProgressIndicator(),
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) => GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImagePage(idPhoto[index]),
           ),
          );
        },
        child: Image.network('http://picsum.photos/id/${idPhoto[index]}/300/300',
        ),
      ),
      itemCount: idPhoto.length,
    );
  }
}

class ImagePage extends StatelessWidget {
  final String id;
  ImagePage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network('http://picsum.photos/id/$id//600/600',
        ),
      ),
    );
  }
}
