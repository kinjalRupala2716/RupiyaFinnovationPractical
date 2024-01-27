

class SeatsModel {
    final String? column;
    final String? name;
    final String? row;

    SeatsModel({
        this.column,
        this.name,
        this.row,
    });

    factory SeatsModel.fromJson(Map<String, dynamic> json) => SeatsModel(
        column: json["column"],
        name: json["name"],
        row: json["row"],
    );

   
}
