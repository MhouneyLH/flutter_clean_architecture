import 'package:dartz/dartz.dart';
import 'package:flutter_clean_code_example/core/error/exception.dart';
import 'package:flutter_clean_code_example/core/error/failure.dart';
import 'package:flutter_clean_code_example/core/network/network_info.dart';
import 'package:flutter_clean_code_example/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_code_example/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_code_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_code_example/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_code_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

// for code generation
typedef RemoteDataSource = NumberTriviaRemoteDataSource;
typedef LocalDataSource = NumberTriviaLocalDataSource;

@GenerateNiceMocks([
  MockSpec<RemoteDataSource>(),
  MockSpec<LocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late NumberTriviaRepositoryImpl repository;

  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    // three Contracts
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');

    // cast in correct type (model only subclass of entity)
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        // everytime a Future is returned, thenAnswer is used instead of thenReturn
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // without await, we get the Future instance back
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          // should be called with the right number
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          // should return the right type (NumberTrivia)
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          // should be called with the right number
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException('ServerException'));
          // act
          // without await, we get the Future instance back
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          // should be called with the right number
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          // should return the right type (NumberTrivia)
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return the last locally cached data when the cache data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return the CacheFailure when there is no cache data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException('CacheException'));
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');

    // cast in correct type (model only subclass of entity)
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        // everytime a Future is returned, thenAnswer is used instead of thenReturn
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // without await, we get the Future instance back
          final result = await repository.getRandomNumberTrivia();
          // assert
          // should be called with the right number
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          // should return the right type (NumberTrivia)
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          // should be called with the right number
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException('ServerException'));
          // act
          // without await, we get the Future instance back
          final result = await repository.getRandomNumberTrivia();
          // assert
          // should be called with the right number
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          // should return the right type (NumberTrivia)
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return the last locally cached data when the cache data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should return the CacheFailure when there is no cache data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException('CacheException'));
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
