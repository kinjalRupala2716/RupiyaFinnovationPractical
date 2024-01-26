// my_test.dart
import 'package:flutter_test/flutter_test.dart';


int add(int a, int b) {
  return a + b;
}

void main() {
  test('Addition test', () {
    expect(add(1, 2), equals(3));
  });
}
