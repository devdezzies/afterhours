import 'package:afterhours/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats IDR without leading separators', () {
    expect(formatIdr(290), 'RP 290');
    expect(formatIdr(190000), 'RP 190.000');
    expect(formatIdr(1190550), 'RP 1.190.550');
    expect(formatIdr(0), 'RP 0');
  });
}
