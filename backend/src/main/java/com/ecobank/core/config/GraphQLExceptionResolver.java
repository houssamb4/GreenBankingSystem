package com.ecobank.core.config;

import graphql.GraphQLError;
import graphql.GraphqlErrorBuilder;
import graphql.schema.DataFetchingEnvironment;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.graphql.execution.DataFetcherExceptionResolverAdapter;
import org.springframework.stereotype.Component;

import java.util.Locale;

@Component
public class GraphQLExceptionResolver extends DataFetcherExceptionResolverAdapter {

    @Override
    protected GraphQLError resolveToSingleError(Throwable ex, DataFetchingEnvironment env) {
        // Surface useful error messages to the client instead of generic INTERNAL_ERROR ids.
        // Keep it conservative: map known user-facing cases; fall back to a generic message.

        if (ex instanceof DataIntegrityViolationException) {
            return GraphqlErrorBuilder.newError(env)
                    .message("Database constraint violation. Please verify your input and try again.")
                    .build();
        }

        String message = ex.getMessage();
        if (message != null) {
            String normalized = message.toLowerCase(Locale.ROOT);

            if (normalized.contains("email already exists")) {
                return GraphqlErrorBuilder.newError(env)
                        .message("An account with this email already exists")
                        .build();
            }

            if (normalized.contains("relation") && normalized.contains("does not exist")) {
                return GraphqlErrorBuilder.newError(env)
                        .message("Database schema is missing required tables. Enable DDL auto update or run migrations.")
                        .build();
            }

            if (normalized.contains("column") && normalized.contains("does not exist")) {
                return GraphqlErrorBuilder.newError(env)
                        .message("Database schema is missing required columns. Enable DDL auto update or run migrations.")
                        .build();
            }

            // If the backend intentionally throws RuntimeException with a safe message, expose it.
            if (ex instanceof RuntimeException) {
                return GraphqlErrorBuilder.newError(env)
                        .message(message)
                        .build();
            }
        }

        return GraphqlErrorBuilder.newError(env)
                .message("Request failed due to a server error")
                .build();
    }
}
