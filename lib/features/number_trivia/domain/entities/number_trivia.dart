import 'package:equatable/equatable.dart';

// sometimes passing Failure-Objects to usecases
// is better than throwing exceptions (s. failures.dart)
class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({
    required this.text,
    required this.number,
  });

  @override
  List<dynamic> get props => [text, number];
}
