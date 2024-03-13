import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';

class Keeper {
  List<users> users_list = [];
  List<location> location_List = [];
  List<events> events_list = [];
  users user = users.empty();
}

class DataCubit extends Cubit<Keeper> {
  List<events> get getEvents => state.events_list;

  delEvents(events model) {
    state.events_list.remove(model);
  }

  updEvent(events model) {
    for (int i = 0; i < state.events_list.length; i++) {
      if (state.events_list[i].id == model.id) {
        state.events_list[i] = model;
      }
    }
  }

  addEvents(events model) {
    state.events_list.add(model);
  }

  setEventsList(List<events> newList) {
    state.events_list = newList;
  }

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

  addLocation(location model) {
    state.location_List.add(model);
  }

  updLocation(location model) {
    int y = 0;
    for (int i = 0; i < state.location_List.length; i++) {
      if (state.location_List[i].id == model.id) {
        state.location_List[i] = model;

        for (int j = 0; j < state.events_list.length; j++) {
          if (state.events_list[j].locations.id == model.id) {
            state.events_list[j].locations = model;
          }
        }
      }
    }
  }

  DataCubit(super.initState);
}
