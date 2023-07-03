part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<dynamic> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  // solid -> S -> no conversion here
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);

  // needed as it extends from NumberTriviaEvent
  @override
  List<dynamic> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
