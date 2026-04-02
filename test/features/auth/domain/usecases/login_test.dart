import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock repository implementation for testing
class MockAuthRepository implements AuthRepository {
  User? mockUser;
  Failure? mockFailure;

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (mockFailure != null) {
      return Left(mockFailure!);
    }
    return Right(mockUser!);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    return Right(mockUser);
  }
}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password';
  const tUser = User(id: '1', email: tEmail, name: 'Test User', token: 'token');

  test('should return user when login is successful', () async {
    // Arrange
    mockRepository.mockUser = tUser;

    // Act
    final result = await useCase(LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should not return failure'),
      (user) => expect(user, tUser),
    );
  });

  test('should return failure when login fails', () async {
    // Arrange
    mockRepository.mockFailure = const ServerFailure(message: 'Server error');

    // Act
    final result = await useCase(LoginParams(email: tEmail, password: tPassword));

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Server error'),
      (user) => fail('Should not return user'),
    );
  });
}