import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static const String _baseUrl = 'http://localhost:8080/graphql';

  static ValueNotifier<GraphQLClient> client(String? token) {
    final HttpLink httpLink = HttpLink(_baseUrl);

    final AuthLink authLink = AuthLink(
      getToken: () async => token != null ? 'Bearer $token' : null,
    );

    final Link link = authLink.concat(httpLink);

    return ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }

  // GraphQL Queries
  static const String loginMutation = r'''
    mutation Login($email: String!, $password: String!) {
      login(input: { email: $email, password: $password }) {
        token
        refreshToken
        user {
          id
          email
          firstName
          lastName
          ecoScore
          totalCarbonSaved
          monthlyCarbonBudget
        }
      }
    }
  ''';

  static const String registerMutation = r'''
    mutation Register($email: String!, $password: String!, $firstName: String!, $lastName: String!) {
      register(input: {
        email: $email,
        password: $password,
        firstName: $firstName,
        lastName: $lastName
      }) {
        token
        refreshToken
        user {
          id
          email
          firstName
          lastName
          ecoScore
          totalCarbonSaved
          monthlyCarbonBudget
        }
      }
    }
  ''';

  static const String createTransactionMutation = r'''
    mutation CreateTransaction($amount: BigDecimal!, $category: String!, $merchant: String, $description: String) {
      createTransaction(input: {
        amount: $amount,
        category: $category,
        merchant: $merchant,
        description: $description
      }) {
        id
        amount
        currency
        category
        merchant
        description
        carbonFootprint
        transactionDate
        createdAt
      }
    }
  ''';

  static const String getCurrentUserQuery = r'''
    query GetCurrentUser {
      getCurrentUser {
        id
        email
        firstName
        lastName
        ecoScore
        totalCarbonSaved
        monthlyCarbonBudget
        createdAt
        updatedAt
      }
    }
  ''';

  static const String getUserTransactionsQuery = r'''
    query GetUserTransactions($userId: UUID!) {
      getUserTransactions(userId: $userId) {
        id
        amount
        currency
        category
        merchant
        description
        carbonFootprint
        transactionDate
        createdAt
      }
    }
  ''';

  static const String getCarbonStatsQuery = r'''
    query GetCarbonStats($userId: UUID!) {
      getCarbonStats(userId: $userId) {
        userId
        totalCarbon
        monthlyCarbon
        carbonBudget
        carbonPercentage
        ecoScore
      }
    }
  ''';

  static const String getCategoryBreakdownQuery = r'''
    query GetCategoryBreakdown($userId: UUID!) {
      getCategoryBreakdown(userId: $userId) {
        category
        totalCarbon
        totalAmount
        transactionCount
        percentage
      }
    }
  ''';
}
