class UserModel {

  String? username;
  String? token;

  UserModel(
      {
        this.username,
        this.token});

  UserModel.fromJson(Map<String, dynamic> json) {

    username = json['username'];
    token = json['token'];
  }


}

//sta sve treba iz jsona izvadit idk