class AppUtils {
  static String toNormal(String input) {
    if(input == 'Å') {
      return 'A';
    }
    return input;
  }
}