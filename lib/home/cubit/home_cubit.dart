import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

///The home feature is responsible for managing the state of the currently-selected TAB and displays the correct SUBTREE.
///A cubit is APPROPRIATE in this case due to the SIMPLICITY of the business logic. We have one method setTab to change the tab.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
