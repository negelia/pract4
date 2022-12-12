import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/main.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

//события счётчика
class CounterCubit extends Cubit<CounterInitial> {
  CounterCubit() : super(CounterInitial(counterValue: 0));

  void plus(int value) {
    emit(CounterInitial(counterValue: state.counterValue + value));
  }

  void minus(int value) {
    emit(CounterInitial(counterValue: state.counterValue - value));
  }

  void load() {
    emit(CounterInitial(counterValue: state.counterValue));
  }
}

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.light());

  void changeTheme(bool reload) {
    if (reload) {
      if (state == ThemeData.light()) {
        emit(ThemeData.dark());
      } else {
        emit(ThemeData.light());
      }
    } else {
      if (state == ThemeData.light()) {
        emit(ThemeData.light());
      } else {
        emit(ThemeData.dark());
      }
      return;
    }
  }
}
