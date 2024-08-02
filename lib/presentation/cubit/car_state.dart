import 'package:equatable/equatable.dart';
import '../../data/models/car_model.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarSuccess extends CarState {
  final List<CarModel> cars;

  const CarSuccess({required this.cars});

  @override
  List<Object> get props => [cars];
} 

class CarError extends CarState {
  final String error;

  const CarError({required this.error});

  @override
  List<Object> get props => [error];
}
