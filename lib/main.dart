import 'package:flutter/material.dart';
import 'package:flutter_application_7/cubit/counter_cubit.dart';
import 'package:flutter_application_7/conf.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

ThemeData themeData = ThemeData();
String message = "";
List<String> text = [];
int value = 0;
int count = 0;
bool tapped = false;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //@override
  // void update() {
  //   currentTheme.addListener(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CounterCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          themeData = state;

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state,
              //home: MyHomePage(),
              home: BlocProvider(
                create: (context) => CounterCubit(),
                child: MyStatefulWidget(),
              ));
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  //MyHomePage({super.key});

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, CounterInitial>(
              builder: (context, state) {
                if (!tapped) {
                  if (state.counterValue > 0 && state.counterValue != 0) {
                    if (themeData == ThemeData.dark()) {
                      text.add("${state.counterValue} - тёмная сторона");
                    } else {
                      text.add("${state.counterValue} - светлая сторонка");
                    }
                  }
                }
                tapped = false;

                if (state.counterValue < 0) {
                  return const Text("значение не может быть меньше нуля");
                }
                return Text(state.counterValue.toString());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        child: const Text("-"),
                        onPressed: () {
                          if (themeData == ThemeData.dark()) {
                            BlocProvider.of<CounterCubit>(context).minus(2);
                          } else {
                            BlocProvider.of<CounterCubit>(context).minus(1);
                          }
                        })),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        child: const Text("+"),
                        onPressed: () {
                          if (themeData == ThemeData.dark()) {
                            BlocProvider.of<CounterCubit>(context).plus(2);
                          } else {
                            BlocProvider.of<CounterCubit>(context).plus(1);
                          }
                        })),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 500,
                  height: 400,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: text.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BlocBuilder<CounterCubit, CounterInitial>(
                            builder: (context, state) {
                          return ListTile(
                            title: new Center(child: new Text(text[index])),
                            selected: index == _selectedIndex,
                            selectedColor: Colors.deepOrange,
                            onTap: () {
                              _selectedIndex = index;
                              String tappedValue = text[_selectedIndex];

                              tapped = true;

                              if (tappedValue.contains("тёмная сторона")) {
                                state.counterValue = int.parse(tappedValue
                                    .substring(0, tappedValue.length - 17));
                                if (themeData != ThemeData.dark()) {
                                  final cubit = context.read<ThemeCubit>();
                                  cubit.changeTheme(true);
                                } else if (themeData != ThemeData.light()) {
                                  final cubit = context.read<ThemeCubit>();
                                  cubit.changeTheme(false);
                                }
                              } else if (tappedValue
                                  .contains("светлая сторонка")) {
                                state.counterValue = int.parse(tappedValue
                                    .substring(0, tappedValue.length - 19));
                                if (themeData != ThemeData.light()) {
                                  final cubit = context.read<ThemeCubit>();
                                  cubit.changeTheme(true);
                                } else if (themeData != ThemeData.dark()) {
                                  final cubit = context.read<ThemeCubit>();
                                  cubit.changeTheme(false);
                                }
                              }

                              //BlocProvider.of<CounterCubit>(context).load();
                            },
                          );
                        });
                      }),
                ),
              ],
            )
          ],
        ),
        //кнопка смены темы
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            tapped = true;
            final cubit = context.read<ThemeCubit>();
            cubit.changeTheme(true);
          },
          label: const Text("смена темы"),
          icon: const Icon(Icons.switch_left_sharp),
        ));
  }
}
