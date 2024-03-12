import 'dart:io';

String? getBalancedSubstring(String str) {
  List<String> substrings = getAllSubstrings(str);

  String? longestBalancedSubstring;

  for (String sub in substrings) {
    if (isBalanced(sub) && sub.length > 1) {
      if (longestBalancedSubstring == null ||
          sub.length > longestBalancedSubstring.length) {
        longestBalancedSubstring = sub;
      }
    }
  }

  return longestBalancedSubstring;
}

List<String> getAllSubstrings(String str) {
  List<String> substrings = [];
  for (int i = 0; i < str.length; i++) {
    for (int j = i + 1; j <= str.length; j++) {
      substrings.add(str.substring(i, j));
    }
  }
  return substrings;
}

bool isBalanced(String str) {
  Set<String> uniqueChars = str.split('').toSet();
  if (uniqueChars.length != 2) return false;
  int count1 = str.split(uniqueChars.elementAt(0)).length - 1;
  int count2 = str.split(uniqueChars.elementAt(1)).length - 1;
  return count1 == count2;
}

void main() {
  stdout.write("Enter a string: ");
  String? input = stdin.readLineSync();

  if (input != null) {
    String? balancedSubstring = getBalancedSubstring(input);
    if (balancedSubstring != null) {
      print("The most balanced substring is: $balancedSubstring");
    } else {
      print("No balanced substring found.");
    }
  }
}
