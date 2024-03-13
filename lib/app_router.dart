import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/auth.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/forms/location_add_form.dart';
import 'package:scheduler_app/forms/location_view.dart';
import 'package:scheduler_app/forms/login_form.dart';
import 'package:scheduler_app/forms/register_form.dart';
import 'package:scheduler_app/forms/event_add.dart';
import 'package:scheduler_app/forms/events_view.dart';
import 'package:scheduler_app/forms/user_profile.dart';
import 'package:scheduler_app/forms/users_add_form.dart';
import 'package:scheduler_app/forms/users_view.dart';
import 'package:scheduler_app/model/events.dart';
import 'package:scheduler_app/model/location.dart';
import 'package:scheduler_app/model/users.dart';

class AppRouter {
  final DataCubit cubit = DataCubit(Keeper());

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: LoginForm(),
          ),
        );

      case '/RegisterForm':
        return MaterialPageRoute(
          builder: (context) => RegisterForm(),
        );

      case '/ShedulerViewFuture':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: EventsView(
              selectedIndex: 0,
            ),
          ),
        );

      // case '/SchedulerView':
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider.value(
      //       value: cubit,
      //       child: SchedulerView(
      //         selectedIndex: 0,
      //       ),
      //     ),
      //   );

      case '/UserProfile':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: UserProfile(
              selectedIndex: 1,
            ),
          ),
        );

      case '/LocationView':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: LocationView(
              selectedIndex: 2,
            ),
          ),
        );

      case '/UsersView':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: UsersView(
              selectedIndex: 3,
            ),
          ),
        );

      case '/LocationAddForm':
        final location model = routeSettings.arguments as location;
        return MaterialPageRoute(
          builder: (context) => LocationAddForm(
            model: model,
          ),
        );

      case '/UsersAddForm':
        final users model = routeSettings.arguments as users;
        return MaterialPageRoute(
          builder: (context) => UsersAddForm(
            model: model,
          ),
        );

      case '/ShedulerAdd':
        final events model = routeSettings.arguments as events;
        return MaterialPageRoute(
          builder: (context) => EventAdd(
            model: model,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => LoginForm(),
        );
    }
  }
}
