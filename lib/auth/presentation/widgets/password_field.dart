import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_narrator/theme/sizes.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordcontroller;
  final Function(String value)? onFieldSubmitted;

  const PasswordField({
    super.key,
    required this.passwordcontroller,
    this.onFieldSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordcontroller,
      obscureText: _isObscure,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.next,
      onEditingComplete: () => TextInput.finishAutofillContext(),
      obscuringCharacter: '*',
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password can't be empty.";
        } else if (value.length < 6) {
          return "The password must be at least 6 characters.";
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: (() {
            setState(() {
              _isObscure = !_isObscure;
            });
          }),
        ),
        hintStyle: GoogleFonts.roboto(
          fontSize: Sizes.s16,
          color: const Color(0xFF605D66),
        ),
      ),
    );
  }
}
