class AuthValidators {
  AuthValidators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.name_required';
    }

    if (value.trim().length < 2) {
      return 'validation.name_min_length';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.email_required';
    }

    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'validation.email_invalid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password_required';
    }

    if (value.length < 8) {
      return 'validation.password_min_length';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'validation.password_uppercase';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'validation.password_lowercase';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'validation.password_number';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'validation.confirm_password_required';
    }

    if (value != password) {
      return 'validation.passwords_not_match';
    }

    return null;
  }
}
