import 'package:bloc/bloc.dart';
import 'package:cars/data/models/car_model.dart';
import 'package:cars/data/repository/car_repository.dart';
import 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  final CarRepository carRepository;

  CarCubit({required this.carRepository}) : super(CarInitial());

  Future<void> createCar(CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.createCar(car);
      final cars = await carRepository.getCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(error: e.toString()));
    }
  }

  Future<void> getCars() async {
    try {
      emit(CarLoading());
      final cars = await carRepository.getCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(error: e.toString()));
    }
  }

  Future<void> getCar(String id) async {
    try {
      emit(CarLoading());
      final car = await carRepository.getCar(id);
      emit(CarSuccess(cars: [car]));
    } catch (e) {
      emit(CarError(error: e.toString()));
    }
  }

  Future<void> updateCar(String id, CarModel car) async {
    try {
      emit(CarLoading());
      await carRepository.updateCar(car);
      final cars = await carRepository.getCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(error: e.toString()));
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      emit(CarLoading());
      await carRepository.deleteCar(id);
      final cars = await carRepository.getCars();
      emit(CarSuccess(cars: cars));
    } catch (e) {
      emit(CarError(error: e.toString()));
    }
  }
}
