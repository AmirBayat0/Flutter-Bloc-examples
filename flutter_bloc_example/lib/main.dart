import 'package:flutter/material.dart';

import '../examples/fetch_data.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Bloc Example',
        home: FetchData(),
      ),
    );
