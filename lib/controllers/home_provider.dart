import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final customerHomeIndexProvider = NotifierProvider<HomeIndexNotifier, int>(() {
  return HomeIndexNotifier();
});

final tailorHomeIndexProvider = NotifierProvider<HomeIndexNotifier, int>(() {
  return HomeIndexNotifier();
});
