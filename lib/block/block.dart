import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';

class Keeper {
  List<users> users_list = [];
  List<location> location_List = [];
  users user = users.empty();
}

class DataCubit extends Cubit<Keeper> {
  List<users> get getAllUsers => state.users_list;

  setUsersList(List<users> new_list) {
    state.users_list = new_list;
  }

  users get getUser => state.user;

  setCurrentUser(users NewUser) {
    state.user = NewUser;
  }

  List<location> get getLocations => state.location_List;

  setLocations(List<location> new_locations_List) {
    state.location_List = new_locations_List;
  }

  DataCubit(super.initState);
}
