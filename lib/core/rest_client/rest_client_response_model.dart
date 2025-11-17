class RestClientResponseModel<T> {
  T? data;
  int? statusCode;
  String? statusMessage;

  RestClientResponseModel({
    this.data,
    this.statusCode,
    this.statusMessage,
  });
}

