
class Field {
  String label;
  String value;

  Field(this.label, this.value);

  Field.fromJson(Map<String, dynamic> json)
  : label = json['Label'],
  value = json['Value'];
}


