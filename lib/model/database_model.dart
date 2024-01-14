class User {
  int? id;
  String? name;
  String? study;
  String? admission;
  String? address;
  String? selectedImage;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['study'] = study!;
    mapping['admission'] = admission!;
    mapping['address'] = address!;
    mapping['selectedImage'] = selectedImage;

    return mapping;
  }
}
