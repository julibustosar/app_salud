import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImp(this.remoteDataSource);

  @override
  Future<void> login(String email, String password) async {
    await remoteDataSource.login(email, password);
  }
}