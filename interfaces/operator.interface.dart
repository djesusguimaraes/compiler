enum OperatorType {
  binary,
  unary;

  bool get isBinary => this == OperatorType.binary;
}

abstract class Operator {
  late String value;
  late int precedence;
  late OperatorType type;
  late int codeUnit;

  num Function(num op1, num op2)? operation;

  Operator({
    required this.value,
    required this.precedence,
    this.operation,
    this.type = OperatorType.binary,
  }) {
    codeUnit = value.codeUnitAt(0);
  }
}
