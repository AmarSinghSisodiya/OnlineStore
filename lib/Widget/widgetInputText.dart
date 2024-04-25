import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final TextInputType keyboardType;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback onEditingComplete;
  final Widget? suffixIcon;
  final void Function(dynamic value)? onChanged;

  const WidgetTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.textCapitalization,
    this.inputFormatters,
    this.onEditingComplete = _dummyFunction, // Added a default function
    this.suffixIcon,
    this.onChanged,
  }) : super(key: key);

  static _dummyFunction() {} // Added a default function

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
          ),
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
