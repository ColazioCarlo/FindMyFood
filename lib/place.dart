class PlaceModel {

  String? name;
  String? email;
  String? phone;
  String? address;
  int? parkingTotal;
  int? parkingFree;
  String? opis;
  double? rating;
  String? photoUri;

  PlaceModel(
    {
      this.name,
      this.email,
      this.phone,
      this.address,
      this.parkingTotal,
      this.parkingFree,
      this.opis,
      this.rating,
      this.photoUri,
    }
  );

  PlaceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    parkingTotal = json['parking_total'];
    parkingFree = json['parking_free'];
    opis = json['opis'];
    rating = json['rating'];
    photoUri = json['photoUri'];
  }
}