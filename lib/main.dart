import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_example/blocs/search/search_bloc.dart';
import 'package:search_example/blocs/search_queue/search_queue_bloc.dart';
import 'package:search_example/repository/example_repository.dart';
import 'package:search_example/repository/repository.dart';
import 'package:search_example/screens/home/home_screen.dart';
import 'package:search_example/screens/search/search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final Repository repository = ExampleRepository();

  runApp(BlocProvider(
    create: (context) => SearchBloc(repository: repository),
    child: BlocProvider(
      create: (context) =>
          SearchQueueBloc(searchBloc: BlocProvider.of<SearchBloc>(context)),
      child: SearchApp(),
    ),
  ));
}

class SearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Example',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/search': (_) => SearchScreen(),
      },
    );
  }
}
