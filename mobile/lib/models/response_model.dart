class ResponseModel<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;

  ResponseModel({
    this.success = true,
    required this.statusCode,
    required this.message,
    required this.data,
  });
}
