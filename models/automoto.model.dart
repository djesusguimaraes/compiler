part of '../main.dart';

class AFN {
  late Set<int> states;
  late Set<String> alphabet;
  late Set<Rule>? rules;
  late int? finals;
  late Set<KleeneClasp>? kleeneClasps;

  AFN({
    required this.states,
    required this.alphabet,
    this.rules,
    this.finals,
    this.kleeneClasps,
  }) {
    if (finals != null) {
      assert(
        states.contains(finals),
        "O estado final $finals deve estar no conjunto de estados",
      );
    }
    var newClasps = <KleeneClasp>{};
    for (var state in states) {
      var visited = clasp(state, {}) ?? {};
      newClasps.add(KleeneClasp(
        state: state,
        visited: visited,
      ));
    }
    kleeneClasps = newClasps;
  }

  factory AFN.base(String simbol) {
    return AFN(
        states: {0, 1},
        alphabet: {simbol},
        finals: 1,
        rules: {
          Rule(start: 0, simbol: simbol, ends: {1})
        });
  }

  factory AFN.kleene(AFN oldAutomaton) {
    var newStates = Set<int>.from(List.generate(oldAutomaton.countStates + 2, (index) => index));

    var newRules = renameStatesInRules(oldRules: oldAutomaton.rules!);

    var oldFinal = newStates.length - 2;
    var newFinal = newStates.length - 1;

    var newKleeneRules = {
      Rule(start: 0, simbol: empty, ends: {1, newFinal}),
      Rule(start: oldFinal, simbol: empty, ends: {newFinal, 1}),
    };

    newRules.addAll(newKleeneRules);

    return AFN(
      states: newStates,
      alphabet: oldAutomaton.alphabet,
      finals: newStates.last,
      rules: mergeRules(newRules),
    );
  }

  factory AFN.union(AFN firstAuto, AFN secondAuto) {
    var qtStates = firstAuto.countStates + secondAuto.countStates + 2;
    var newStates = Set<int>.from(List.generate(qtStates, (index) => index));

    var firstEnd = firstAuto.countStates;
    var secondStart = firstEnd + 1;
    var secondEnd = newStates.length - 2;
    var newFinal = newStates.length - 1;

    var firstRenamedRules = renameStatesInRules(oldRules: firstAuto.rules!);
    var secondRenamedRules =
        renameStatesInRules(oldRules: secondAuto.rules!, renameFactor: secondStart);

    var newUnionRules = {
      ...firstRenamedRules,
      ...secondRenamedRules,
      Rule(start: 0, simbol: empty, ends: {1, secondStart}),
      Rule(start: firstEnd, simbol: empty, ends: {newFinal}),
      Rule(start: secondEnd, simbol: empty, ends: {newFinal}),
    };

    return AFN(
      states: newStates,
      alphabet: Set.from({...firstAuto.alphabet, ...secondAuto.alphabet}),
      finals: newStates.last,
      rules: mergeRules(newUnionRules),
    );
  }

  factory AFN.concat(AFN firstAuto, AFN secondAuto) {
    var qtStates = (firstAuto.countStates + secondAuto.countStates) - 1;

    var newStates = Set<int>.from(List.generate(qtStates, (index) => index));

    var newRules = renameStatesInRules(
      oldRules: secondAuto.rules!,
      renameFactor: firstAuto.countStates - 1,
    );

    return AFN(
      states: newStates,
      alphabet: Set.from({...firstAuto.alphabet, ...secondAuto.alphabet}),
      finals: qtStates - 1,
      rules: mergeRules({...firstAuto.rules!, ...newRules}),
    );
  }

  int get initial => states.first;

  int get countStates => states.length;

  Set<int>? clasp(int state, Set<int> visited) {
    if (visited.contains(state)) return null;
    visited.add(state);

    var rule = rules?.firstWhereOrNull((rule) => rule.start == state && rule.simbol == empty);

    for (var end in rule?.ends ?? {}) {
      clasp(end, visited);
    }
    return visited;
  }

  void render() {
    print('Estados: $states');
    print('Alfabeto: $alphabet');
    print('Estado final: $finals\n');

    print('Automato (AFN):');
    var sortedRules = rules!.toList()..sort((a, b) => a.start.compareTo(b.start));
    for (var rule in sortedRules) {
      print('q${rule.start} - ${rule.simbol} > ${rule.ends}');
    }

    print('\n');

    if (kleeneClasps != null) {
      for (var clasp in kleeneClasps!) {
        print('Fecho-e(${clasp.state}): ${clasp.visited}');
      }
    }
  }

  AFN copyWith({
    Set<int>? states,
    Set<String>? alphabet,
    Set<Rule>? rules,
    int? finals,
  }) {
    return AFN(
      states: states ?? this.states,
      alphabet: alphabet ?? this.alphabet,
      rules: rules ?? this.rules,
      finals: finals ?? this.finals,
    );
  }
}

class Rule {
  int start;
  String simbol;
  Set<int> ends;

  Rule({
    required this.start,
    required this.simbol,
    required this.ends,
  });

  Rule copyWith({
    int? start,
    Set<int>? ends,
  }) =>
      Rule(
        start: start ?? this.start,
        simbol: simbol,
        ends: ends ?? this.ends,
      );
}

class KleeneClasp {
  int state;
  Set<int> visited;

  KleeneClasp({
    required this.state,
    this.visited = const {},
  });
}
