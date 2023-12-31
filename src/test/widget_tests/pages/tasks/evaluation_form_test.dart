import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/daos/log_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/models/student/evaluation.dart';
import 'package:src/models/user.dart';
import 'package:src/models/user_badge.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/tasks/evaluation_form.dart';
import '../../../utils/service_locator_test_util.dart';
import 'package:flutter/material.dart';
import '../../widget_tests_utils.dart';

void mockCallback(StudentEvaluation evaluation) {}

void main() {
  setUp(() async {
    setupMockServiceLocatorUnitTests();
    await serviceLocator.allReady();
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  loadBadgesInfo() {
    User user = User(
        id: 1,
        name: 'name',
        email: 'email',
        password: 'password',
        level: 1,
        imagePath: '',
        xp: 0);
    final mockAuthenticationService =
        serviceLocator.get<AuthenticationService>();
    when(mockAuthenticationService.getLoggedInUser()).thenAnswer((_) => user);
    final mockUserBadgeDao = serviceLocator.get<UserBadgeDao>();
    when(mockUserBadgeDao.findUserBadgeByIds(user.id!, 1))
        .thenAnswer((_) async => UserBadge(userId: 0, badgeId: 0));
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 0, 0, 0, 0, 0);
    DateTime end = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59, 59, 59);

    final mockLogDao = serviceLocator.get<LogDao>();
    when(mockLogDao.countLogsByDate(today, end)).thenAnswer((_) async => 1);
    when(mockLogDao.countLogs()).thenAnswer((_) async => 5);
  }

  testWidgets('Create evaluation with incorrect fields test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(const LocalizationsInjector(
      child: EvaluationForm(callback: mockCallback),
    ));

    await widgetTester.pumpAndSettle();

    final saveButton = find.byKey(const Key('saveEvaluationButton'));

    Finder scrollable = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100,
        scrollable: scrollable);

    await widgetTester.tap(saveButton);

    await widgetTester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Grade is required'), findsOneWidget);
  });

  testWidgets('Create evaluation normally', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(const LocalizationsInjector(
      child: EvaluationForm(
        callback: mockCallback,
      ),
    ));

    await widgetTester.pumpAndSettle();

    String evaluationName = 'evaluation_name';
    String evaluationGrade = '3';
    await widgetTester.enterText(
        find.byKey(const Key('nameEvaluationField')), evaluationName);
    await widgetTester.enterText(
        find.byKey(const Key('gradeEvaluationField')), evaluationGrade);

    expect(find.text(evaluationName), findsOneWidget);
    expect(find.textContaining(evaluationGrade), findsOneWidget);

    final saveButton = find.byKey(const Key('saveEvaluationButton'));

    Finder scrollable = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100,
        scrollable: scrollable);

    await widgetTester.tap(saveButton);

    await widgetTester.pumpAndSettle();

    expect(find.text('Name is required'), findsNothing);
    expect(find.text('Grade is required'), findsNothing);
    expect(find.text(evaluationName), findsNothing);
    expect(find.textContaining(evaluationGrade), findsNothing);
  });

  testWidgets('Load correct evaluation information test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    String evaluationName = 'evaluation_name';
    double evaluationGrade = 3.0;
    await widgetTester.pumpWidget(LocalizationsInjector(
      child: EvaluationForm(
          evaluation: StudentEvaluation(
            id: 1,
            name: evaluationName,
            grade: evaluationGrade,
            subjectId: 1,
          ),
          callback: mockCallback),
    ));

    await widgetTester.pumpAndSettle();

    expect(find.text(evaluationName), findsOneWidget);
    expect(find.textContaining(evaluationGrade.toString()), findsOneWidget);
  });

  testWidgets('Edit evaluation test', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    String evaluationName = 'evaluation_name';
    double evaluationGrade = 3.0;
    await widgetTester.pumpWidget(LocalizationsInjector(
      child: EvaluationForm(
          evaluation: StudentEvaluation(
            id: 1,
            name: evaluationName,
            grade: evaluationGrade,
            subjectId: 1,
          ),
          callback: mockCallback),
    ));

    await widgetTester.pumpAndSettle();

    String newEvaluationName = 'new_evaluation_name';
    String newEvaluationGrade = '4.0';
    await widgetTester.enterText(
        find.byKey(const Key('nameEvaluationField')), newEvaluationName);
    await widgetTester.enterText(
        find.byKey(const Key('gradeEvaluationField')), newEvaluationGrade);

    expect(find.text(newEvaluationName), findsOneWidget);
    expect(find.textContaining(newEvaluationGrade), findsOneWidget);
    expect(find.text(evaluationName), findsNothing);
    expect(find.textContaining(evaluationGrade.toString()), findsNothing);
  });
}
