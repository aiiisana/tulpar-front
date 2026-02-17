import 'package:flutter/material.dart';
import 'package:tulpar_front/features/setup/home_shell.dart';
import '../../app/theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_auth_row.dart';
import '../../app/app_storage.dart';
import '../../app/password_hash.dart';
import '../setup/daily_goal_screen.dart';
import 'signup_screen.dart';
import 'social_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  bool wrongCreds = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
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

  Future<void> _loginWithEmail() async {
    final inputEmail = emailCtrl.text.trim();
    final inputPass = passCtrl.text;

    final savedEmail = await AppStorage.getEmail();
    final savedHash = await AppStorage.getPasswordHash();

    final ok = savedEmail != null &&
        savedEmail.isNotEmpty &&
        savedHash != null &&
        savedHash.isNotEmpty &&
        inputEmail == savedEmail &&
        hashPassword(inputPass) == savedHash;

    if (!ok) {
      setState(() => wrongCreds = true);
      return;
    }

    await AppStorage.setLoggedIn(true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  Future<void> _loginWithGoogle() async {
    final acc = await SocialAuth.signInWithGoogle();
    if (acc == null) return;

    if (acc.email.isNotEmpty) {
      await AppStorage.saveCredentials(email: acc.email, passwordHash: '');
    }

    await AppStorage.setLoggedIn(true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  Future<void> _loginWithApple() async {
    final cred = await SocialAuth.signInWithApple();
    if (cred.identityToken == null) return;

    final email = cred.email ?? '';
    if (email.isNotEmpty) {
      await AppStorage.saveCredentials(email: email, passwordHash: '');
    }

    await AppStorage.setLoggedIn(true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final err = wrongCreds ? 'Неверная почта или пароль' : null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const SizedBox(height: 34),
                Text(
                  'С возвращением!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),

                SocialAuthRow(
                  title: 'Войти через',
                  onGoogle: _loginWithGoogle,
                  onApple: _loginWithApple,
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (wrongCreds) setState(() => wrongCreds = false);
                  },
                  decoration: _decor(
                    hint: 'Электронная почта',
                    icon: Icons.mail_outline,
                    error: wrongCreds,
                    errorText: err,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  onChanged: (_) {
                    if (wrongCreds) setState(() => wrongCreds = false);
                  },
                  decoration: _decor(
                    hint: 'Пароль',
                    icon: Icons.lock_outline,
                    error: wrongCreds,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                PrimaryButton(text: 'Войти', onPressed: _loginWithEmail),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Нет аккаунта? ', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        'Создать',
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
