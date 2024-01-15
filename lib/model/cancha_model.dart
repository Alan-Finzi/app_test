class CanchaModel {
    int? id;
    String? name;

    CanchaModel({this.id, this.name});

    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'name': name,
        };
    }

    factory CanchaModel.fromMap(Map<String, dynamic> map) {
        return CanchaModel(
            id: map['id'],
            name: map['name'],
        );
    }
}