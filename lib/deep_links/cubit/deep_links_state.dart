part of 'deep_links_cubit.dart';

enum DeepLinksStatus {
  initial,
  newLinkReceived,
}

final class DeepLinksState extends Equatable {
  const DeepLinksState._(
      {required this.status, this.destination,});

  final Widget? destination;
  final DeepLinksStatus status;

  const DeepLinksState.initial() : this._(
    status: DeepLinksStatus.initial,
  );
  const DeepLinksState.newLinkReceived(Widget destination)
      : this._(
          status: DeepLinksStatus.newLinkReceived,
          destination: destination,
        );


  @override
  List<Object?> get props => [status, destination];
}
