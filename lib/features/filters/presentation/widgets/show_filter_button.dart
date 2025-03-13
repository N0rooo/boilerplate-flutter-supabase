import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowFilterButton extends StatelessWidget {
  final FilterState filterState;
  const ShowFilterButton({super.key, required this.filterState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FilterBloc>().add(FilterToggle());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: AppPallete.gradient1,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          filterState.isFilterActive ? "Hide Filters" : "Show Filters",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
