import 'package:greenpay/deferred_widget.dart';
import 'package:greenpay/pages/modal/modal_page.dart' deferred as modal;
import 'package:greenpay/pages/table/contacts_page.dart' deferred as contacts;
import 'package:greenpay/pages/toast/toast_page.dart' deferred as toast;
import 'package:greenpay/pages/tools/tools_page.dart' deferred as tools;
import 'package:flutter/material.dart';
import 'package:greenpay/pages/alerts/alert_page.dart' deferred as alert;
import 'package:greenpay/pages/button/button_page.dart' deferred as button;
import 'package:greenpay/pages/form/form_elements_page.dart'
    deferred as formElements;
import 'package:greenpay/pages/form/form_layout_page.dart'
    deferred as formLayout;
import 'package:greenpay/pages/auth/sign_in/sign_in_page.dart'
    deferred as signIn;
import 'package:greenpay/pages/auth/register/register_page.dart';
import 'package:greenpay/pages/calendar/calendar_page.dart'
    deferred as calendar;
import 'package:greenpay/pages/chart/chart_page.dart' deferred as chart;
import 'package:greenpay/pages/dashboard/ecommerce_page.dart';
import 'package:greenpay/pages/inbox/index.dart' deferred as inbox;
import 'package:greenpay/pages/invoice/invoice_page.dart' deferred as invoice;
import 'package:greenpay/pages/profile/profile_page.dart';
import 'package:greenpay/pages/resetpwd/reset_pwd_page.dart'
    deferred as resetPwd;
import 'package:greenpay/pages/settings/settings_page.dart';
import 'package:greenpay/pages/table/tables_page.dart' deferred as tables;
import 'package:greenpay/pages/transactions/transactions_page.dart';
import 'package:greenpay/pages/transactions/transaction_details_page.dart';
import 'package:greenpay/pages/impact/carbon_impact_page.dart';
import 'package:greenpay/pages/tips/green_tips_page.dart';
import 'package:greenpay/pages/splash_screen.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, String?);

final List<Map<String, Object>> MAIN_PAGES = [
  {'routerPath': '/splash', 'widget': const SplashScreen()},
  {'routerPath': '/', 'widget': const EcommercePage()},
  {
    'routerPath': '/calendar',
    'widget':
        DeferredWidget(calendar.loadLibrary, () => calendar.CalendarPage())
  },
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
    'routerPath': '/formElements',
    'widget': DeferredWidget(
        formElements.loadLibrary, () => formElements.FormElementsPage()),
  },
  {
    'routerPath': '/formLayout',
    'widget': DeferredWidget(
        formLayout.loadLibrary, () => formLayout.FormLayoutPage())
  },
  {
    'routerPath': '/signIn',
    'widget': DeferredWidget(signIn.loadLibrary, () => signIn.SignInWidget())
  },
  {'routerPath': '/register', 'widget': const RegisterPage()},
  {
    'routerPath': '/resetPwd',
    'widget':
        DeferredWidget(resetPwd.loadLibrary, () => resetPwd.ResetPwdWidget()),
  },
  {
    'routerPath': '/invoice',
    'widget': DeferredWidget(invoice.loadLibrary, () => invoice.InvoicePage())
  },
  {
    'routerPath': '/inbox',
    'widget': DeferredWidget(inbox.loadLibrary, () => inbox.InboxWidget())
  },
  {
    'routerPath': '/tables',
    'widget': DeferredWidget(tables.loadLibrary, () => tables.TablesPage())
  },
  {
    'routerPath': '/basicChart',
    'widget': DeferredWidget(chart.loadLibrary, () => chart.ChartPage())
  },
  {
    'routerPath': '/buttons',
    'widget': DeferredWidget(button.loadLibrary, () => button.ButtonPage())
  },
  {
    'routerPath': '/alerts',
    'widget': DeferredWidget(alert.loadLibrary, () => alert.AlertPage())
  },
  {
    'routerPath': '/contacts',
    'widget':
        DeferredWidget(contacts.loadLibrary, () => contacts.ContactsPage())
  },
  {
    'routerPath': '/tools',
    'widget': DeferredWidget(tools.loadLibrary, () => tools.ToolsPage())
  },
  {
    'routerPath': '/toast',
    'widget': DeferredWidget(toast.loadLibrary, () => toast.ToastPage())
  },
  {
    'routerPath': '/modal',
    'widget': DeferredWidget(modal.loadLibrary, () => modal.ModalPage())
  },
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
