import 'package:e_learning/core/dependency_injection/injection_container.dart';
import 'package:e_learning/core/extensions/snack_bar_context_extension.dart';
import 'package:e_learning/core/routing/app_router.dart';
import 'package:e_learning/core/routing/navigator_key.dart';
import 'package:e_learning/core/routing/routes.dart';
import 'package:e_learning/core/themes/app_theme.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ELearningApp extends StatelessWidget {
  const ELearningApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is! PasswordRecoveryRequired &&
              state is! AuthSessionFailure) {
            return;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            if (state is PasswordRecoveryRequired) {
              NavigatorKey.navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.resetPassword,
                (route) => route.settings.name == Routes.home,
              );
            } else if (state is AuthSessionFailure) {
              NavigatorKey.navigatorKey.currentContext?.showErrorSnackBar(
                state.errorMessage,
              );
            }
          });
          WidgetsBinding.instance.ensureVisualUpdate();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          navigatorKey: NavigatorKey.navigatorKey,

          onGenerateRoute: appRouter.generateRoute,
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}
