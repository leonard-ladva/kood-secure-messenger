import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relay/helpers/src/initials.dart';
import 'package:relay/profile_page/profile_page.dart';
import 'package:relay/user_search/bloc/user_search_bloc.dart';

class UserSearchView extends StatelessWidget {
  const UserSearchView({super.key});

  Widget getBody(UserSearchState state) {
    if (state.status == UserSearchStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state.status == UserSearchStatus.failure) {
      return Center(
        child: Text(state.errorMessage ?? 'Error'),
      );
    }
    return ListView.builder(
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final user = state.results[index];
        return ListTile(
          leading: CircleAvatar(
            foregroundImage:
                user.photo == null ? null : CachedNetworkImageProvider(user.photo!),
            backgroundColor: Color(0xFFb8e986),
            child: Text(
              initials(
                user.name ?? '',
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF528617),
              ),
            ),
          ),
          title: Text(user.name ?? ''),
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProfilePage(state.results[index].id),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSearchBloc, UserSearchState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            toolbarHeight: 100,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.grey[700],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding: const EdgeInsets.all(0),
                        border: InputBorder.none,
                      ),
                      onChanged: (query) => context
                          .read<UserSearchBloc>()
                          .add(QueryChanged(query)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: getBody(state),
        );
      },
    );
  }
}
