part of '../main.dart';

void toAfd(AFN oldAutomaton) {
  final port = ReceivePort();
  var firstClaspStates = oldAutomaton.kleeneClasps!.first.visited;
}

// Find relation between a state and each given simbol
findRelation(AFN automaton, List<int> claspStates) {
  bool canIterateOverRules = automaton.rules != null && automaton.rules!.isNotEmpty;

  var relations = <String, List<Rule>>{};
  for (var state in claspStates) {
    for (var simbol in automaton.alphabet) {
      var findedRules = <Rule>[];
      if (canIterateOverRules) {
        for (var rule in automaton.rules!) {
          if (rule.start == state && rule.simbol == simbol) {
            findedRules.add(rule);
          }
        }
      }
      if (findedRules.isEmpty) {
        continue;
      }
      relations[simbol] = findedRules;
    }
  }
  return relations;
}
