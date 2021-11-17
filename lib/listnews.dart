import 'package:flutter/material.dart';
import 'package:layout/News.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert' ;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_words/english_words.dart';


void main(){
  runApp(NewsApp());
}
class NewsApp extends StatelessWidget {
  const NewsApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:ListNews()
    );
  }
}
class ListNews extends StatefulWidget {
  const ListNews({ Key? key }) : super(key: key);

  @override
  _ListNewsState createState() => _ListNewsState();
}

class _ListNewsState extends State<ListNews> {
  var words=generateWordPairs().take(20);
  var image=[
    "https://imgproxy.k7.tinhte.vn/nvkNY5ZzYUOJD0nigWttUNGDX4LjBOuEVevSmlw9qkw/h:232/plain/https://photo2.tinhte.vn/data/attachment-files/2020/09/5151463_og.jpg",
    "https://imgproxy.k7.tinhte.vn/ZTBNYuwEoiWvy3eb_Qe_4DuPkw_9QuaseRcab0kKcb8/h:232/plain/https://photo2.tinhte.vn/data/attachment-files/2021/08/5577318_og.jpg",
    "https://imgproxy.k7.tinhte.vn/NhBDE9RTDdIv5hpJpfSTkehHlOi7CJIay4DMhXqzpD4/h:232/plain/https://s3.cloud.cmctelecom.vn/tinhte1/2018/10/4455874_og.jpg",
    "https://imgproxy.k7.tinhte.vn/NuY9dVtcoVAtZv1Y4L1vTybIfOAnXVBlqA85BVonFcM/h:232/plain/https://s3.cloud.cmctelecom.vn/tinhte2/2019/09/4778103_og.jpg",
    "https://imgproxy.k7.tinhte.vn/obB-j_U4vH-9eOc49y9PriucPDsKzvZ3-FaD2TvdDRM/h:232/plain/https://photo2.tinhte.vn/data/attachment-files/2021/10/5669644_og.jpg",
    "https://imgproxy.k7.tinhte.vn/gSN6MTTYjb3gIps9dY5q1xMAYZOe8-H-NfXJBPQKOK4/h:232/plain/https://s3.cloud.cmctelecom.vn/tinhte1/2018/10/4454564_og.jpg",
    "https://imgproxy.k7.tinhte.vn/DhEF9bkA1mxb-t2jBKjRWHkjprR8Cl77-1prGH_iwu0/h:232/plain/https://s3.cloud.cmctelecom.vn/tinhte2/2019/03/4582338_og.jpg",
    "https://imgproxy.k7.tinhte.vn/iZElKwsyTKhHohGB47C6YyOoi_irVJG2ZWZtJQMAsos/h:232/plain/https://s3.cloud.cmctelecom.vn/tinhte2/2019/02/4569506_og.jpg"
    ];
   late Future<News> ns ;
   Future<News> fetchData() async {
     String url = "https://newsapi.org/v2/everything?domains=tinhte.vn&apiKey=e7f944b2666a493a807df7cb39ebee92";

     var response = await http.get(Uri.parse(url));
     if (response.statusCode == 200) {
       var jsonData = json.decode(response.body);
       print(jsonData);
       return News.fromJson(jsonData);
     } else {
       return throw Exception('fail');
     }
   }

  @override
  void initState() {
    ns = fetchData();
    print("ns = ${ns}");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: Icon(Icons.message,color: Colors.white,),
        title: Text("Tinh Tế News",style: TextStyle(color: Colors.white))
      ),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
                width: 1000,
                child: CarouselSlider(
                  items: image.map((e) =>  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Stack(
                    children: [
                      //SizedBox(
                        //width: 1000,
                        //height: 90,
                        //child: OutlinedButton(
                            //onPressed: (){},
                            //style: ButtonStyle(
                              //shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                            //),
                            //child: Text(e.asString.toUpperCase(),style: TextStyle(fontSize: 25),)
                          //),
                      //),
                      SizedBox(
                        
                        child: Image.network(e)
                      )
                    ],
                  ),
                  )).toList(),
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    viewportFraction: 0.5,
                  ),

                ),
              ),
          ),
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: ns,
              builder: (BuildContext context,AsyncSnapshot<News> snapshot){
                if(snapshot.hasData){
                  var data=snapshot.data;
                  News n=data!;
                  return ListView.builder(
                    itemCount: n.articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      Article a=n.articles[index];
                      return ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(a.urlToImage),
                            InkWell(
                              child: new Text(a.title,style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold,)),
                              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => view(url: a.url)));},
                            ),
                            Text(a.description,style: TextStyle(color: Colors.black,fontSize: 20),)
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  print("ko co data");
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class view extends StatelessWidget {
  const view({Key? key,required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

