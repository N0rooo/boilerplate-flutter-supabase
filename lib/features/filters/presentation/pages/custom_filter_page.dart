// lib/features/filters/presentation/pages/custom_filter_page.dart
import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:uuid/uuid.dart';

class CustomFilterPage extends StatefulWidget {
  final ColorFilterPreset? filter;
  const CustomFilterPage({Key? key, this.filter}) : super(key: key);

  @override
  _CustomFilterPageState createState() => _CustomFilterPageState();
}

class _CustomFilterPageState extends State<CustomFilterPage> {
  final _nameController = TextEditingController();
  final List<double> _matrix = List.from(FilterDefaultMatrix.defaultMatrix);
  bool _useSliders = false;

  final List<String> _matrixLabels = [
    'R -> R',
    'G -> R',
    'B -> R',
    'A -> R',
    'Constant R',
    'R -> G',
    'G -> G',
    'B -> G',
    'A -> G',
    'Constant G',
    'R -> B',
    'G -> B',
    'B -> B',
    'A -> B',
    'Constant B',
    'R -> A',
    'G -> A',
    'B -> A',
    'A -> A',
    'Constant A',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.filter != null) {
      _nameController.text = widget.filter!.name;
      _matrix.setAll(0, widget.filter!.matrix);
    }
  }

  void _deleteFilter() {
    if (widget.filter != null) {
      context.read<FilterBloc>().add(FilterDelete(widget.filter!));
      Navigator.pop(context);
    }
  }

  void _saveFilter() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a filter name')),
      );
      return;
    }

    final filter = ColorFilterPreset(
      id: widget.filter?.id ?? const Uuid().v4(),
      name: _nameController.text,
      matrix: _matrix,
      isCustom: true,
    );

    if (widget.filter == null) {
      // Create new filter
      context.read<FilterBloc>().add(FilterAddCustom(filter));
    } else {
      context.read<FilterBloc>().add(FilterUpdate(filter));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Filter'),
        actions: [
          IconButton(
            onPressed: _saveFilter,
            icon: const Icon(Icons.save),
          ),
          if (widget.filter != null)
            IconButton(
              onPressed: _deleteFilter,
              icon: const Icon(Icons.delete),
            ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(48.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Text('Use sliders'),
        //       Switch(
        //         value: _useSliders,
        //         onChanged: (value) {
        //           setState(() {
        //             _useSliders = value;
        //           });
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Filter Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Filter Matrix',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // _useSliders ? _buildMatrixSlider() : _buildMatrixEditor(),
              _buildMatrixSlider(),
              const SizedBox(height: 20),
              _buildPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatrixSlider() {
    return Column(
      children: [
        for (int index = 0; index < _matrix.length - 5; index++)
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(_matrixLabels[index]),
              ),
              Expanded(
                flex: 7,
                child: Slider(
                  value: _matrix[index],
                  min: 0,
                  max: 1,
                  divisions: 100,
                  label: '${_matrix[index].toStringAsFixed(2)}',
                  onChanged: (double value) {
                    setState(() {
                      _matrix[index] = value;
                    });
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Widget _buildMatrixEditor() {
  //   return Column(
  //     children: [
  //       for (int row = 0; row < 4; row++)
  //         Row(
  //           children: [
  //             for (int col = 0; col < 5; col++)
  //               Expanded(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(4.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         _matrixLabels[row * 5 + col],
  //                         style: const TextStyle(fontSize: 12),
  //                       ),
  //                       TextField(
  //                         keyboardType:
  //                             TextInputType.numberWithOptions(decimal: true),
  //                         decoration: const InputDecoration(
  //                           isDense: true,
  //                           contentPadding: EdgeInsets.symmetric(
  //                               horizontal: 8, vertical: 8),
  //                           border: OutlineInputBorder(),
  //                         ),
  //                         onChanged: (value) {
  //                           double? parsedValue = double.tryParse(value);
  //                           if (parsedValue != null) {
  //                             parsedValue = parsedValue.clamp(0.0, 1.0);
  //                             setState(() {
  //                               _matrix[row * 5 + col] = parsedValue ?? 0.0;
  //                             });
  //                           }
  //                         },
  //                         controller: TextEditingController(
  //                           text: _matrix[row * 5 + col].toStringAsFixed(2),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //     ],
  //   );
  // }

  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(_matrix),
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
