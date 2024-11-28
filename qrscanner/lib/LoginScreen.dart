import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final isObscured = useState(true);

    Future<void> handleLogin() async {
      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(20.w),
            content: const Text('Please fill in all fields'),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/landing');
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 50.h),

                      // Logo and welcome text
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/Technocrafts-logo.png',
                            // height: 200.h,
                            // width: 200.h,
                            fit: BoxFit.contain,
                          )
                              .animate()
                              .fade(duration: const Duration(milliseconds: 500))
                              .scale(
                                  duration: const Duration(milliseconds: 500)),
                          SizedBox(height: 20.h),
                          Text(
                            'Welcome Back!',
                            style: GoogleFonts.poppins(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Sign in to continue',
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideY(
                            begin: -0.3,
                            curve: Curves.easeOut,
                          ),

                      SizedBox(height: 40.h),

                      // Login form
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              // Username field
                              TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ).animate().fadeIn().slideX(
                                    begin: -0.2,
                                    delay: 200.ms,
                                  ),

                              SizedBox(height: 16.h),

                              // Password field
                              TextFormField(
                                controller: passwordController,
                                obscureText: isObscured.value,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isObscured.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () =>
                                        isObscured.value = !isObscured.value,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ).animate().fadeIn().slideX(
                                    begin: 0.2,
                                    delay: 400.ms,
                                  ),

                              SizedBox(height: 24.h),

                              // Login button
                              SizedBox(
                                width: double.infinity,
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed:
                                      isLoading.value ? null : handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text('Login'),
                                ),
                              ).animate().fadeIn().slideY(
                                    begin: 0.2,
                                    delay: 600.ms,
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
