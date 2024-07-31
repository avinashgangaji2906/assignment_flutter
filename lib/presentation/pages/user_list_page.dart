import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:assignment_flutter/core/utils/show_snackbar.dart';
import 'package:assignment_flutter/models/user_data_model.dart';
import 'package:assignment_flutter/presentation/pages/user_details_page.dart';
import 'package:assignment_flutter/presentation/pages/user_form_page.dart';
import 'package:assignment_flutter/presentation/widgets/loader.dart';
import 'package:assignment_flutter/provider/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const UserListPage());
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDataProvider>(context, listen: false).getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Users",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.push(context, UserFormScreen.route(userData: null)),
              icon: const Icon(Icons.person_add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<UserDataProvider>(
          builder: (context, provider, child) {
            if (provider.isAllUsersLoading) {
              return const Center(
                child: Loader(),
              );
            }
            if (provider.allUsers.isEmpty) {
              return const Center(
                child: Text("No users added yet!"),
              );
            }
            return ListView.builder(
              itemCount: provider.allUsers.length,
              itemBuilder: (context, index) {
                UserDataModel data = provider.allUsers[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  shape: const Border.symmetric(
                    horizontal:
                        BorderSide(color: AppPallete.greyColor, width: 0.1),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    UserDetailsPage.route(data),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: AppPallete.greyColor,
                    child: Icon(
                      Icons.person_2_rounded,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    data.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                UserFormScreen.route(
                                  userData: data,
                                ));
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () async {
                            bool deleted = await Provider.of<UserDataProvider>(
                                    context,
                                    listen: false)
                                .deleteUser(userId: data.userId);
                            if (deleted) {
                              if (!mounted) return;
                              showSnackbar(
                                  context, 'User deleted successfully');
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppPallete.errorColor,
                          ))
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
