class User {
  int id, userLevel;
  String name, userName, email, password = "";
  bool alterSuperAdmin, alterAdmin, alterSalesPerson, alterChannel, alterProduct;

  User(
      {required this.id,
      required this.name,
      required this.userName,
      required this.email,
      required this.userLevel,
      required this.alterSuperAdmin,
      required this.alterAdmin,
      required this.alterSalesPerson,
      required this.alterChannel,
      required this.alterProduct});

  factory User.fromJson(Map json) {
    return User(
        id: json['user_id'],
        name: json['user_full_name'],
        email: json['user_email'] ?? "",
        userName: json['user_user_name'],
        userLevel: json['user_user_level'],
        alterSuperAdmin: json['user_permissions']['alterSuperAdmin'],
        alterAdmin: json['user_permissions']['alterAdmin'],
        alterSalesPerson: json['user_permissions']['alterSalesPerson'],
        alterProduct: json['user_permissions']['alterProduct'],
        alterChannel: json['user_permissions']['alterChannel']);
  }
}
