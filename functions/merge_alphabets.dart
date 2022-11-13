part of '../main.dart';

List<String> mergeAlphabets(List<String> oldAlphabet) {
  var newAlphabet = <String>[];
  for (var simbol in oldAlphabet) {
    if (!newAlphabet.contains(simbol)) {
      newAlphabet.add(simbol);
    }
  }
  return newAlphabet;
}
