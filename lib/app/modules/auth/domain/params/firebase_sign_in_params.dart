import 'package:equatable/equatable.dart';

/// Parameters for Firebase authentication.
/// Uses [email] as the Firebase email and [phone] as the Firebase password,
/// since the app authenticates with SSN (mapped to email) and phone number (mapped to password).
class FirebaseSignInParams extends Equatable {
  final String email;
  final String phone;

  const FirebaseSignInParams({
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [email, phone];
}
