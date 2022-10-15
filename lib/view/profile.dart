import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sample/controller/profile_controller.dart';
import 'package:flutter_sample/widget/progress_indicator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Utils/Utility.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> gender = [
      "select",
      AppLocalizations.of(context)!.label_male,
      AppLocalizations.of(context)!.label_female,
      AppLocalizations.of(context)!.label_other
    ];
    return ChangeNotifierProvider(
        create: (BuildContext context) => ProfileController(gender),
        lazy: false,
        builder: (context, child) {
          _nameController.text =
              Provider.of<ProfileController>(context).user.name;
          _emailController.text =
              Provider.of<ProfileController>(context).user.email;
          _dobController
              .text = Provider.of<ProfileController>(context, listen: false)
                  .user
                  .dob
                  .isNotEmpty
              ? Provider.of<ProfileController>(context, listen: false).user.dob
              : DateFormat("yyyy-MM-dd").format(DateTime.now());
          return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Container(
                color: Colors.white,
                child: SafeArea(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 140.0,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                width: 100.0,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: context
                                                            .watch<
                                                                ProfileController>()
                                                            .filePath
                                                            .startsWith('http')
                                                        ? NetworkImage(Provider
                                                                .of<ProfileController>(
                                                                    context)
                                                            .user
                                                            .profileImage)
                                                        : Image.file(File(
                                                                Provider.of<ProfileController>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .filePath))
                                                            .image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 65.0, right: 70.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () async {
                                                    await pickImage(context);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    radius: 15.0,
                                                    child: Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                              controller: _nameController,
                                              decoration: const InputDecoration(
                                                hintText: "Enter Your Name",
                                              ),
                                              enabled: true,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'password',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                              controller: _passwordController,
                                              decoration: const InputDecoration(
                                                hintText: "Enter new password",
                                              ),
                                              enabled: true,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Email ID',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextField(
                                              controller: _emailController,
                                              decoration: const InputDecoration(
                                                  hintText: "Enter Email ID"),
                                              enabled: true,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                'Birth date',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                'Gender',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () async {
                                                await _selectDate(context);
                                              },
                                              child: Container(
                                                height: 33,
                                                child: TextField(
                                                  controller: _dobController,
                                                  enabled: false,
                                                ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Container(
                                                height: 50,
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  value: Provider.of<
                                                              ProfileController>(
                                                          context,
                                                          listen: false)
                                                      .selectedGender,
                                                  icon: const Icon(
                                                      Icons.arrow_downward),
                                                  elevation: 16,
                                                  underline: Container(
                                                    height: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  onChanged: (String? value) {
                                                    if (value != null) {
                                                      Provider.of<ProfileController>(
                                                              context,
                                                              listen: false)
                                                          .changeGender(value);
                                                    }
                                                  },
                                                  items: gender.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                )),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  _getActionButtons(context),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _getActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Save"),
                onPressed: () async {
                  LoadingProgressDialog dialog =
                      Utility.showLoaderDialog(context);
                  String response = await Provider.of<ProfileController>(
                          context,
                          listen: false)
                      .changeProfile(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text);
                  dialog.hideDialog();
                  if (response.isNotEmpty) {
                    Utility.showSnackBar(
                        context, response.substring(response.indexOf('-') + 1),
                        isSuccess: response.startsWith('0'));
                  }
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    await FilePicker.platform
        .pickFiles(dialogTitle: "Select profile image", type: FileType.image)
        .then((result) async {
      if (result != null) {
        String path = result.files.first.path!;
        Provider.of<ProfileController>(context, listen: false)
            .changeFilePath(path);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        locale: Locale(AppLocalizations.of(context)!.localeName),
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());
    if (picked != null) {
      _dobController.text = DateFormat("yyyy-MM-dd").format(picked);
      Provider.of<ProfileController>(context, listen: false)
          .changeDob(_dobController.text);
    }
  }
}
