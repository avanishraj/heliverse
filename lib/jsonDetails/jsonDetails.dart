// ignore: file_names
// ignore_for_file: non_constant_identifier_names

class JsonDetails {
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? gender;
  String? avatar;
  String? domain;
  bool? available;
  bool? isSelected;

  JsonDetails({
    this.id, this.first_name, this.last_name, this.email, this.gender, this.avatar, this.domain, this.available, this.isSelected
  });

  JsonDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    avatar = json['avatar'];
    domain = json['domain'];
    available = json['available'];
    isSelected = false;    
  }
}