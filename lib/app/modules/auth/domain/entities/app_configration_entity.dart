import 'package:equatable/equatable.dart';

class AppConfiguration extends Equatable {
  final bool? isOtpEnabled;

  const AppConfiguration({
    this.isOtpEnabled,
  });

  @override
  List<Object?> get props => [
        isOtpEnabled,
      ];
}
