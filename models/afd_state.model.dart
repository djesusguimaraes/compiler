part of '../main.dart';

class AFD {
  final Set<AFDState> states;
  final Set<String> alphabet;
  final Set<AFDRule>? rules;
  final Set<AFDState>? finals;

  AFD({
    required this.states,
    required this.alphabet,
    this.rules,
    this.finals,
  });

  factory AFD.fromAFN(AFN afn) {
    int label = 0;
    Set<AFDState> newStates = {};
    Set<AFDRule> newRules = {};
    var clasp = afn.kleeneClasps!.first;
    Set<int> tovisite = clasp.visited;
    var initState = AFDState(label, afnStates: tovisite);

    Set<int> notVisited = Set.from(afn.states.where((element) => !clasp.visited.contains(element)));
    buildRules(afn, initState, newStates, newRules, notVisited, tovisite);

    return AFD(states: {}, alphabet: {});
  }

  AFD copyWith({
    Set<AFDState>? states,
    Set<String>? alphabet,
    Set<AFDRule>? rules,
    Set<AFDState>? finals,
  }) {
    return AFD(
      states: states ?? this.states,
      alphabet: alphabet ?? this.alphabet,
      rules: rules ?? this.rules,
      finals: finals ?? this.finals,
    );
  }

  void render() {
    print("AFD");
    print(
        "Estados: ${states.map((e) => e.label).join(", ")} - ${states.map((e) => e.afnStates).join(", ")}");
    print("Alfabeto: ${alphabet.join(", ")}");
    print("Estado final: ${finals?.map((e) => e.label).join(", ")}");
    for (var rule in rules!) {
      print("q${rule.start.label} - ${rule.simbol} > q${rule.end.label}");
    }
  }

  @override
  String toString() => 'AFD(states: $states, alphabet: $alphabet, rules: $rules, finals: $finals)';
}

Set<dynamic> buildRules(
  AFN afn,
  AFDState initState,
  Set<AFDState> newStates,
  Set<AFDRule> newRules,
  Set<int> notVisited,
  Set<int> tovisite,
) {
  print("\n\n");
  print("Estados: ${initState.label} - ${initState.afnStates}");
  print("0 $notVisited | $tovisite");
  for (var simbol in afn.alphabet) {
    Map<int, Set<int>> relation = {};
    for (var state in tovisite) {
      relation.putIfAbsent(state, () => {});

      if (!notVisited.contains(state)) {
        for (var rule in afn.rules!) {
          if (rule.start == state && rule.simbol == simbol) {
            relation.update(state, (value) => Set.from({...value, ...rule.ends}));
          }
        }
      }

      print(state);
      notVisited.remove(state);
    }
    Set<int> newVisiteds = {};
    relation.values.forEach((element) {
      if (element.isNotEmpty) {
        print("relation ($simbol): $element");
        for (var state in element) {
          var result = afn.kleeneClasps?.firstWhereOrNull((element) => element.state == state);
          if (result != null) {
            print("result: ${result.visited}");
            newVisiteds.addAll(result.visited);
          }
        }
      }
    });
    var endState = AFDState(0, afnStates: newVisiteds);
    newStates.add(endState);
    newRules.add(AFDRule(initState, simbol, endState));
    print("$simbol $notVisited | $newVisiteds");
  }
  // buildRules(afn, endState, newStates, newRules, notVisited, newVisiteds);
  return {newStates, newRules};
}

class AFDRule {
  final AFDState start;
  final String simbol;
  final AFDState end;

  AFDRule(this.start, this.simbol, this.end);

  AFDRule copyWith({
    AFDState? start,
    String? simbol,
    AFDState? end,
  }) {
    return AFDRule(
      start ?? this.start,
      simbol ?? this.simbol,
      end ?? this.end,
    );
  }
}

class AFDState {
  late String uuid;
  final int label;
  final Set<int> afnStates;
  final Set<Rule> rules;
  final bool isFinal;

  AFDState(
    this.label, {
    this.afnStates = const {},
    this.rules = const {},
    this.isFinal = false,
  }) {
    uuid = DateTime.now().microsecondsSinceEpoch.toString();
  }

  factory AFDState.simple(int label, Set<int> afnStates) => AFDState(label, afnStates: afnStates);

  factory AFDState.fromAFNState(
    KleeneClasp kleeneClasp, {
    Set<Rule> rules = const {},
  }) {
    return AFDState(
      kleeneClasp.state,
      afnStates: kleeneClasp.visited,
      rules: rules,
    );
  }

  AFDState copyWith({int? label, Set<int>? afnStates, Set<Rule>? rules}) {
    return AFDState(
      label ?? this.label,
      afnStates: afnStates ?? this.afnStates,
      rules: rules ?? this.rules,
    );
  }
}
