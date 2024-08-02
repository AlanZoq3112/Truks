import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/car_repository.dart';
import '../../data/models/car_model.dart'; // Importa CarModel
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';

class CarListView extends StatelessWidget {
  const CarListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarCubit(
        carRepository: RepositoryProvider.of<CarRepository>(context),
      )..getCars(),
      child: const CarListScreen(),
    );
  }
}

class CarListScreen extends StatelessWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trucks List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addCar(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: carCubit.getCars,
            child: const Text('Get Trucks'),
          ),
          Expanded(
            child: BlocBuilder<CarCubit, CarState>(
              builder: (context, state) {
                if (state is CarLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CarSuccess) {
                  final cars = state.cars;
                  if (cars.isEmpty) {
                    return const Center(child: Text('No truks available. Please add a truck.'));
                  }
                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            car.marca,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Model: ${car.modelo}'),
                              Text('Traction: ${car.velocidad} '),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editCar(context, car);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  if (car.id != null) {
                                    _deleteCar(context, car.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CarError) {
                  return Center(child: Text(state.error));
                }
                return const Center(child: Text('Press the button to fetch trucks'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCar(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addCar(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final marcaController = TextEditingController();
        final modeloController = TextEditingController();
        final precioController = TextEditingController();
        final velocidadController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Truck'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Capacidad de carga (Kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: velocidadController,
                decoration: const InputDecoration(labelText: 'Tracción (Solo números)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newCar = CarModel(
                  marca: marcaController.text,
                  modelo: modeloController.text,
                  precio: int.tryParse(precioController.text) ?? 0,
                  velocidad: int.tryParse(velocidadController.text) ?? 0,
                );
                BlocProvider.of<CarCubit>(context).createCar(newCar);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editCar(BuildContext context, CarModel car) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final marcaController = TextEditingController(text: car.marca);
        final modeloController = TextEditingController(text: car.modelo);
        final precioController = TextEditingController(text: car.precio.toString());
        final velocidadController = TextEditingController(text: car.velocidad.toString());
        return AlertDialog(
          title: const Text('Edit Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Capacidad de carga (Kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: velocidadController,
                decoration: const InputDecoration(labelText: 'Tracción (Solo números)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedCar = CarModel(
                  id: car.id, // Ensure the ID is passed for the update
                  marca: marcaController.text,
                  modelo: modeloController.text,
                  precio: int.tryParse(precioController.text) ?? car.precio,
                  velocidad: int.tryParse(velocidadController.text) ?? car.velocidad,
                );
                BlocProvider.of<CarCubit>(context).updateCar(car.id!, updatedCar);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCar(BuildContext context, String carId) {
    BlocProvider.of<CarCubit>(context).deleteCar(carId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Truck deleted successfully'),
      ),
    );
  }
}
