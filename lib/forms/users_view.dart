import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler_app/block/block.dart';
import 'package:scheduler_app/constants.dart';
import 'package:scheduler_app/model/users.dart';
import 'package:scheduler_app/widgets/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_admin/firebase_admin.dart';
// import 'package:firebase_admin/src/auth/user.dart';

class UsersView extends StatefulWidget {
  UsersView({Key? key, required this.selectedIndex}) : super(key: key);
  int selectedIndex;
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('UsersView'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              users model = users.empty();
              Navigator.pushNamed(context, '/UsersAddForm', arguments: model);
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add new Location',
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Dismissible(
                  key: Key(ds.id),
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    //   setState(() {
                    final collection =
                        FirebaseFirestore.instance.collection('users');
                    collection
                        .doc(ds.id) // <-- Doc ID to be deleted.
                        .delete() // <-- Delete
                        .then((_) => print('Deleted'))
                        .catchError((error) => print('Delete failed: $error'));
                    //    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${ds['userName']} удалён!')));
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      print('long press   ${ds['userName']} ');
                      users model = users(ds.id, ds['email'], ds['password'],
                          ds['userName'], ds['role'], ds['IsApproved']);

                      Navigator.pushNamed(context, '/UsersAddForm',
                          arguments: model);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          ds['userName'],
                          style: txt20,
                        ),
                        subtitle: Text(
                          ds['role'],
                          style: txt20,
                        ),
                        trailing: Icon(
                          bool.parse(ds['IsApproved'].toString())
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_rounded,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomBarGeneral(
        selectedIndex: widget.selectedIndex,
        IsAdmin: context.read<DataCubit>().getUser.IsAdmin(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
