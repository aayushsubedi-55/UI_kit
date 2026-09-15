class ApiConstant {
  ApiConstant._(); // Private constructor to prevent instantiation

  // Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';

  // Content Types
  static const String applicationJson = 'application/json';
  static const String bearer = 'Bearer';

  // HTTP Status code
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  static const int internalServerError = 500;
}
