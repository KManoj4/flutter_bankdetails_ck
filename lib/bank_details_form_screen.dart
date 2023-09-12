import 'package:flutter/material.dart';
import 'bank_details_list_screen.dart';
import 'database_helper.dart';
import 'main.dart';

class BankDetailsFormScreen extends StatefulWidget {
  const BankDetailsFormScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsFormScreen> createState() => _BankDetailsFormScreenState();
}

class _BankDetailsFormScreenState extends State<BankDetailsFormScreen> {
  var _bankNameController = TextEditingController(); //11
  var _branchController = TextEditingController(); //12
  var _accountTypeController = TextEditingController(); //13
  var _accountNoController = TextEditingController(); //14
  var _IFSCcodeController = TextEditingController(); //15

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Account Details Form'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 50,
                  width: 370,
                  child: TextFormField(
                    controller: _bankNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Bank Name'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 50,
                  width: 370,
                  child: TextFormField(
                    controller: _branchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Branch'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 50,
                  width: 370,
                  child: TextFormField(
                    controller: _accountTypeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Account Type'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 50,
                  width: 370,
                  child: TextFormField(
                    controller: _accountNoController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Account Number'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  height: 50,
                  width: 370,
                  child: TextFormField(
                    controller: _IFSCcodeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: 'IFSC code'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    _save();
                  },
                  child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('---------------> _save');
    print('---------------> BankName: ${_bankNameController.text}');
    print('---------------> Branch: ${_branchController.text}');
    print('---------------> AccountType: ${_accountTypeController.text}');
    print('---------------> AccountNo: ${_accountNoController.text}');
    print('---------------> IFSCcode: ${_IFSCcodeController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnBankName: _bankNameController.text,
      DatabaseHelper.columnBranch: _branchController.text,
      DatabaseHelper.columnAccountType: _accountTypeController.text,
      DatabaseHelper.columnAccountNo: _accountNoController.text,
      DatabaseHelper.columnIFSCcode: _IFSCcodeController.text,
    };

    final result = await dbHelper.insert(row, DatabaseHelper.bankDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSucessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankDetailsListScreen()));
    });
  }

  void _showSucessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
