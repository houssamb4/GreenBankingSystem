import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greenpay/core/services/token_storage_service.dart';

class GraphQLService {
  static GraphQLService? _instance;
  static GraphQLService get instance => _instance ??= GraphQLService._();

  GraphQLService._();

  final String _endpoint = 'http://localhost:8080/graphql';

  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  GraphQLClient getClient() {
    final HttpLink httpLink = HttpLink(_endpoint);

    final AuthLink authLink = AuthLink(
      getToken: () async {
        final token = await _tokenStorage.getToken();
        return token != null ? 'Bearer $token' : null;
      },
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }

  ValueNotifier<GraphQLClient> getClientNotifier() {
    return ValueNotifier(getClient());
  }
}
