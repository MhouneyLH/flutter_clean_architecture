import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties = const <dynamic>[];

  Failure([properties = const <dynamic>[]]);

  @override
  List<dynamic> get props => properties;
}

// General failures
// failures mapping exactly to exceptions
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
