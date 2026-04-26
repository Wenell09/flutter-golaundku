part of 'navigation_bloc.dart';

class NavigationEvent {}

class ChangePage extends NavigationEvent {
  final int index;

  ChangePage(this.index);
}
