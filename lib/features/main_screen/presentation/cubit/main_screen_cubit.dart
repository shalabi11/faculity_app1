import 'package:bloc/bloc.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(const MainScreenState());

  void changeTab(int index) {
    emit(MainScreenState(selectedIndex: index));
  }
}
