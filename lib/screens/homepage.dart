import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _Debitmessages = [];
  List<SmsMessage> _Creditmessages = [];
  DateTime? _startDate;
  DateTime? _endDate;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getSmsMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getSmsMessages() async {
    // Check and request permission if needed
    var permission = await Permission.sms.status;
    print("permission : $permission");
    if (!permission.isGranted) {
      permission = await Permission.sms.request();
      if (!permission.isGranted) {
        return;
      }
    }

    // Fetch SMS messages
    List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
    );

    // Use the selected start and end dates for filtering
    DateTime now = DateTime.now();
    DateTime startDate = _startDate ?? DateTime(now.year, now.month, 1);
    DateTime endDate = _endDate ?? DateTime(startDate.year, startDate.month + 1, 0);

    // Filter messages
    List<SmsMessage> debitmessages = messages.where((message) {
      DateTime? messageDate = message.date;
      return message.body != null &&
          message.sender != null &&
          message.sender!.contains("-BOBSMS") &&
          message.body!.toLowerCase().contains(".00 debited from a/c") &&
          messageDate != null &&
          messageDate.isAfter(startDate) &&
          messageDate.isBefore(endDate);
    }).toList();

    List<SmsMessage> creditmessages = messages.where((message) {
      DateTime? messageDate = message.date;
      return message.body != null &&
          message.sender != null &&
          message.sender!.contains("-BOBTXN") &&
          message.body!.toLowerCase().contains("credited to a/c") &&
          messageDate != null &&
          messageDate.isAfter(startDate) &&
          messageDate.isBefore(endDate);
    }).toList();

    // Update the state with fetched messages
    setState(() {
      _Debitmessages = debitmessages;
      _Creditmessages = creditmessages;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      _getSmsMessages(); // Refresh messages with the new selected date
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      _getSmsMessages(); // Refresh messages with the new selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectStartDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectEndDate(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Debit'),
            Tab(text: 'Credit'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.filter_alt),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesListView(_Debitmessages),
          _buildMessagesListView(_Creditmessages),
        ],
      ),
    );
  }

  Widget _buildMessagesListView(List<SmsMessage> messages) {
    return messages.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              SmsMessage message = messages[index];
              return Card(
                child: ListTile(
                  tileColor: Colors.grey.shade100,
                  title: Text(message.sender ?? 'Unknown'),
                  subtitle: Text(message.body ?? ''),
                ),
              );
            },
          );
  }
}
