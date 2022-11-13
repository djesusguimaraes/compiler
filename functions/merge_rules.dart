part of '../main.dart';

Set<Rule> mergeRules(Set<Rule> oldRules) {
  var newRules = <Rule>{};
  for (var rule in oldRules) {
    bool isRuleInNewRules = newRules.any((element) {
      bool isStartEquals = element.start == rule.start;
      bool isSimbolEquals = element.simbol == rule.simbol;

      return isStartEquals && isSimbolEquals;
    });

    if (isRuleInNewRules) {
      var index = newRules.toList().indexWhere((element) {
        bool isStartEquals = element.start == rule.start;
        bool isSimbolEquals = element.simbol == rule.simbol;

        return isStartEquals && isSimbolEquals;
      });

      var actualRule = newRules.elementAt(index);
      var newRule = actualRule.copyWith(ends: {
        ...actualRule.ends,
        ...rule.ends,
      });

      newRules.remove(newRules.elementAt(index));
      newRules.add(newRule);
    } else {
      newRules.add(rule);
    }
  }
  return newRules;
}
