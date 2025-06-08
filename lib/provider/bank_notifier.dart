import 'package:expense_tracker/models/bank_model.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class BankNotifier extends ChangeNotifier {
  BankModel? _selectedBank;

  BankModel? get selectedBank => _selectedBank;
  set selectedBank(BankModel? bank) {
    var settingsBox = Hive.box('settings');
    _selectedBank = bank;
    settingsBox.put('BankName', bank?.bankName ?? '');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void getBank() {
    var settingsBox = Hive.box('settings');
    String bankName = settingsBox.get('BankName', defaultValue: '');
    if (bankName == '') {
      _selectedBank = null;
    } else {
      selectedBank = bankNames.firstWhere((bank) => bank.bankName == bankName);
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> showBankSelectionDialog(BuildContext context) async {
    final moneyNotifier = Provider.of<MoneyNotifier>(context, listen: false);
    final bankNotifier = Provider.of<BankNotifier>(context, listen: false);
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Bank"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bankNames.length,
              itemBuilder: (context, index) {
                final bank = bankNames[index];
                return ListTile(
                  leading: SizedBox(width: 40, height: 40, child: bank.image),
                  title: Text(bank.bankName),
                  onTap: () {
                    selectedBank = bank;
                    moneyNotifier.hasFetchedOnce = false;
                    moneyNotifier.getSmsMessages(bankNotifier);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<BankModel> bankNames = [
    BankModel(
        bankName: "Bank of Baroda",
        creditRegex: RegExp(r"\b(credited)\s*\w+\s*a\/c\b"),
        debitRegex:
            RegExp(r"\b(debited | transferred | withdrawn)\s*\w+\s*a\/c\b"),
        moneyRegex: RegExp(r"rs\s*\.?\s*(\d+)(?:\.00|\s|\w+)"),
        image: Image.asset('assets/images/bob.png'),
        debitSenders: ["-BOBSMS", "-BOBTXN"], 
        creditSenders: ["-BOBTXN"]),
    BankModel(
        bankName: "State Bank of India",
        creditRegex: RegExp(r"\b(credit(ed)?)\s*"),
        debitRegex: RegExp(r"\b(debit(ed)? | transferred | withdrawn)\s*"),
        moneyRegex: RegExp(r"(?:rs\.?|inr|debited by)\s*([0-9]+)"),
        image: Image.asset('assets/images/sbi.png'),
        debitSenders: ["SBI"], 
        creditSenders: ["SBI"]),
    BankModel(
        bankName: "UCO Bank",
        creditRegex: RegExp(r'credited'),
        debitRegex: RegExp(r'debited'),
        moneyRegex: RegExp(r''),
        image: Image.asset('assets/images/uco.png'),
        debitSenders: ["-BOBSMS", "-BOBTXN"], 
        creditSenders: ["-BOBTXN"]),
  ];
}
