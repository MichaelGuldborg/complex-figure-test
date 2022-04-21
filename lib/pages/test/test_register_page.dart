import 'package:flutter/material.dart';
import 'package:reyo/components/bottom_sheet/bottom_sheet_select.dart';
import 'package:reyo/constants/theme_colors.dart';

class TestRegisterRequest {
  final String? name;
  final int? age;
  final String? sex;
  final String? education;

  TestRegisterRequest({
    this.name,
    this.age,
    this.sex,
    this.education,
  });
}

class TestRegisterPage extends StatelessWidget {
  final void Function(TestRegisterRequest request) onNextPress;

  TestRegisterPage({
    Key? key,
    required this.onNextPress,
  }) : super(key: key);

  final _name = TextEditingController();
  final _age = TextEditingController();
  final _sex = TextEditingController();
  final _education = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 320,
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
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Age',
                  ),
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
              MaterialButton(
                color: ThemeColors.primary,
                child: Text(
                  'START TEST',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  onNextPress(TestRegisterRequest(
                    name: _name.text.trim(),
                    age: int.tryParse(_age.text.trim()),
                    sex: _sex.text.trim(),
                    education: _education.text.trim(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
