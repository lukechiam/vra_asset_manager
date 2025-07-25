import 'package:flutter/material.dart';

class ClickIcon extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color selectedColor;
  final bool selected;
  final int id;
  final ValueChanged<bool?>? onChanged;

  const ClickIcon({
    super.key,
    this.onChanged,
    required this.id,
    required this.title,
    required this.iconData,
    this.selectedColor = Colors.green,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selected;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            RepaintBoundary(
              child: Ink(
                decoration: ShapeDecoration(
                  color: isSelected ? selectedColor : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: IconButton(
                  icon: Icon(iconData),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isSelected = !isSelected;
                      onChanged?.call(isSelected);
                    });
                  },
                ),
              ),
            ),
            Text(title),
          ],
        );
      },
    );
  }
}
