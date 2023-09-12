import 'package:flutter/material.dart';
import 'bank_details_model.dart';
import 'bank_details_list_screen.dart';
import 'database_helper.dart';
import 'main.dart';

class OptimizedBankDetailsFormScreen extends StatefulWidget {
  const OptimizedBankDetailsFormScreen({Key? key}) : super(key: key);

  @override
  State<OptimizedBankDetailsFormScreen> createState() =>
      _OptimizedBankDetailsFormScreenState();
}

class _OptimizedBankDetailsFormScreenState
    extends State<OptimizedBankDetailsFormScreen> {
  var _bankNameController = TextEditingController(); //11
  var _branchController = TextEditingController(); //12
  var _accountTypeController = TextEditingController(); //13
  var _accountNoController = TextEditingController(); //14
  var _IFSCcodeController = TextEditingController(); //15

  // Edit
  bool firstTimeFlag = false;
  int _selectedId = 0;
  String buttonText = 'Save';

  @override
  void initState() {
    super.initState();
  }

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await dbHelper.delete(
                      _selectedId, DatabaseHelper.bankDetailsTable);

                  debugPrint('-----------------> Deleted Row Id: $result');

                  if (result > 0) {
                    _showSuccessSnackBar(context, 'Deleted.');
                    Navigator.pop(context);

                    setState(() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => BankDetailsListScreen()));
                    });
                  }
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Edit/Delete - Received Data - Optimized
    if (firstTimeFlag == false) {
      print('---------->once execute');

      firstTimeFlag = true;

      final bankDetails = ModalRoute.of(context)!.settings.arguments;

      if (bankDetails == null) {
        print('----------->FAB: Insert:'); // save
      } else {
        print('----------->ListView: Received Data: Edit/Delete');

        bankDetails as BankDetails;

        print(bankDetails.id);
        print(bankDetails.bankName);
        print(bankDetails.branch);
        print(bankDetails.accountType);
        print(bankDetails.accountNo);
        print(bankDetails.IFSCcode);

        _selectedId = bankDetails.id!;
        buttonText = 'Update';

        _bankNameController.text = bankDetails.bankName;
        _branchController.text = bankDetails.branch;
        _accountTypeController.text = bankDetails.accountType;
        _accountNoController.text = bankDetails.accountNo;
        _IFSCcodeController.text = bankDetails.IFSCcode;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Details Form'),
        actions: _selectedId != 0
            ? [
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 1, child: Text("Delete")),
                  ],
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      _deleteFormDialog(context);
                    }
                  },
                ),
              ]
            : null,
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
              ), //11
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
              ), //12
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
              ), //13
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
              ), //14
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
                        labelText: 'IFSC Code'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ), //15
              ElevatedButton(
                onPressed: () {
                  if (_selectedId == 0) {
                    print('---------------> Save');
                    _save();
                  } else {
                    print('---------------> Update');
                    _update();
                  }
                },
                child: Text(buttonText),
              ),
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
      _showSuccessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankDetailsListScreen()));
    });
  }

  void _update() async {
    print('---------------> _update');
    print('---------------> Selected ID: $_selectedId');
    print('---------------> BankName: ${_bankNameController.text}');
    print('---------------> Branch: ${_branchController.text}');
    print('---------------> AccountType: ${_accountTypeController.text}');
    print('---------------> AccountNo: ${_accountNoController.text}');
    print('---------------> IFSCcode: ${_IFSCcodeController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.columnId: _selectedId,
      DatabaseHelper.columnBankName: _bankNameController.text,
      DatabaseHelper.columnBranch: _branchController.text,
      DatabaseHelper.columnAccountType: _accountTypeController.text,
      DatabaseHelper.columnAccountNo: _accountNoController.text,
      DatabaseHelper.columnIFSCcode: _IFSCcodeController.text,
    };

    final result = await dbHelper.update(row, DatabaseHelper.bankDetailsTable);

    debugPrint('--------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankDetailsListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
