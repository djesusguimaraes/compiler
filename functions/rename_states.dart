part of '../main.dart';

Set<Rule> renameStatesInRules({
  required Set<Rule> oldRules,
  int renameFactor = 1,
}) {
  var newRules = <Rule>{};

  for (var rule in oldRules) {
    var newStart = rule.start + renameFactor;

    var newEnds = <int>{};
    for (var end in rule.ends) {
      newEnds.add(end + renameFactor);
    }

    var newRule = rule.copyWith(start: newStart, ends: newEnds);
    newRules.add(newRule);
  }

  return newRules;
}
