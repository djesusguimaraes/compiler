part of '../main.dart';

RegExpOperator open = RegExpOperator.open();
RegExpOperator close = RegExpOperator.close();
RegExpOperator union = RegExpOperator.union();
RegExpOperator concat = RegExpOperator.concat();
RegExpOperator kleene = RegExpOperator.kleene();
RegExpOperator scape = RegExpOperator.scape();

final operators = [union, concat, kleene];

final codes = [
  open.codeUnit,
  close.codeUnit,
  union.codeUnit,
  concat.codeUnit,
  kleene.codeUnit
];

bool itsOpByCodeUnit(int codeUnit) => codes.contains(codeUnit);

Operator? itsOperator(int codeUnit) => [...operators, open, close]
    .firstWhereOrNull((element) => element.codeUnit == codeUnit);

RegExpOperator? itsRegExpOperator(int codeUnit) =>
    operators.firstWhereOrNull((element) => element.codeUnit == codeUnit);
