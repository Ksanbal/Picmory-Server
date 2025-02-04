import 'package:picmory/main.dart';

String getStorageUri(String path) {
  return '${remoteConfig.getString('storage_host')}/$path';
}
