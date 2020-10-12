import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/Pokemon.dart';
import 'dart:convert';

import 'package:pokemon_app/pokemondetail.dart';

void main() => runApp(
      MaterialApp(
        title: "Poke App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: HomePage(),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  PokeHUB pokeHUB;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    http.Response res = await http.get(url);
    var decodedValue = jsonDecode(res.body);
    pokeHUB = PokeHUB.fromJson(decodedValue);
    print(pokeHUB);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Poke App'),
      ),
      drawer: Drawer(),
      body: pokeHUB == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokeHUB.pokemon
                  .map((Pokemon poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokeDetail(
                                  pokemon: poke,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Hero(
                                  tag: poke.img,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(poke.img))),
                                  ),
                                ),
                                Text(
                                  poke.name,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}
