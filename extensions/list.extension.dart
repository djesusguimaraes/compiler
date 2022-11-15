extension StackDescribber<T> on List<T> {
  T pop() {
    var item = last;
    removeLast();
    return item;
  }

  void replace({required T oldValue, required T newValue}) {
    removeWhere((element) => element == oldValue);
    add(newValue);
  }
}
