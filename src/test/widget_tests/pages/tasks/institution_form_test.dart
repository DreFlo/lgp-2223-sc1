import 'package:flutter_test/flutter_test.dart';
import 'package:src/services/authentication_service.dart';
import 'package:src/daos/log_dao.dart';
import 'package:src/daos/user_badge_dao.dart';
import 'package:src/models/user.dart';
import 'package:src/models/user_badge.dart';
import 'package:src/utils/service_locator.dart';
import '../../../utils/service_locator_test_util.dart';
import 'package:flutter/material.dart';
import 'package:src/utils/enums.dart';
import 'package:mockito/mockito.dart';
import '../../../utils/model_mocks_util.mocks.dart';
import '../../widget_tests_utils.dart';

import 'package:src/models/student/institution.dart';
import 'package:src/models/student/subject.dart';

import 'package:src/daos/student/institution_dao.dart';
import 'package:src/daos/student/subject_dao.dart';

import 'package:src/pages/tasks/institution_form.dart';

import 'package:src/themes/colors.dart';

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

  testWidgets('Create institution with incorrect fields test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    Finder saveButton = find.byKey(const Key('saveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
  });

  testWidgets('Create institution normally test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();

    when(mockInstitutionDao.insertInstitution(MockInstitution()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController())));

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('institutionNameField')), 'inst_name');

    expect(find.text('inst_name'), findsOneWidget);

    Finder saveButton = find.byKey(const Key('saveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name'), findsNothing);
  });

  testWidgets('Load correct institution information test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1, name: 'inst_name', type: InstitutionType.other, userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectByInstitutionId(1)).thenAnswer((_) async =>
        [Subject(id: 1, name: 'sub_name', acronym: 'sub_acronym')]);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name'), findsOneWidget);
    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);

    final container =
        widgetTester.firstWidget(find.byKey(const Key('otherInstitutionType')))
            as Container;
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, primaryColor);
  });

  testWidgets('Edit institution test', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1, name: 'inst_name', type: InstitutionType.other, userId: 1)));

    when(mockInstitutionDao.updateInstitution(MockInstitution()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('institutionNameField')), 'inst_name_edited');

    await widgetTester
        .tap(find.byKey(const Key('educationInstitutionTypeButton')));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name_edited'), findsOneWidget);

    Container container =
        widgetTester.firstWidget(find.byKey(const Key('otherInstitutionType')));
    BoxDecoration decoration = container.decoration as BoxDecoration;
    expect(decoration.color, lightGray);

    container = widgetTester
        .firstWidget(find.byKey(const Key('educationInstitutionType')));
    decoration = container.decoration as BoxDecoration;
    expect(decoration.color, primaryColor);

    Finder saveButton = find.byKey(const Key('saveButton'));

    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name_edited'), findsNothing);
  });

  testWidgets('Delete institution test', (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1, name: 'inst_name', type: InstitutionType.other, userId: 1)));

    when(mockInstitutionDao.deleteInstitution(MockInstitution()))
        .thenAnswer((_) async => 1);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name'), findsOneWidget);

    final deleteButton = find.byKey(const Key('deleteButton'));
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(deleteButton, 100,
        scrollable: scroll);
    await widgetTester.tap(deleteButton);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(const Key('cancelConfirmationButton')), findsOneWidget);
    expect(find.byKey(const Key('deleteConfirmationButton')), findsOneWidget);

    await widgetTester.tap(find.byKey(const Key('deleteConfirmationButton')));

    await widgetTester.pumpAndSettle();

    expect(find.text('inst_name'), findsNothing);
  });

  testWidgets('Add new subject from institution test',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1, name: 'inst_name', type: InstitutionType.other, userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectByInstitutionId(1))
        .thenAnswer((_) async => []);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);

    final addSubjectIcon = find.byIcon(Icons.add).last;
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(addSubjectIcon, 100,
        scrollable: scroll);
    await widgetTester.tap(addSubjectIcon);

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('nameField')), 'sub_name');

    await widgetTester.enterText(
        find.byKey(const Key('acronymField')), 'sub_acronym');

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsOneWidget);
    expect(find.text('sub_acronym'), findsOneWidget);
  });

  testWidgets('Disassociate temporary subject from institution',
      (WidgetTester widgetTester) async {
    loadBadgesInfo();
    final mockInstitutionDao = serviceLocator.get<InstitutionDao>();
    when(mockInstitutionDao.findInstitutionById(1)).thenAnswer((_) =>
        Stream.value(Institution(
            id: 1, name: 'inst_name', type: InstitutionType.other, userId: 1)));

    final mockSubjectDao = serviceLocator.get<SubjectDao>();
    when(mockSubjectDao.findSubjectByInstitutionId(1))
        .thenAnswer((_) async => []);

    await widgetTester.pumpWidget(LocalizationsInjector(
        child: InstitutionForm(scrollController: ScrollController(), id: 1)));

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);

    final addSubjectIcon = find.byIcon(Icons.add).last;
    Finder scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(addSubjectIcon, 100,
        scrollable: scroll);
    await widgetTester.tap(addSubjectIcon);

    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(
        find.byKey(const Key('nameField')), 'sub_name');

    await widgetTester.enterText(
        find.byKey(const Key('acronymField')), 'sub_acronym');

    Finder saveButton = find.byKey(const Key('saveSubjectButton'));

    scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(saveButton, 100, scrollable: scroll);
    await widgetTester
        .tap(find.byKey(const Key('saveSubjectButton'), skipOffstage: false));

    await widgetTester.pumpAndSettle();

    Finder disassociateButton = find.byType(IconButton).last;

    scroll = find.byType(Scrollable).last;

    await widgetTester.scrollUntilVisible(disassociateButton, 100,
        scrollable: scroll);
    await widgetTester.tap(disassociateButton);

    await widgetTester.pumpAndSettle();

    expect(find.text('sub_name'), findsNothing);
    expect(find.text('sub_acronym'), findsNothing);
    expect(find.textContaining('3'), findsNothing);
  });
}
