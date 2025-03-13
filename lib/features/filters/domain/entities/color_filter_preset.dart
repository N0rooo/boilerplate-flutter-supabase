class ColorFilterPreset {
  final String id;
  final String name;
  final List<double> matrix;
  final bool isCustom;

  ColorFilterPreset(
      {required this.id,
      required this.name,
      required this.matrix,
      this.isCustom = false});

  Object? toJson() {
    return {
      'id': id,
      'name': name,
      'matrix': matrix,
      'isCustom': isCustom,
    };
  }

  static ColorFilterPreset fromJson(Map<String, dynamic> json) {
    return ColorFilterPreset(
      id: json['id'],
      name: json['name'],
      matrix: json['matrix'],
      isCustom: json['isCustom'],
    );
  }
}
