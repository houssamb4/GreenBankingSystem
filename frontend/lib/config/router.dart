import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/screens/home/dashboard_screen.dart';
import 'package:frontend/screens/transactions/transactions_list_screen.dart';
import 'package:frontend/screens/transactions/add_transaction_screen.dart';
import 'package:frontend/screens/transactions/transaction_detail_screen.dart';
import 'package:frontend/screens/reports/reports_screen.dart';
import 'package:frontend/screens/advice/advice_screen.dart';
import 'package:frontend/screens/profile/profile_screen.dart';
import 'package:frontend/screens/layout/main_layout.dart';

// Router configuration
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/transactions',
          name: 'transactions',
          builder: (context, state) => const TransactionsListScreen(),
        ),
        GoRoute(
          path: '/transactions/add',
          name: 'add-transaction',
          builder: (context, state) => const AddTransactionScreen(),
        ),
        GoRoute(
          path: '/transactions/:id',
          name: 'transaction-detail',
          builder: (context, state) {
            final transactionId = state.pathParameters['id']!;
            return TransactionDetailScreen(transactionId: transactionId);
          },
        ),
        GoRoute(
          path: '/reports',
          name: 'reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/advice',
          name: 'advice',
          builder: (context, state) => const AdviceScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

// Route names for easy navigation
class Routes {
  static const String dashboard = '/';
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String transactionDetail = '/transactions/:id';
  static const String reports = '/reports';
  static const String advice = '/advice';
  static const String profile = '/profile';

  static String transactionDetailPath(String id) => '/transactions/$id';
}
