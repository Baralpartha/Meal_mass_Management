import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String mobileNumber;
  final String password;
  const AuthLoginRequested({required this.mobileNumber, required this.password});

  @override
  List<Object?> get props => [mobileNumber, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String mobileNumber;
  final String password;
  final String? district;
  final String? thana;
  final String? address;

  const AuthRegisterRequested({
    required this.fullName,
    required this.mobileNumber,
    required this.password,
    this.district,
    this.thana,
    this.address,
  });

  @override
  List<Object?> get props => [fullName, mobileNumber, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}