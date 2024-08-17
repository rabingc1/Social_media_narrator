import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RePasswordField extends StatefulWidget {
  final TextEditingController repasswordController;
  final TextEditingController originalPasswordController;
  final Function(String value)? onFieldSubmitted;

  const RePasswordField({
    super.key,
    required this.repasswordController,
    required this.originalPasswordController,
    this.onFieldSubmitted,
  });

  @override
  State<RePasswordField> createState() => _RePasswordFieldState();
}

class _RePasswordFieldState extends State<RePasswordField> {
  bool _isObscure = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.repasswordController.addListener(_validatePasswords);
    widget.originalPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    widget.repasswordController.removeListener(_validatePasswords);
    widget.originalPasswordController.removeListener(_validatePasswords);
    super.dispose();
  }

  void _validatePasswords() {
    final originalPassword = widget.originalPasswordController.text;
    final repassword = widget.repasswordController.text;

    setState(() {
      if (repassword.isEmpty) {
        _errorMessage = "Re-Password can't be empty.";
      } else if (repassword != originalPassword) {
        _errorMessage = "The passwords do not match.";
      } else {
        _errorMessage = '';
      }
    });

    debugPrint('Original Password: $originalPassword');
    debugPrint('Re-Password: $repassword');
    debugPrint('Error Message: $_errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.repasswordController,
      obscureText: _isObscure,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      onEditingComplete: () => TextInput.finishAutofillContext(),
      obscuringCharacter: '*',
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: 'Re-Password',
        fillColor: Colors.white,
        filled: true,
        errorText: _errorMessage.isEmpty ? null : _errorMessage,
        // enabledBorder: OutlineInputBorder(
        //     // borderSide: BorderSide(color: Colors.grey.shade400),
        //     // borderRadius: BorderRadius.circular(8.0),
        //     ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}
