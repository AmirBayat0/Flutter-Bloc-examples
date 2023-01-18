import 'package:flutter/material.dart';

import '../examples/random_name.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Bloc Example',
        home: RandomName(),
      ),
    );
