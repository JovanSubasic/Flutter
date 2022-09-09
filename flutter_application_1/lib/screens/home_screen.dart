import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_alternance/screens/detail_screen.dart';
import 'package:http/http.dart' as http;

import '../listMovie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

late Future<listMovie> futurelistMovie;
Future<listMovie> fetchlistMovie() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/list/1?api_key=97708a3f06b5e8999afe04ec3714a6b0&language=en-US'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return listMovie.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load listMovie');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    futurelistMovie = fetchlistMovie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<listMovie>(
          future: futurelistMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // list des items
              final dataList = snapshot.data!.items;

              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: dataList!.length.clamp(0, 10),
                itemBuilder: (BuildContext context, int index) {
                  // return Container(
                  //   height: 50,
                  //   // color: Colors.amber[colorCodes[index]],
                  //   child: Center(child: Text('Entry ${dataList[index].title}')),
                  // );
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DetailScreen()));
                        },
                        // onTap: widget.onPressed,
                        child: Stack(children: [
                          Container(
                            height: 200,
                            // width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Image(
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500${(dataList[index].posterPath)}'),
                                            width: 130)
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 50,
                                    // ),
                                    // Container(
                                    //   color: Colors.grey,
                                    //   height: 40,
                                    //   width: 1.5,
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${dataList[index].title}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${dataList[index].releaseDate}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${dataList[index].overview}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
