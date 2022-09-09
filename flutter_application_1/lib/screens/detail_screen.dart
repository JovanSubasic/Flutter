import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../detailMovie.dart';
import 'home_screen.dart';

class DetailScreen extends StatefulWidget {
  final String value;
  const DetailScreen({super.key, required this.value});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<DetailMovie> futureDetailMovie;
  Future<DetailMovie> fetchDetailMovie() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.value}?api_key=97708a3f06b5e8999afe04ec3714a6b0'));

    if (response.statusCode == 200) {
      return DetailMovie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load DetailMovie');
    }
  }

  @override
  void initState() {
    super.initState();
    futureDetailMovie = fetchDetailMovie();
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Détail du film'),
  //     ),
  //     body: Center(
  //         // child: ElevatedButton(
  //         //   onPressed: () {
  //         //     Navigator.pop(context);
  //         //   },
  //         //   child: const Text('Go back!'),
  //         // ),
  //         ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // ${widget.value}
          title: const Text('Détail du film '),
        ),
        body: FutureBuilder<DetailMovie>(
          future: futureDetailMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;

              // calcul des heures
              final heure = (data!.runtime ?? 0) ~/ 60;

              // calcul des minutes
              final minute = (data.runtime ?? 0) - (heure * 60);

              // synopsis
              final synopsis = data.overview ?? "";

              return Scaffold(
                body: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          padding: const EdgeInsets.all(40.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(58, 66, 86, .9)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 10.0),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    data.originalTitle ?? "",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 45.0),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                Align(
                                    alignment: Alignment.center,
                                    child: Image(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${(data.posterPath)}'),
                                        width: 130)),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\n ${data.releaseDate} - $heure H $minute min',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8.0,
                          top: 60.0,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            },
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Container(
                      // height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      // color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Synopsis :",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '\n $synopsis  ',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
