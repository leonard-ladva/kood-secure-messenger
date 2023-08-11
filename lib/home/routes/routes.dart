import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:relay/messaging/view/chats_list_page.dart';
import 'package:relay/profile/bloc/profile_bloc.dart';
import 'package:relay/profile/view/profile_setup_page.dart';

Page<void> errorPage() => const MaterialPage<void>(
      child: Center(
        child: Icon(
          Icons.error,
          size: 100,
        ),
      ),
    );

List<Page<dynamic>> onGenerateHomeViewPages(
  ProfileStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case ProfileStatus.uncompleted:
      return [ProfileSetupPage.page()];
    case ProfileStatus.completed:
      return [ChatsListPage.page()];
    case ProfileStatus.failure:
      return [errorPage()];
  }
}
