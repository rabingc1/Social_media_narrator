import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required this.namecontroller,
    required this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  final TextEditingController namecontroller;
  final TextInputAction textInputAction;
  final Function(String value)? onFieldSubmitted;
  final bool enabled;
  final TextInputType keyboardType = TextInputType.name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: namecontroller,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      style: enabled ? null : const TextStyle(color: Colors.grey),
      autofillHints: const [AutofillHints.name],
      validator: (value) {
        if (value!.isEmpty) {
          return 'Name can\'t be empty.';
        }

        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Full Name',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
