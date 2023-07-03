part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<dynamic> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({required this.trivia});

  @override
  List<dynamic> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({required this.message});

  @override
  List<dynamic> get props => [message];
}
