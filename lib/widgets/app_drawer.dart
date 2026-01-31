import 'package:flutter/material.dart';
import 'package:wisata_kuliner/screens/login_screen.dart';
import 'package:wisata_kuliner/services/auth_service.dart';
import 'package:wisata_kuliner/services/user_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: FutureBuilder(
                future: UserService().getCurrentUser(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  if (user != null) {
                    return Row(
                      children: [
                        CircleAvatar(child: Text(user.name[0])),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(user.email, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    );
                  }
                  ;
                  return SizedBox();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Keluar'),
              onTap: () async {
                await AuthService().logoutUser();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
