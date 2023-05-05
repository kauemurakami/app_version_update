import 'package:app_version_update/core/functions/convert_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('handles comparing versions of different lengths', () {
    var result = convertVersion(version: '1.0.0', versionStore: '1.0');
    expect(result, false);

    result = convertVersion(version: '1.3.0', versionStore: '1.4');
    expect(result, true);

    result = convertVersion(version: '1.3', versionStore: '1.4.0');
    expect(result, true);

    result = convertVersion(version: '1.3.0', versionStore: '1.4.0');
    expect(result, true);

    result = convertVersion(version: '1.4.0', versionStore: '1.3.0');
    expect(result, false);

    result = convertVersion(version: '1.4.0', versionStore: '1.3');
    expect(result, false);
  });
}
