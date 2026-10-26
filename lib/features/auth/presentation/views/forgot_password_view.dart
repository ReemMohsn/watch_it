import 'package:e_learning/core/common/utils/app_validator.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/extensions/snack_bar_context_extension.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().sendPasswordResetEmail(_email.text);
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthCubit, AuthState>(
    listener: (context, state) {
      if (state is ForgotPasswordFailure) {
        context.showErrorSnackBar(state.errorMessage);
      }
    },
    builder: (context, state) {
      final loading = context.read<AuthCubit>().isBusy;
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.passwordRecovery)),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppStrings.passwordRecoveryInstructions,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        enabled: !loading,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          labelText: AppStrings.email,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: AppValidator.email,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      if (state is ForgotPasswordSuccess) ...[
                        const SizedBox(height: 16),
                        Text(state.message),
                      ],
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: loading ? null : _submit,
                        icon: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.email_outlined),
                        label: const Text(AppStrings.sendPasswordResetLink),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
