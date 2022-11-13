part of '../main.dart';

AFN? evaluateAutomaton(List<String> postFixed) {
  List<AFN> stack = [];
  for (int index = 0; index < postFixed.length; index++) {
    String currentString = postFixed.elementAt(index);
    List<int> currentCodeUnits = currentString.codeUnits;
    int currentCodeUnit = 0;

    if (currentCodeUnits.length > 1) {
      stack.add(AFN.base(currentString));
      continue;
    } else {
      currentCodeUnit = currentCodeUnits.first;
    }

    var op = itsRegExpOperator(currentCodeUnit);
    if (op == null) {
      stack.add(AFN.base(currentString));
      continue;
    } else if (stack.isNotEmpty) {
      var secondAuto = stack.pop();

      if (op.type.isBinary) {
        if (stack.isNotEmpty) {
          var firstAuto = stack.pop();

          if (op.regexOperatorType.isConcat) {
            stack.add(AFN.concat(firstAuto, secondAuto));
            continue;
          }

          if (op.regexOperatorType.isUnion) {
            stack.add(AFN.union(firstAuto, secondAuto));
            continue;
          }
        } else {
          return null;
        }
      } else {
        if (op.regexOperatorType.isKleene) {
          stack.add(AFN.kleene(secondAuto));
          continue;
        }
      }
    } else {
      return null;
    }
  }

  return (stack.length != 1) ? null : stack.first;
}
