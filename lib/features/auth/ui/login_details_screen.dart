import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../app/navigation/app_routes.dart';

import '../state/auth_state.dart';

class LoginDetailsScreen extends ConsumerStatefulWidget {
  const LoginDetailsScreen({super.key});

  @override
  ConsumerState<LoginDetailsScreen> createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends ConsumerState<LoginDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Razak');
  final _email = TextEditingController(text: 'driver@company.com');
  final _pass = TextEditingController(text: 'contrasena');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(22, 18, 22, 22 + keyboardInset),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      child: const Image(
                        image: AssetImage('Assets/LogoBlue.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr('login_details.welcome_title'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: tr('login_details.email_label'),
                          ),
                          validator: (v) => (v == null || !v.contains('@'))
                              ? tr('login_details.email_invalid')
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _pass,
                          decoration: InputDecoration(
                            labelText: tr('login_details.password_label'),
                          ),
                          obscureText: true,
                          validator: (v) =>
                              (v == null || v.length < 3)
                                  ? tr('login_details.password_too_short')
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              ref
                                  .read(authStateProvider.notifier)
                                  .mockLogin(_name.text.trim());
                              context.go(AppRoutes.home);
                            },
                            child: Text(tr('login_details.login_button')),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              tr('login_details.signup_prompt'),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: const Color(0xFF5F6368)),
                            ),
                            InkWell(
                              onTap: () => context.go(AppRoutes.registration),
                              child: Text(
                                tr('login_details.signup_action'),
                                style: TextStyle(
                                  color: Color(0xFF0A84FF),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
