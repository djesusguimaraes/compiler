part of '../main.dart';

enum RegexOperatorType {
  union,
  concat,
  kleene,
  parenthesis,
  scape;

  bool get isUnion => this == RegexOperatorType.union;
  bool get isConcat => this == RegexOperatorType.concat;
  bool get isKleene => this == RegexOperatorType.kleene;
  bool get isScape => this == RegexOperatorType.scape;
  bool get isParenthesis => this == RegexOperatorType.parenthesis;
}

class RegExpOperator extends Operator {
  final RegexOperatorType regexOperatorType;

  RegExpOperator({
    required super.value,
    required super.precedence,
    required this.regexOperatorType,
  });

  RegExpOperator.union({this.regexOperatorType = RegexOperatorType.union})
      : super(value: '+', precedence: 1);

  RegExpOperator.concat({this.regexOperatorType = RegexOperatorType.concat})
      : super(value: '.', precedence: 2);

  RegExpOperator.kleene({this.regexOperatorType = RegexOperatorType.kleene})
      : super(value: '*', precedence: 3, type: OperatorType.unary);

  RegExpOperator.scape({this.regexOperatorType = RegexOperatorType.scape})
      : super(value: r'\', precedence: 0);

  RegExpOperator.open({this.regexOperatorType = RegexOperatorType.parenthesis})
      : super(value: '(', precedence: 0);
  RegExpOperator.close({this.regexOperatorType = RegexOperatorType.parenthesis})
      : super(value: ')', precedence: 0);
}
