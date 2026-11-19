import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goprompt/core/services/storage_service.dart';
import 'package:goprompt/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('EasyPromptProApp smoke test', (WidgetTester tester) async {
    await Get.putAsync(() => StorageService().init());
    await tester.pumpWidget(const EasyPromptProApp());
    expect(find.byType(EasyPromptProApp), findsOneWidget);
  });
}
