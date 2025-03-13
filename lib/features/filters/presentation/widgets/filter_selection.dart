import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/custom_filter_page.dart';

class FilterSelection extends StatelessWidget {
  final List<ColorFilterPreset> filters;
  final int selectedFilterIndex;
  final Function(int) onFilterSelected;

  const FilterSelection({
    super.key,
    required this.filters,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length + 1,
        itemBuilder: (context, index) {
          if (index == filters.length) {
            // Add new filter button
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomFilterPage(),
                  ),
                );
              },
              child: _buildAddFilterButton(),
            );
          } else {
            // Existing filter
            return _buildFilterItem(context, index);
          }
        },
      ),
    );
  }

  Widget _buildAddFilterButton() {
    return ClipRRect(
      child: Container(
        width: 80,
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppPallete.gradient1,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildFilterItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => onFilterSelected(index),
      onLongPress: () {
        // Show options to update or delete the filter
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Manage Filter'),
            content:
                Text('Choose an action for the filter: ${filters[index].name}'),
            actions: [
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomFilterPage(filter: filters[index]),
                      ));
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  context.read<FilterBloc>().add(FilterDelete(filters[index]));
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
      child: ClipRRect(
        child: Container(
          width: 80,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedFilterIndex == index
                  ? AppPallete.gradient1
                  : AppPallete.whiteColor,
              width: selectedFilterIndex == index ? 3 : 1,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(filters[index].matrix),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black54,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    filters[index].name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
