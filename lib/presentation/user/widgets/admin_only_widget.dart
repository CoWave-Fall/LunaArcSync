import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_cubit.dart';
import 'package:luna_arc_sync/presentation/auth/cubit/auth_state.dart';

class AdminOnlyWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const AdminOnlyWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isAdmin = state.maybeWhen(
          authenticated: (_, isAdmin, __) => isAdmin,
          orElse: () => false,
        );

        if (isAdmin) {
          return child;
        } else {
          return fallback ?? const SizedBox.shrink();
        }
      },
    );
  }
}

class AdminOnlyBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? fallbackBuilder;

  const AdminOnlyBuilder({
    super.key,
    required this.builder,
    this.fallbackBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isAdmin = state.maybeWhen(
          authenticated: (_, isAdmin, __) => isAdmin,
          orElse: () => false,
        );

        if (isAdmin) {
          return builder(context);
        } else {
          return fallbackBuilder?.call(context) ?? const SizedBox.shrink();
        }
      },
    );
  }
}
