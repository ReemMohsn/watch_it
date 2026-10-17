import 'package:e_learning/core/routing/app_router.dart';
import 'package:e_learning/core/routing/routes.dart';
import 'package:e_learning/core/networking/supabase_service.dart';
import 'package:e_learning/e_learning.dart';
import 'package:flutter/material.dart';
import 'package:e_learning/core/dependency_injection/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  await initDependencies();
  runApp(ELearningApp(appRouter: AppRouter(), initialRoute: Routes.home));
}
