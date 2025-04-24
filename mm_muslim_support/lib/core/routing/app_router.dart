import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_muslim_support/module/fatwa/presentation/fatwa_page.dart';
import 'package:mm_muslim_support/module/home/presentation/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home Route
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      // Login Route
      GoRoute(
        path: '/login',
        builder: (context, state) => const FatwaPage(),
      )
    ],
    // Optional: Custom error page route (404-like)
    errorPageBuilder: (context, state) {
      return MaterialPage<void>(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found!')),
        ),
      );
    },
  );
}
