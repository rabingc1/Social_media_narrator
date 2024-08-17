import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.emailcontroller,
    required this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.enableded,
  });

  final TextEditingController emailcontroller;
  final TextInputAction textInputAction;
  final Function(String value)? onFieldSubmitted;
  final bool enabled;
  final bool? enableded;

  final TextInputType keyboardType = TextInputType.emailAddress;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailcontroller,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      keyboardType: keyboardType,
      style: enabled ? null : const TextStyle(color: Colors.grey),
      autofillHints: const [AutofillHints.email],
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email can\'t be empty.';
        } else if (!RegExp(
                r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z\s]{2,5})$')
            .hasMatch(value)) {
          return 'Please enter a valid email.';
        }

        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Email',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
