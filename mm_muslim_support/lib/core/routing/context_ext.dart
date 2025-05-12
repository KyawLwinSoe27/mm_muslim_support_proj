import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// A collection of convenient navigation methods extending [BuildContext].
///
/// This extension provides methods to handle common navigation tasks such as
/// popping the current screen, navigating with clearing the back stack, and
/// pushing named routes with extra arguments.

extension ContextExt on BuildContext {
  /// Pops the current route off the navigator's stack.
  ///
  /// If [result] is provided, it will be returned to the previous route as the
  /// result of the `pop` operation.
  ///
  /// - [T] is the type of the result.
  /// - [result] is the optional result to return to the previous route.
  void back<T extends Object?>([T? result]) {
    return Navigator.of(this).pop(result);
  }

  /// Clears the entire navigator stack and navigates to the specified route.
  ///
  /// This method will clear all routes in the navigator stack and then push
  /// the specified [routeName]. It is useful for navigating to a new screen
  /// and ensuring that the user cannot navigate back to the previous screens.
  ///
  /// - [routeName] is the name of the route to navigate to.
  /// - [extra] is an optional object to pass as extra arguments to the new route.
  void navigateAndClearStack(String routeName, {Object? extra}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      while (Navigator.of(this).canPop()) {
        back();
      }
      pushReplacementNamed(routeName, extra: extra);
    });
  }

  void navigateAndClearStackWithoutWidgetsBinding(
    String routeName, {
    Object? extra,
  }) {
    while (Navigator.of(this).canPop()) {
      back();
    }
    pushReplacementNamed(routeName, extra: extra);
  }

  Future<T?> navigateAndRemoveCurrent<T extends Object?>(
    String routeName, {
    Object? extra,
  }) {
    back();
    return pushNamed(routeName, extra: extra);
  }

  /// Navigates to a named route and optionally provides extra arguments.
  ///
  /// This method pushes the specified [routeName] onto the navigator stack and
  /// optionally passes [extra] arguments to the new route. It returns a
  /// [Future] that completes to the result, if any, returned when the new route
  /// is popped.
  ///
  /// - [T] is the type of the result expected when the new route is popped.
  /// - [routeName] is the name of the route to navigate to.
  /// - [extra] is an optional object to pass as extra arguments to the new route.
  ///
  /// Returns a [Future] that completes to the result when the new route is popped.
  Future<T?> navigateWithPushNamed<T extends Object?>(
    String routeName, {
    Object? extra,
  }) {
    return pushNamed(routeName, extra: extra);
  }

  Future<T?> navigateWithPushNamedWithWidgetsBinding<T extends Object?>(
    String routeName, {
    Object? extra,
  }) {
    final Completer<T?> completer = Completer<T?>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pushNamed(routeName, extra: extra).then((value) {
        completer.complete(value as T?);
      });
    });

    return completer.future;
  }
}
