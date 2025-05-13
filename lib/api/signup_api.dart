class SignupState {
  static String email = '';
  static String userName = '';
  static String password = '';

  static void reset() {
    email = '';
    userName = '';
    password = '';
  }

  static Map<String, String> toJson() {
    return {
      'email': email,
      'userName': userName,
      'password': password,
    };
  }
}
