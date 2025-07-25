import 'package:flutter/material.dart';
import '../models/page_data.dart';

class PageItem extends StatelessWidget {
  final PageData pageData;

  const PageItem({super.key, required this.pageData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pageData.color,
      child: Center(
        child: Text(
          pageData.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
