import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constant/constants.dart';
import '../../controller/extra_functionality/firebase_storage_controller.dart';
import '../../utils/styles.dart';

class FirebaseDatabaseOperation extends StatelessWidget {
  FirebaseDatabaseOperation({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return ChangeNotifierProvider(
        create: (context) => FirebaseStorageController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(arguments['title']),
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter user id',
                      label: Text('User id'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Enter User name',
                      label: Text(AppLocalizations.of(context)!.label_name),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Enter user email',
                      label: Text(AppLocalizations.of(context)!.label_email),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: CustomStyles.filledRoundedCornerButton(
                              fullWidth: false, minWidth: 100),
                          onPressed: () async {
                            await Provider.of<FirebaseStorageController>(
                                    context,
                                    listen: false)
                                .addData(
                              id: _idController.text,
                              name: _nameController.text,
                              email: _emailController.text,
                            );
                          },
                          child: Text(
                            'Add',
                            style: CustomStyles.customTextStyle(
                                isLargeFont: true,
                                defaultColor: AppConstants.whiteColor,
                                isBold: true),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          style: CustomStyles.filledRoundedCornerButton(
                              fullWidth: false, minWidth: 100),
                          onPressed: () async {
                            await Provider.of<FirebaseStorageController>(
                                    context,
                                    listen: false)
                                .updateData(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    id: _idController.text);
                          },
                          child: Text(
                            'Update',
                            style: CustomStyles.customTextStyle(
                                isLargeFont: true,
                                defaultColor: AppConstants.whiteColor,
                                isBold: true),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.separated(
                          itemCount: context
                              .watch<FirebaseStorageController>()
                              .users
                              .length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 5,
                            );
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _idController.text =
                                    Provider.of<FirebaseStorageController>(
                                            context,
                                            listen: false)
                                        .users[index]
                                        .id;
                                _nameController.text =
                                    Provider.of<FirebaseStorageController>(
                                            context,
                                            listen: false)
                                        .users[index]
                                        .name;
                                _emailController.text =
                                    Provider.of<FirebaseStorageController>(
                                            context,
                                            listen: false)
                                        .users[index]
                                        .email;
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppConstants.themeColor)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(context
                                              .watch<
                                                  FirebaseStorageController>()
                                              .users[index]
                                              .name),
                                          Text(context
                                              .watch<
                                                  FirebaseStorageController>()
                                              .users[index]
                                              .email),
                                          Text(context
                                              .watch<
                                                  FirebaseStorageController>()
                                              .users[index]
                                              .id)
                                        ],
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            await Provider.of<
                                                        FirebaseStorageController>(
                                                    context,
                                                    listen: false)
                                                .deleteData(
                                                    'users',
                                                    Provider.of<FirebaseStorageController>(
                                                            context,
                                                            listen: false)
                                                        .users[index]
                                                        .id);
                                          },
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            ),
          );
        });
  }
}
