import 'package:dartz/dartz.dart';
import '../error/failures.dart';

typedef Result<T> = Future<Either<Failure, T>>;
typedef SyncResult<T> = Either<Failure, T>;