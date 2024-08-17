import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  const LocationField({
    super.key,
    required this.locationcontroller,
    required this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  final TextEditingController locationcontroller;
  final TextInputAction textInputAction;
  final Function(String value)? onFieldSubmitted;
  final bool enabled;
  final TextInputType keyboardType = TextInputType.streetAddress;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: locationcontroller,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      style: enabled ? null : const TextStyle(color: Colors.grey),
      autofillHints: const [AutofillHints.location],
      validator: (value) {
        if (value!.isEmpty) {
          return 'location can\'t be empty.';
        }

        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Location',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
