class UserModule {
  String? firstname;
  String? lastname;
  String? email;
  String? role;
  Groupe? groupe;
  Tuture? tuture;
  Photo? photo;

  UserModule(
      {this.firstname,
      this.lastname,
      this.email,
      this.role,
      this.groupe,
      this.tuture,
      this.photo});

  UserModule.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    role = json['role'];
    groupe = json['groupe'] != null ? Groupe.fromJson(json['groupe']) : null;
    tuture = json['tuture'] != null ? Tuture.fromJson(json['tuture']) : null;
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
  }
}

class Groupe {
  int? id;
  String? createdOn;
  String? code;
  String? libelle;

  Groupe({this.id, this.createdOn, this.code, this.libelle});

  Groupe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['createdOn'];
    code = json['code'];
    libelle = json['libelle'];
  }
}

class Tuture {
  int? id;
  String? createdOn;
  String? firstname;
  String? lastname;
  String? phone;
  String? email;
  String? address;

  Tuture(
      {this.id,
      this.createdOn,
      this.firstname,
      this.lastname,
      this.phone,
      this.email,
      this.address});

  Tuture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['createdOn'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
  }
}

class Photo {
  int? id;
  String? createdOn;
  String? uuid;
  String? name;
  String? downloadUri;
  String? type;
  int? size;

  Photo(
      {this.id,
      this.createdOn,
      this.uuid,
      this.name,
      this.downloadUri,
      this.type,
      this.size});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['createdOn'];
    uuid = json['uuid'];
    name = json['name'];
    downloadUri = json['downloadUri'];
    type = json['type'];
    size = json['size'];
  }
}
