class User {
  String name;
  String email;
  String password;
  String confirmPassword;
  String currentAddress;
  int isPartner;

  User(
      {this.currentAddress,
      this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.isPartner});
}
