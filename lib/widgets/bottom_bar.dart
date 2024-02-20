import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/model/users.dart';

class BottomBarGeneral extends StatelessWidget {
  BottomBarGeneral(
      {Key? key, required this.selectedIndex, required this.IsAdmin});

  int selectedIndex;
  final IsAdmin;
  @override
  Widget build(BuildContext context) {
    if (IsAdmin) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: Colors.blue, // <-- This works for fixed
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: 'SchedulerView',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'UserProfile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'LocationView',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_back_door),
            label: 'Exit',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: selectedIndex,

        onTap: (value) {
          if (value == 0) {
            Navigator.pushNamed(context, '/SchedulerView', arguments: value);
          } else if (value == 1) {
            Navigator.pushNamed(context, '/UserProfile', arguments: value);
          } else if (value == 2) {
            Navigator.pushNamed(context, '/LocationView', arguments: value);
          } else if (value == 3) {
            Navigator.pushNamed(context, '/UsersView', arguments: value);
          } else if (value == 4) {
            context.read<DataCubit>().setCurrentUser(users.empty());

            Navigator.pushNamed(context, '/');
          }
        },
      );
    } else {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: Colors.blue, // <-- This works for fixed
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.watch),
            label: 'SchedulerView',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'UserProfile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_back_door),
            label: 'Exit',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: selectedIndex,
        //  selectedItemColor: Colors.black,
        onTap: (value) {
          if (value == 0) {
            Navigator.pushNamed(context, '/SchedulerView', arguments: value);
          } else if (value == 1) {
            Navigator.pushNamed(context, '/UserProfile', arguments: value);
          } else if (value == 2) {
            context.read<DataCubit>().setCurrentUser(users.empty());
            Navigator.pushNamed(context, '/');
          }
        },
      );
    }
  }
}
