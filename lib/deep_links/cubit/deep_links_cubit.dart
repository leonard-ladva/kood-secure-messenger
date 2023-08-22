import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relay/profile_page/view/profile_page.dart';
import 'package:uni_links/uni_links.dart';

part 'deep_links_state.dart';

class DeepLinksCubit extends Cubit<DeepLinksState> {
  DeepLinksCubit() : super(DeepLinksState.initial());

  late final StreamSubscription _deepLinkSubscription;

  void init() {
    _initUniLinks();
  }

  Future<void> _handleInitial() async {
    try {
      final initialLink = await getInitialUri();
      _handleIncomingLink(initialLink);
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  Future<void> _handleIncomingLink(Uri? uri) async {
    if (uri == null) return;
    final profileRouteRegex = RegExp(r'\/user\/(?<userId>[a-zA-Z0-9]{28}$)');

    final profileRouteMatch = profileRouteRegex.firstMatch(uri.path);
    if (profileRouteMatch != null) {
      final userId = profileRouteMatch.namedGroup('userId');
      emit(
        DeepLinksState.newLinkReceived(ProfilePage(userId ?? '')),
      );
      emit(DeepLinksState.initial());
    }
  }

  Future<void> _initUniLinks() async {
    _handleInitial();
    // Attach a listener to the stream
    _deepLinkSubscription = uriLinkStream.listen((Uri? uri) {
      _handleIncomingLink(uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  @override
  Future<void> close() {
    _deepLinkSubscription.cancel();
    return super.close();
  }
}
