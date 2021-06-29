class ValidatorHelper {
  static String validatorEmpty({String value, String label}) {
    if (value.isEmpty)
      return '$label tidak boleh kosong';
    else
      return null;
  }

  static String validatorUsername({String value, String label}) {
    if (value.isEmpty)
      return '$label tidak boleh kosong';
    else if (value.length <= 1)
      return '$label harus lebih dari 1 huruf';
    else
      return null;
  }

  static String validateEmail({String value}) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return 'Email tidak boleh kosong';
    else if (!regex.hasMatch(value))
      return 'masukkan email yang valid';
    else
      return null;
  }

  static String validatorPassword({String value, String label}) {
    if (value.isEmpty)
      return '$label tidak boleh kosong';
    else if (value.length < 8)
      return '$label harus lebih dari 8 karakter';
    else
      return null;
  }

  static String validatorPhoneNum({String value, String label}) {
    if (value.isEmpty)
      return '$label tidak boleh kosong';
    else if (value.length < 10)
      return '$label harus lebih dari 10 digit';
    else if (value.length > 13)
      return '$label tidak boleh lebih dari 12 digit';
    else
      return null;
  }
}
