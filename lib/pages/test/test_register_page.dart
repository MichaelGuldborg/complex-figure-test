import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_select.dart';
import 'package:reyo/constants/theme_colors.dart';
import 'package:reyo/pages/home/playback_page.dart';

class TestSessionForm {
  final String? name;
  final DateTime? birthDate;
  final String? sex;
  final String? education;

  TestSessionForm({
    this.name,
    this.birthDate,
    this.sex,
    this.education,
  });
}

class TestRegisterPage extends StatefulWidget {
  final void Function(TestSessionForm request) onNextPress;

  TestRegisterPage({
    Key? key,
    required this.onNextPress,
  }) : super(key: key);

  @override
  State<TestRegisterPage> createState() => _TestRegisterPageState();
}

class _TestRegisterPageState extends State<TestRegisterPage> {
  final now = DateTime.now();
  final _name = TextEditingController();
  final _birthDate = TextEditingController();
  final _sex = TextEditingController();
  final _education = TextEditingController();
  DateTime _birthDateValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 460,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _birthDate,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(hintText: 'Birthdate'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: CalendarDatePicker(
                            initialDate: DateTime(now.year - 18),
                            firstDate: DateTime(now.year - 100),
                            lastDate: DateTime(now.year),
                            onDateChanged: (date) {
                              _birthDateValue = date;
                              _birthDate.text = formatDate(date);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  onTap: () async {
                    final options = ['Male', 'Female', 'Other'];
                    final index = await showSelectBottomSheet(
                      context,
                      title: 'Select sex',
                      options: options,
                    );
                    if (index != null) {
                      _sex.text = options[index];
                    }
                  },
                  controller: _sex,
                  decoration: InputDecoration(
                    hintText: 'Sex',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  onTap: () async {
                    final options = [
                      'None',
                      'Elementary',
                      'High-school',
                      'Bachelors degree',
                      'Masters degree',
                      'PHD'
                    ];
                    final index = await showSelectBottomSheet(
                      context,
                      title: 'Select education',
                      subtitle: 'Highest level of education completed',
                      options: options,
                    );
                    if (index != null) {
                      _education.text = options[index];
                    }
                  },
                  controller: _education,
                  decoration: InputDecoration(
                    hintText: 'Education',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32),
                child: MaterialButton(
                  color: ThemeColors.primary,
                  child: Text(
                    'START TEST',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    widget.onNextPress(TestSessionForm(
                      name: _name.text.trim(),
                      birthDate: _birthDateValue,
                      sex: _sex.text.trim(),
                      education: _education.text.trim(),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
