import 'package:dashboard_new/Customer_views/Find_tailor/map_page.dart';
import 'package:dashboard_new/Customer_views/Find_tailor/order_place.dart';
import 'package:dashboard_new/Customer_views/auth_screen/signup_screen.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/Customer_views/measurements/measurements.dart';
import 'package:dashboard_new/First_screen/first_screen.dart';
import 'package:dashboard_new/Tailor_views/Profile/edit_profile.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/signup_screen.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/verification.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home.dart';
import 'package:dashboard_new/view/forgot_password.dart';
import 'package:dashboard_new/view/forgot_password_tailor.dart';
import 'package:dashboard_new/view/verify_email.dart';
import 'package:dashboard_new/view/verify_email_customer.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const splash = '/';
  static const customerHome = '/customer-home';
  static const tailorHome = '/tailor-home';
  static const customerSignup = '/customer-signup';
  static const tailorSignup = '/tailor-signup';
  static const customerEmailVerify = '/customer-email-verify';
  static const tailorEmailVerify = '/tailor-email-verify';
  static const tailorAdminVerify = '/tailor-admin-verify';
  static const forgotPassword = '/forgot-password';
  static const forgotPasswordTailor = '/forgot-password-tailor';
  static const tailorEditProfile = '/tailor-edit-profile';
  static const customerMeasurements = '/customer-measurements';
  static const tailorInfo = '/tailor-info';
  static const mapPage = '/map-page';
}

final goRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.customerHome,
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: AppRoutes.tailorHome,
      builder: (context, state) => const Home_Tailor(),
    ),
    GoRoute(
      path: AppRoutes.customerSignup,
      builder: (context, state) => const SignupScreen(type: "Customer"),
    ),
    GoRoute(
      path: AppRoutes.tailorSignup,
      builder: (context, state) => const SignupScreen_Tailor(type: "Tailor"),
    ),
    GoRoute(
      path: AppRoutes.customerEmailVerify,
      builder: (context, state) => const VerifyEmailScreen_cust(),
    ),
    GoRoute(
      path: AppRoutes.tailorEmailVerify,
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: AppRoutes.tailorAdminVerify,
      builder: (context, state) => const VerifyUser(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: AppRoutes.forgotPasswordTailor,
      builder: (context, state) => const ForgotPassword_t(),
    ),
    GoRoute(
      path: AppRoutes.tailorEditProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.customerMeasurements,
      builder: (context, state) => const MeasurementScreen(),
    ),
    GoRoute(
      path: AppRoutes.tailorInfo,
      builder: (context, state) => const TailorInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.mapPage,
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? '';
        return MapPage(orderId: orderId);
      },
    ),
  ],
);
