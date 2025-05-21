class UserModel {

  String? username;
  String? accessToken;
  String? refreshToken;

  UserModel(
      {
        this.username,
        this.accessToken,
        this.refreshToken
      });

  UserModel.fromJson(Map<String, dynamic> json) {

    username = json['username'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }


}