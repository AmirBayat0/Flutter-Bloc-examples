import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<Iterable<Person>> getPersons(String url) =>
    HttpClient() // Create instance of HttpClient
        .getUrl(Uri.parse(url)) // call a request
        .then((req) =>
            req.close()) // close the current request and become a response
        .then((response) => response
            .transform(utf8.decoder)
            .join()) // Response Transform to an String
        .then((str) =>
            json.decode(str) as List<dynamic>) // String Transform to a List
        .then((list) => list.map(
            (e) => Person.fromJson(e))); // List Transform to a Person Object

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isCached;

  ///
  const FetchResult({
    required this.persons,
    required this.isCached,
  });

  @override
  String toString() =>
      "Fetch Result ( is Cached = $isCached, persons = $persons )";
}

class PersonsBloc extends Bloc<LoadPersonAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;

      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;
        final result = FetchResult(
          persons: cachedPersons,
          isCached: true,
        );

        emit(result);
      } else {
        final persons = await getPersons(url.urlString);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isCached: false,
        );

        emit(result);
      }
    });
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonAction({required this.url}) : super();
}

enum PersonUrl {
  person1,
  person2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return "http://127.0.0.1:5500/flutter_bloc_example/lib/api/persons1.json";
      case PersonUrl.person2:
        return "http://127.0.0.1:5500/flutter_bloc_example/lib/api/persons2.json";
    }
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class PersonsList extends StatelessWidget {
  const PersonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Persons"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  onPressed: () {
                    final bloc = context.read<PersonsBloc>();
                    bloc.add(const LoadPersonAction(url: PersonUrl.person1));
                  },
                  child: const Text("Load P1")),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  onPressed: () {
                    final bloc = context.read<PersonsBloc>();
                    bloc.add(const LoadPersonAction(url: PersonUrl.person2));
                  },
                  child: const Text("Load P2")),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previous, current) {
            return previous?.persons != current?.persons;
          }, builder: (context, state) {
            final persons = state?.persons;
            if (state == null) {
              return const SizedBox();
            }

            return Expanded(child: ListView.builder(itemBuilder: (ctx, index) {
              final currentPerson = persons![index]!;

              return ListTile(
                title: Text(currentPerson.name),
                
              );
            }));
          })
        ],
      ),
    );
  }
}
