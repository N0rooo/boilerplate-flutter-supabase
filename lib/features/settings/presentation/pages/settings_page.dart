import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate_flutter/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';
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
          return Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    final isDarkMode = themeState is ThemeSuccess &&
                        themeState.themeType == ThemeType.dark;
                    return ListTile(
                      title: const Text('Dark Mode'),
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (_) {
                          context.read<ThemeBloc>().add(ToggleThemeEvent());
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                AuthGradientButton(
                  buttonText: "Logout",
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogout());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
