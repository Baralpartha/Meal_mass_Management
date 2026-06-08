import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../config/env/local_storage_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/member_entity.dart';
import '../datasources/auth_remote_dataSource.dart';
import '../../domain/repositories/auth_repository.dart';


@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final LocalStorageService _localStorage;

  AuthRepositoryImpl(this._remote, this._localStorage);

  @override
  Future<Either<Failure, MemberEntity>> login({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final model = await _remote.login(
        mobileNumber: mobileNumber,
        password: password,
      );
      await _localStorage.saveMember(model);
      await _localStorage.setLoggedIn(true);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> register({
    required String fullName,
    required String mobileNumber,
    required String password,
    String? district,
    String? thana,
    String? address,
  }) async {
    try {
      final model = await _remote.register(
        fullName: fullName,
        mobileNumber: mobileNumber,
        password: password,
        district: district,
        thana: thana,
        address: address,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localStorage.clear();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemberEntity?>> getCurrentMember() async {
    try {
      final model = _localStorage.getMember();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}