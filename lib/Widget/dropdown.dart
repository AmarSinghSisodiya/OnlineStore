// dropdown_widget.dart
import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String selectedValue;
  final List<String> options;
  final String labelText;
  final void Function(String) onTap;
  final FocusNode focusNode;
  

  const DropdownWidget({
    required this.selectedValue,
    required this.options,
    required this.labelText,
    required this.onTap,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showDropdownMenu(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Text(
                  selectedValue,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showDropdownMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return _buildDropdownMenu(context);
      },
    );
  }

  Widget _buildDropdownMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Select',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              String value = options[index];

              return ListTile(
                title: Text(value),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                onTap: () {
                  onTap(value);
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 0,
                color: Colors.grey,
              );
            },
            itemCount: options.length,
          ),
        ),
      ],
    );
  }
}
