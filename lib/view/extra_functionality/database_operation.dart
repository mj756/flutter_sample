import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../controller/extra_functionality/database_operation_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/styles.dart';

class DatabaseOperation extends StatelessWidget {
  DatabaseOperation({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return ChangeNotifierProvider(
        create: (context) => DatabaseOperationController(),
        lazy: false,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(arguments['title']),
            ),
            body: Column(
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
                  children: [
                    ElevatedButton(
                        style:
                            CustomStyles.themeBigFilledRoundedCornerButtonStyle(
                                fullWidth: false),
                        onPressed: () async {
                          await Provider.of<DatabaseOperationController>(
                                  context,
                                  listen: false)
                              .addData(
                                  _nameController.text,
                                  _emailController.text,
                                  int.parse(_idController.text));
                        },
                        child: Text(
                          'Add data',
                          style: CustomStyles.customTextStyle(
                              isLargeFont: true,
                              defaultColor: CustomColors.whiteColor,
                              isBold: true),
                        )),
                    ElevatedButton(
                        style:
                            CustomStyles.themeBigFilledRoundedCornerButtonStyle(
                                fullWidth: false),
                        onPressed: () async {
                          await Provider.of<DatabaseOperationController>(
                                  context,
                                  listen: false)
                              .updateData(
                                  _nameController.text,
                                  _emailController.text,
                                  int.parse(_idController.text));
                        },
                        child: Text(
                          'Update data',
                          style: CustomStyles.customTextStyle(
                              isLargeFont: true,
                              defaultColor: CustomColors.whiteColor,
                              isBold: true),
                        )),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: context
                            .watch<DatabaseOperationController>()
                            .user
                            .length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(context
                                .watch<DatabaseOperationController>()
                                .user[index]
                                .name),
                            subtitle: Text(context
                                .watch<DatabaseOperationController>()
                                .user[index]
                                .email),
                            leading: Text(context
                                .watch<DatabaseOperationController>()
                                .user[index]
                                .id),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await Provider.of<DatabaseOperationController>(
                                        context,
                                        listen: false)
                                    .deleteData(int.parse(Provider.of<
                                                DatabaseOperationController>(
                                            context,
                                            listen: false)
                                        .user[index]
                                        .id));
                              },
                            ),
                          );
                        }))
              ],
            ),
          );
        });
  }
}
