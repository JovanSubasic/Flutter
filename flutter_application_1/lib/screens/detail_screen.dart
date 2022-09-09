import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../detailMovie.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

late Future<DetailMovie> futureDetailMovie;
Future<DetailMovie> fetchDetailMovie() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/550?api_key=97708a3f06b5e8999afe04ec3714a6b0'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return DetailMovie.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load DetailMovie');
  }
}

class _DetailScreenState extends State<DetailScreen> {
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
          title: const Text('Détail du film'),
        ),
        body: FutureBuilder<DetailMovie>(
          future: futureDetailMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;

              return Text(data!.homepage ?? "");
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
