import 'package:flutter/material.dart';
import 'package:gif_cek/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'build_gif.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //DEĞİŞKENLER
  String gifSubject = "welcome"; // API den çekilecek giflerin konusu
  final gifUrls = []; //API den gelen giflerin urlleri
  List<Widget> allGif = []; //Gifleri gösterecek widgetlerın saklandığı map
  var parsedResponse;
  final myController = TextEditingController();
  GifModel? gifModel;

  Future<void> getGif() async {
    final url = Uri.parse(
        'https://g.tenor.com/v1/search?q=${gifSubject}&key=LIVDSRZULELA&limit=8');
    var response = await http.get(url);
    parsedResponse = jsonDecode(response.body);
    gifModel = GifModel.fromJson(parsedResponse);
    setState(() {
      gifUrls.clear();
      allGif.clear();
      for (int i = 0; i < 8; i++) {
        /*gifUrls.add(parsedResponse['results'][i]['media'][0]['gif']['url']);
        allGif.add(Gif(gifUrls[i]));*/

        gifUrls.add(gifModel?.results![i]['media'][0]['gif']['url']);
        allGif.add(Gif(gifUrls[i]));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getGif(); // Program ilk açıldığında kullanıcının aratmasına gerek kalmadan istek gönderiliyor.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(color: Colors.white),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                fillColor: Colors.green[400],
                filled: true,
                hintText: 'Gif Konusunu Aratın',
              ),
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  gifSubject = myController.text;
                  gifUrls.clear();
                  allGif.clear();
                });
                getGif();
              },
              icon: Icon(Icons.search)),
        ],
      ),
      body: Container(
        child: ListView(
          children: allGif.length <= 6
              ? [Center(child: CircularProgressIndicator())]
              : allGif,
        ),
      ),
    );
  }
}
