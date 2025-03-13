import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate_flutter/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return AuthGradientButton(
            buttonText: "Logout",
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
            },
          );
        },
      ),
    );
  }
}
