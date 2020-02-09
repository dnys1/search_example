import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_example/blocs/search/search_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          child: TextField(
            onSubmitted: (String query) {
              BlocProvider.of<SearchBloc>(context).add(SearchStarted(query));
              Navigator.of(context).pushNamed('/search');
            },
            decoration: InputDecoration(
              labelText: 'Search',
            ),
          ),
        ),
      ),
    );
  }
}
