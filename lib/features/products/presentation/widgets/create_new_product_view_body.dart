import 'package:flutter/material.dart';

import 'create_product_content.dart';
import 'create_product_header.dart';

class CreateNewProductViewBody extends StatelessWidget {
  const CreateNewProductViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      children: [
        CreateProductHeader(),
        CreateProductContent(),
      ],
    );
  }
}
