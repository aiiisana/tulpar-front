import 'package:flutter/material.dart';
import 'package:tulpar_front/app/security_service.dart';
import 'package:tulpar_front/features/auth/set_pin_screen.dart';
import 'package:tulpar_front/features/setup/home_shell.dart';
import '../../app/theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_auth_row.dart';
import '../../app/app_storage.dart';
import '../../app/password_hash.dart';
import 'login_screen.dart';
import 'social_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  bool passMismatch = false;

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    pass2Ctrl.dispose();
    super.dispose();
  }

  InputDecoration _decor({
    required String hint,
    required IconData icon,
    Widget? suffix,
    bool error = false,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
      prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
      suffixIcon: suffix,
      errorText: errorText,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: error ? Colors.red : AppTheme.border),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: error ? Colors.red : AppTheme.primary, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  Future<void> _goNextAfterAuth() async {
    await AppStorage.setLoggedIn(true);

    final sec = SecurityService();
    final hasPin = await sec.hasPin();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => hasPin ? const HomeShell() : const SetPinScreen()),
    );
  }

  Future<void> _signupWithEmail() async {
    final email = emailCtrl.text.trim();
    final p1 = passCtrl.text;
    final p2 = pass2Ctrl.text;
    final first = firstCtrl.text.trim();
    final last = lastCtrl.text.trim();

    setState(() {
      passMismatch = p1.isNotEmpty && p2.isNotEmpty && p1 != p2;
    });

    if (email.isEmpty || p1.isEmpty) return;
    if (passMismatch) return;

    await AppStorage.saveCredentials(
      email: email,
      passwordHash: hashPassword(p1),
    );

    await AppStorage.saveProfile(
      firstName: first.isEmpty ? 'User' : first,
      lastName: last,
    );

    await _goNextAfterAuth();
  }

  Future<void> _signupWithGoogle() async {
    final acc = await SocialAuth.signInWithGoogle();
    if (acc == null) return;

    if (acc.email.isNotEmpty) {
      await AppStorage.saveCredentials(email: acc.email, passwordHash: '');
    }

    final displayName = (acc.displayName ?? '').trim();
    if (displayName.isNotEmpty) {
      await AppStorage.saveProfile(firstName: displayName, lastName: '');
    }

    await _goNextAfterAuth();
  }

  Future<void> _signupWithApple() async {
    final cred = await SocialAuth.signInWithApple();
    if (cred.identityToken == null) return;

    final email = (cred.email ?? '').trim();
    if (email.isNotEmpty) {
      await AppStorage.saveCredentials(email: email, passwordHash: '');
    }

    final first = (cred.givenName ?? '').trim();
    final last = (cred.familyName ?? '').trim();
    if (first.isNotEmpty || last.isNotEmpty) {
      await AppStorage.saveProfile(firstName: first.isEmpty ? 'User' : first, lastName: last);
    }

    await _goNextAfterAuth();
  }

  @override
  Widget build(BuildContext context) {
    final errorText = passMismatch ? 'Пароли не совпадают' : null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const SizedBox(height: 34),
                Text(
                  'Создать аккаунт',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),

                SocialAuthRow(
                  title: 'Зарегистрироваться через',
                  onGoogle: _signupWithGoogle,
                  onApple: _signupWithApple,
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: firstCtrl,
                  decoration: _decor(hint: 'Имя', icon: Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastCtrl,
                  decoration: _decor(hint: 'Фамилия', icon: Icons.person_outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decor(hint: 'Электронная почта', icon: Icons.mail_outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: obscure1,
                  onChanged: (_) {
                    if (passMismatch) {
                      setState(() => passMismatch = passCtrl.text != pass2Ctrl.text);
                    }
                  },
                  decoration: _decor(
                    hint: 'Пароль',
                    icon: Icons.lock_outline,
                    error: passMismatch,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure1 = !obscure1),
                      icon: Icon(
                        obscure1 ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pass2Ctrl,
                  obscureText: obscure2,
                  onChanged: (_) {
                    setState(() {
                      passMismatch = passCtrl.text.isNotEmpty &&
                          pass2Ctrl.text.isNotEmpty &&
                          passCtrl.text != pass2Ctrl.text;
                    });
                  },
                  decoration: _decor(
                    hint: 'Повтор пароля',
                    icon: Icons.lock_outline,
                    error: passMismatch,
                    errorText: errorText,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure2 = !obscure2),
                      icon: Icon(
                        obscure2 ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                PrimaryButton(text: 'Создать аккаунт', onPressed: _signupWithEmail),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Уже есть аккаунт? ', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Войти',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
