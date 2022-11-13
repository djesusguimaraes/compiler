part of '../main.dart';

List<String> treatInfix(String infix) {
  print('Entrada: $infix');
  infix = infix.replaceAll(' ', '');

  print('Entrada sem espaços: $infix');

  List<String> result = [];

  for (var index = 0; index < infix.length; index++) {
    int currentCode = infix.codeUnitAt(index);
    bool currentIsOp = itsOpByCodeUnit(currentCode);
    String currentString = String.fromCharCode(currentCode);

    if (index == infix.length - 1) {
      result.add(currentString);
      break;
    }

    int nextCode = infix.codeUnitAt(index + 1);
    bool nextIsOp = itsOpByCodeUnit(nextCode);
    String nextString = String.fromCharCode(nextCode);

    if (currentCode == scape.codeUnit) {
      List<String> parts = [currentString + nextString];
      if (!itsOpByCodeUnit(infix.codeUnitAt(index + 2))) {
        parts.add('.');
      }
      result.addAll(parts);
      index++;
      continue;
    }

    bool isTwoOperands = !currentIsOp && !nextIsOp;
    bool canConcatKleene = (currentCode == kleene.codeUnit) &&
        (!nextIsOp || nextCode == open.codeUnit);
    bool canConcatParentheses = (!currentIsOp && nextCode == open.codeUnit) ||
        (currentCode == close.codeUnit && !nextIsOp);

    bool hasToAddDot = isTwoOperands || canConcatKleene || canConcatParentheses;
    if (hasToAddDot) {
      result.addAll([currentString, '.']);
      continue;
    }

    if (currentIsOp || nextIsOp) {
      result.add(currentString);
      continue;
    }
  }

  print('Infixa Tratada: $result');
  return result;
}
