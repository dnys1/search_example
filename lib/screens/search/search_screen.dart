import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_example/blocs/search/search_bloc.dart';
import 'package:search_example/screens/search/search_body.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        if (state is SearchInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchSuccess) {
          return SearchBody();
        } else if (state is SearchFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(state.message),
          );
        } else {
          throw StateError('Unknown state: $state');
        }
      }),
    );
  }
}
