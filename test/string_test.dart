import 'package:flutter_test/flutter_test.dart';
import 'package:lidea/extension.dart';

void main() {
  test('String Extension', () {
    expect("ab", "[ba]".bracketsHack());
    expect("http://github.com", "git+http://github.com".gitHack());
    expect("https://github.com/ab/cd", "git+/ab/cd".gitHack());
    expect("https://github.com/ab/cd", "git+/[dc/ba]".gitHack());
    print('abc');
  });
}
