import 'package:greenpay/deferred_widget.dart';
import 'package:flutter/material.dart';
import 'package:greenpay/pages/auth/sign_in/sign_in_page.dart'
    deferred as signIn;
import 'package:greenpay/pages/auth/register/register_page.dart';
import 'package:greenpay/pages/dashboard/ecommerce_page.dart';
import 'package:greenpay/pages/profile/profile_page.dart';
import 'package:greenpay/pages/settings/settings_page.dart';
import 'package:greenpay/pages/transactions/transactions_page.dart';
import 'package:greenpay/pages/transactions/transaction_details_page.dart';
import 'package:greenpay/pages/impact/carbon_impact_page.dart';
import 'package:greenpay/pages/tips/green_tips_page.dart';
import 'package:greenpay/pages/splash_screen.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, String?);

final List<Map<String, Object>> MAIN_PAGES = [
  {'routerPath': '/splash', 'widget': const SplashScreen()},
  {'routerPath': '/', 'widget': const EcommercePage()},
  {'routerPath': '/dashboard', 'widget': const EcommercePage()},
  {'routerPath': '/profile', 'widget': const ProfilePage()},
  {'routerPath': '/transactions', 'widget': const TransactionsPage()},
  {
    'routerPath': '/transaction-details/:id',
    'widget': const _TransactionDetailsWrapper()
  },
  {'routerPath': '/impact', 'widget': const CarbonImpactPage()},
  {'routerPath': '/tips', 'widget': const GreenTipsPage()},
  {'routerPath': '/settings', 'widget': const SettingsPage()},
  {
    'routerPath': '/signIn',
    'widget': DeferredWidget(signIn.loadLibrary, () => signIn.SignInWidget())
  },
  {'routerPath': '/register', 'widget': const RegisterPage()},
];

// Wrapper to handle dynamic route parameters
class _TransactionDetailsWrapper extends StatelessWidget {
  const _TransactionDetailsWrapper();

  @override
  Widget build(BuildContext context) {
    final transactionId =
        ModalRoute.of(context)?.settings.arguments as String? ?? '1';
    return TransactionDetailsPage(transactionId: transactionId);
  }
}

class RouteConfiguration {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'Rex');

  static BuildContext? get navigatorContext =>
      navigatorKey.currentState?.context;

  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    String path = settings.name!;

    dynamic map =
        MAIN_PAGES.firstWhere((element) => element['routerPath'] == path);

    if (map == null) {
      return null;
    }
    Widget targetPage = map['widget'];

    builder(context, match) {
      return targetPage;
    }

    return NoAnimationMaterialPageRoute<void>(
      builder: (context) => builder(context, null),
      settings: settings,
    );
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
