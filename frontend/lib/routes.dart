import 'package:greenpay/deferred_widget.dart';
import 'package:flutter/material.dart';
import 'package:greenpay/pages/auth/sign_in/sign_in_page.dart'
    deferred as signIn;
import 'package:greenpay/pages/auth/register/register_page.dart';
import 'package:greenpay/pages/dashboard/asana_dashboard_page.dart';
import 'package:greenpay/pages/profile/asana_profile_page.dart';
import 'package:greenpay/pages/settings/settings_page.dart';
import 'package:greenpay/pages/transactions/asana_transactions_page.dart';
import 'package:greenpay/pages/transactions/transaction_details_page.dart';
import 'package:greenpay/pages/impact/carbon_impact_page.dart';
import 'package:greenpay/pages/tips/green_tips_page.dart';
import 'package:greenpay/pages/splash_screen.dart';
import 'package:greenpay/core/services/auth_service.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, String?);

typedef _RouteBuilder = Widget Function(BuildContext);

final Map<String, _RouteBuilder> _staticRoutes = {
  '/splash': (_) => const SplashScreen(),
  '/': (_) => const AsanaDashboardPage(),
  '/dashboard': (_) => const AsanaDashboardPage(),
  '/profile': (_) => const AsanaProfilePage(),
  '/transactions': (_) => const AsanaTransactionsPage(),
  '/impact': (_) => const CarbonImpactPage(),
  '/tips': (_) => const GreenTipsPage(),
  '/settings': (_) => const SettingsPage(),
  '/signIn': (_) =>
      DeferredWidget(signIn.loadLibrary, () => signIn.SignInWidget()),
  '/register': (_) => const RegisterPage(),
};

final Set<String> _publicRoutes = {
  '/splash',
  '/signIn',
  '/register',
};

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
    final String rawPath = settings.name ?? '/';
    final String path = _normalizePath(rawPath);

    final _RouteMatch? match = _matchRoute(path, settings);
    if (match == null) {
      // Never throw from routing. Unknown routes go to sign-in.
      return NoAnimationMaterialPageRoute<void>(
        builder: (context) => _staticRoutes['/signIn']!(context),
        settings: const RouteSettings(name: '/signIn'),
      );
    }

    final bool isPublic = _publicRoutes.contains(match.routeName);

    return NoAnimationMaterialPageRoute<void>(
      builder: (context) {
        final Widget page = match.builder(context);
        return isPublic ? page : ProtectedRoute(child: page);
      },
      settings: match.settings,
    );
  }
}

String _normalizePath(String path) {
  // Backwards compatibility: old sign-up route name.
  if (path == '/signUp') return '/register';
  return path;
}

class _RouteMatch {
  final String routeName;
  final _RouteBuilder builder;
  final RouteSettings settings;

  _RouteMatch({
    required this.routeName,
    required this.builder,
    required this.settings,
  });
}

_RouteMatch? _matchRoute(String path, RouteSettings original) {
  final _RouteBuilder? staticBuilder = _staticRoutes[path];
  if (staticBuilder != null) {
    return _RouteMatch(
        routeName: path, builder: staticBuilder, settings: original);
  }

  // Support /transaction-details/<id>
  const String prefix = '/transaction-details/';
  if (path.startsWith(prefix)) {
    final String id = path.substring(prefix.length);
    return _RouteMatch(
      routeName: '/transaction-details/:id',
      builder: (_) =>
          TransactionDetailsPage(transactionId: id.isEmpty ? '1' : id),
      settings: RouteSettings(name: path, arguments: id),
    );
  }

  return null;
}

class ProtectedRoute extends StatelessWidget {
  const ProtectedRoute({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool loggedIn = snapshot.data == true;
        if (!loggedIn) {
          return DeferredWidget(
              signIn.loadLibrary, () => signIn.SignInWidget());
        }

        return child;
      },
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
