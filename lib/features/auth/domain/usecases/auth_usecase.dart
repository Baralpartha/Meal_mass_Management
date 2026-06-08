import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/auth_repository.dart';

// ── Login ─────────────────────────────────────────────────────────────────

class LoginParams extends Equatable {
  final String mobileNumber;
  final String password;

  const LoginParams({required this.mobileNumber, required this.password});

  @override
  List<Object?> get props => [mobileNumber, password];
}

@lazySingleton
class LoginUseCase implements UseCase<MemberEntity, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, MemberEntity>> call(LoginParams params) =>
      _repository.login(
        mobileNumber: params.mobileNumber,
        password: params.password,
      );
}

// ── Register ──────────────────────────────────────────────────────────────

class RegisterParams extends Equatable {
  final String fullName;
  final String mobileNumber;
  final String password;
  final String? district;
  final String? thana;
  final String? address;

  const RegisterParams({
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

@lazySingleton
class RegisterUseCase implements UseCase<MemberEntity, RegisterParams> {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, MemberEntity>> call(RegisterParams params) =>
      _repository.register(
        fullName: params.fullName,
        mobileNumber: params.mobileNumber,
        password: params.password,
        district: params.district,
        thana: params.thana,
        address: params.address,
      );
}

// ── Logout ────────────────────────────────────────────────────────────────

@lazySingleton
class LogoutUseCase implements UseCaseNoParams<void> {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call() => _repository.logout();
}

// ── Get Current Member ────────────────────────────────────────────────────

@lazySingleton
class GetCurrentMemberUseCase implements UseCaseNoParams<MemberEntity?> {
  final AuthRepository _repository;
  GetCurrentMemberUseCase(this._repository);

  @override
  Future<Either<Failure, MemberEntity?>> call() =>
      _repository.getCurrentMember();
}