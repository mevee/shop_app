import 'package:flutter/material.dart';
import 'package:shop_app/data/network/app_colors.dart';

class GenericDropdown<T> extends StatelessWidget {
  final List<T> options;
  final T? selectedOption;
  final Function(T?) onChanged;
  final String? hintText;
  final InputDecoration? decoration;

  const GenericDropdown({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    this.hintText,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedOption,
      onChanged: onChanged,
      items: options.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString(),style: TextStyle(fontSize: 14,color: AppColors.blackText),), // Convert to string
        );
      }).toList(),
      decoration: decoration ?? InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText ?? 'Select an option',
        hintStyle:  TextStyle(fontSize: 14,color: AppColors.textGrey),
      ),
    );
  }
}