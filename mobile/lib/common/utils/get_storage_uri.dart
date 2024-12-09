import 'package:picmory/main.dart';

String getStorageUri(String path) {
  return '${remoteConfig.getString('api_host')}/$path';
}
