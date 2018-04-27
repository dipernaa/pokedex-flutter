import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pokemon {
  final String name;
  final String url;

  Pokemon({ this.name, this.url });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return new Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pokedex 3000',
      theme: new ThemeData(
        primaryColor: Colors.orange,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Pokedex 3000'),
        ),
        body: new FutureBuilder<Iterable<Pokemon>>(
          future: _fetchPokedex(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final pokemonTiles = snapshot.data.map(
                (currentPokemon) {
                  return new ListTile(
                    title: new Text(capitalizeName(currentPokemon.name)),
                  );
                },
              );

              final divided = ListTile
                .divideTiles(
                  context: context,
                  tiles: pokemonTiles,
                )
                .toList();

              return new ListView(children: divided,);
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return new CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<Iterable<Pokemon>> _fetchPokedex() async {
    final response = await http.get('http://pokeapi.co/api/v2/pokemon/?limit=151');
    final responseJson = json.decode(response.body);

    final pokemonList = (responseJson['results'] as List).map((currentPokemon) => (
      new Pokemon.fromJson(currentPokemon)
    ));

    return pokemonList;
  }

  String capitalizeName(String name) {
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }
}
