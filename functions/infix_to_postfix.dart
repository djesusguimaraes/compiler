part of '../main.dart';

List<String>? infixToPostfix(List<String> infix) {
  bool hasOpenParentheses = false;

  List<String> postFix = [];
  List<Operator> stack = [];

  for (int index = 0; index < infix.length; index++) {
    String currentString = infix.elementAt(index);
    List<int> currentCodeUnits = currentString.codeUnits;
    int currentCodeUnit = 0;

    if (currentCodeUnits.length > 1) {
      postFix.add(currentString);
      continue;
    } else {
      currentCodeUnit = currentCodeUnits.first;
    }

    if (currentCodeUnit == open.codeUnit) {
      hasOpenParentheses = !hasOpenParentheses;
      stack.add(open);
      continue;
    }

    if (currentCodeUnit == close.codeUnit) {
      hasOpenParentheses = !hasOpenParentheses;
      var reversed = stack.reversed.toList();
      for (var element in reversed) {
        stack.removeLast();
        if (element.codeUnit == open.codeUnit) {
          break;
        } else {
          postFix.add(element.value);
        }
      }
      continue;
    }

    var op = itsOperator(currentCodeUnit);
    if (op == null) {
      postFix.add(currentString);
      continue;
    } else {
      if (stack.isNotEmpty) {
        var reversed = stack.reversed.toList();
        for (var element in reversed) {
          if (element.precedence >= op.precedence) {
            postFix.add(element.value);
            stack.pop();
          } else {
            break;
          }
        }
      }
      stack.add(op);
      continue;
    }
  }

  if (hasOpenParentheses) {
    return null;
  }

  if (stack.isNotEmpty) {
    var reversed = stack.reversed.toList();
    for (var element in reversed) {
      postFix.add(element.value);
      stack.pop();
    }
  }

  return postFix;
}
