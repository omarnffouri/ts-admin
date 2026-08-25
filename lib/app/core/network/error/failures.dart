import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? title;
  final String message;
  final int? code;
  const Failure({required this.message, this.title, this.code});
  @override
  List<Object?> get props => [message, title, code];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(
      {required super.message, required String super.title, super.code});
}

class OfflineFailure extends Failure {
  const OfflineFailure({required super.message});
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure({required super.message});
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({required super.message});
}
