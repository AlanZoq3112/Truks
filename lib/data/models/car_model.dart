class CarModel{
  final String? id;
  final String marca;
  final String modelo;
  final int precio;
  final int velocidad;

  //constructor
  CarModel({
    this.id,
    required this.marca,
    required this.modelo,
    required this.precio,
    required this.velocidad
  });

  //json a CarModel
  factory CarModel.fromJson(Map<String, dynamic> json){
    return CarModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      precio: json['precio'],
      velocidad: json['velocidad']
    );
  }

  //CarModel a json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'precio': precio,
      'velocidad': velocidad
    };
  }

}