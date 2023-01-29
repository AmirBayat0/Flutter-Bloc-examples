import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../examples/persons_list.dart';
import '../examples/fetch_data.dart';
import '../examples/random_name.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Bloc Example',
        home: BlocProvider(
          create: (BuildContext context) => PersonsBloc(),
          child: const FetchData()
          ,
        ),
      ),
    );
