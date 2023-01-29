import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../examples/fetch_data.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Bloc Example',
        home: FetchData(),
      ),
    );
