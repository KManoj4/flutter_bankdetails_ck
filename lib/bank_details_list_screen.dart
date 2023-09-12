import 'package:flutter/material.dart';
import 'optimized_bank_details_form_screen.dart';
import 'bank_details_model.dart';
import 'bank_details_form_screen.dart';
import 'database_helper.dart';
import 'edit_bank_details_form_screen.dart';
import 'main.dart';

class BankDetailsListScreen extends StatefulWidget {
  const BankDetailsListScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsListScreen> createState() => _BankDetailsListScreenState();
}

class _BankDetailsListScreenState extends State<BankDetailsListScreen> {
  late List<BankDetails> _bankDetailsList;

  @override
  void initState() {
    super.initState();
    getAllBankDetails();
  }

  getAllBankDetails() async {
    _bankDetailsList = <BankDetails>[];
    var bankDetails =
        await dbHelper.queryAllRows(DatabaseHelper.bankDetailsTable);
    bankDetails.forEach((bankDetail) {
      setState(() {
        print(bankDetail['_id']);
        print(bankDetail['_bankName']);
        print(bankDetail['_branch']);
        print(bankDetail['_accountType']);
        print(bankDetail['_accountNo']);
        print(bankDetail['_IFSCcode']);
        var bankDetailsModel = BankDetails(
          bankDetail['_id'],
          bankDetail['_bankName'],
          bankDetail['_branch'],
          bankDetail['_accountType'],
          bankDetail['_accountNo'],
          bankDetail['_IFSCcode'],
        );
        _bankDetailsList.add(bankDetailsModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(15, 53, 73, 1),
        title: Text('Bank Details'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            new Expanded(
                child: new ListView.builder(
              itemCount: _bankDetailsList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new InkWell(
                  onTap: () {
                    print('---------->Edit or Delete invoked: Send Data');
                    print(_bankDetailsList[index].id);
                    print(_bankDetailsList[index].bankName);
                    print(_bankDetailsList[index].branch);
                    print(_bankDetailsList[index].accountType);
                    print(_bankDetailsList[index].accountNo);
                    print(_bankDetailsList[index].IFSCcode);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditBankDetailsFormScreen(),
                      settings: RouteSettings(
                        arguments: _bankDetailsList[index],
                      ),
                    ));

                    /*
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OptimizedBankDetailsFormScreen(),
                        settings: RouteSettings(
                          arguments: _bankDetailsList[index],
                        ),
                      ));
                     */
                  },
                  child: ListTile(
                    title: Text(_bankDetailsList[index].bankName +
                        '\n' +
                        _bankDetailsList[index].branch +
                        '\n' +
                        _bankDetailsList[index].accountType +
                        '\n' +
                        _bankDetailsList[index].accountNo +
                        '\n' +
                        _bankDetailsList[index].IFSCcode),
                  ),
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BankDetailsFormScreen()));

          /*
           Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OptimizedBankDetailsFormScreen(),
                        settings: RouteSettings(
                          arguments: _bankDetailsList[index],
                        ),
                      ));
           */
        },
        child: Icon(Icons.add),
      ),
    );
  }
}