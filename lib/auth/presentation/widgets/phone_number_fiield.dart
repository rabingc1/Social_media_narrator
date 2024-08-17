import 'package:flutter/material.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.phoneController,
    required this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.enableded,
  });

  final TextEditingController phoneController;
  final TextInputAction textInputAction;
  final Function(String value)? onFieldSubmitted;
  final bool enabled;
  final bool? enableded;

  final TextInputType keyboardType = TextInputType.number;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: phoneController,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      keyboardType: keyboardType,
      style: enabled ? null : const TextStyle(color: Colors.grey),
      autofillHints: const [AutofillHints.telephoneNumber],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone Number can\'t be empty.';
        } else if (!RegExp(r'^[9][78]\d{8}$').hasMatch(value)) {
          return 'Please enter a valid Nepali phone number.';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
