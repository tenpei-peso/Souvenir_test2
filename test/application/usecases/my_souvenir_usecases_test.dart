import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test2/application/usecases/my_souvenir_usecases.dart';
import 'package:test2/domain/entities/my_souvenir.dart';
import 'package:test2/domain/entities/souvenir_category.dart';
import 'package:test2/domain/repositories/my_souvenir_repository.dart';
import 'package:test2/util/app_exception.dart';

// Mock Repository
class MockMySouvenirRepository extends Mock implements MySouvenirRepository {}

void main() {
  late MockMySouvenirRepository mockRepository;
  late MySouvenirUsecases usecase;

  setUp(() {
    mockRepository = MockMySouvenirRepository();
    usecase = MySouvenirUsecases(repository: mockRepository);
  });

  group('MySouvenirUsecases', () {
    group('validateName', () {
      test('空文字列は エラー', () {
        final error = usecase.validateName('');
        expect(error, isNotNull);
        expect(error, contains('必須'));
      });

      test('100文字以下は OK', () {
        final name = 'a' * 100;
        final error = usecase.validateName(name);
        expect(error, isNull);
      });

      test('101文字以上は エラー', () {
        final name = 'a' * 101;
        final error = usecase.validateName(name);
        expect(error, isNotNull);
        expect(error, contains('100文字'));
      });

      test('有効な名前は OK', () {
        final error = usecase.validateName('羊羹');
        expect(error, isNull);
      });
    });

    group('validateDescription', () {
      test('空文字列は エラー', () {
        final error = usecase.validateDescription('');
        expect(error, isNotNull);
      });

      test('500文字以下は OK', () {
        final desc = 'a' * 500;
        final error = usecase.validateDescription(desc);
        expect(error, isNull);
      });

      test('501文字以上は エラー', () {
        final desc = 'a' * 501;
        final error = usecase.validateDescription(desc);
        expect(error, isNotNull);
        expect(error, contains('500文字'));
      });
    });

    group('validatePrice', () {
      test('0円以下は エラー', () {
        final error = usecase.validatePrice(0);
        expect(error, isNotNull);
        expect(error, contains('1円'));
      });

      test('負数は エラー', () {
        final error = usecase.validatePrice(-100);
        expect(error, isNotNull);
      });

      test('999,999円以下は OK', () {
        final error = usecase.validatePrice(999999);
        expect(error, isNull);
      });

      test('1,000,000円以上は エラー', () {
        final error = usecase.validatePrice(1000000);
        expect(error, isNotNull);
        expect(error, contains('999,999'));
      });

      test('有効な値段は OK', () {
        final error = usecase.validatePrice(2500);
        expect(error, isNull);
      });
    });

    group('createSouvenir', () {
      test('バリデーション失敗：名前が空', () async {
        final souvenir = MySouvenir(
          id: '',
          name: '',
          category: SouvenirCategory.sweets,
          description: '説明',
          price: 1000,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(
          () => usecase.createSouvenir(userId: 'user1', souvenir: souvenir),
          throwsA(isA<ValidationException>()),
        );
      });

      test('バリデーション失敗：説明が空', () async {
        final souvenir = MySouvenir(
          id: '',
          name: '羊羹',
          category: SouvenirCategory.sweets,
          description: '',
          price: 1000,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(
          () => usecase.createSouvenir(userId: 'user1', souvenir: souvenir),
          throwsA(isA<ValidationException>()),
        );
      });

      test('バリデーション失敗：値段が0', () async {
        final souvenir = MySouvenir(
          id: '',
          name: '羊羹',
          category: SouvenirCategory.sweets,
          description: '説明',
          price: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(
          () => usecase.createSouvenir(userId: 'user1', souvenir: souvenir),
          throwsA(isA<ValidationException>()),
        );
      });

      test('バリデーション成功 → Repository.create を呼び出し', () async {
        final now = DateTime.now();
        final souvenir = MySouvenir(
          id: '',
          name: '羊羹',
          category: SouvenirCategory.sweets,
          description: '東京の名物',
          price: 2500,
          createdAt: now,
          updatedAt: now,
        );

        when(() => mockRepository.create('user1', any())).thenAnswer(
          (_) async => souvenir.copyWith(id: 'souvenir1'),
        );

        final result = await usecase.createSouvenir(
          userId: 'user1',
          souvenir: souvenir,
        );

        expect(result.id, equals('souvenir1'));
        verify(() => mockRepository.create('user1', any())).called(1);
      });
    });

    group('updateSouvenir', () {
      test('バリデーション成功 → Repository.update を呼び出し', () async {
        final now = DateTime.now();
        final souvenir = MySouvenir(
          id: 'souvenir1',
          name: '羊羹',
          category: SouvenirCategory.sweets,
          description: '説明',
          price: 2500,
          createdAt: now,
          updatedAt: now,
        );

        when(() => mockRepository.update('user1', any()))
            .thenAnswer((_) async => {});

        await usecase.updateSouvenir(userId: 'user1', souvenir: souvenir);

        verify(() => mockRepository.update('user1', any())).called(1);
      });
    });

    group('deleteSouvenir', () {
      test('Repository.delete を呼び出し', () async {
        when(() => mockRepository.delete('user1', 'souvenir1'))
            .thenAnswer((_) async => {});

        await usecase.deleteSouvenir(userId: 'user1', souvenirId: 'souvenir1');

        verify(() => mockRepository.delete('user1', 'souvenir1')).called(1);
      });
    });
  });
}
