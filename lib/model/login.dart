class Login {
  int? code;
  bool? status;
  String? message;
  String? token;
  int? userID;
  String? userEmail;

  Login({
    this.code,
    this.status,
    this.message,
    this.token,
    this.userID,
    this.userEmail,
  });

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      code: obj["code"],
      status: obj["status"],
      message: obj["message"],
      token: obj["data"]?["token"],
      userID: obj["data"]?["id"],
      userEmail: obj["data"]?["email"],
    );
  }
}
