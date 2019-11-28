import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

//To lock app into landscape mode:
// SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
//This is put into the void main() function, instead of using the fat arrow.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
            //Text theme of the app bar
            textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    print('initState()');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose()');
    WidgetsBinding.instance.removeObserver(this);
  }

  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    //As we're deleting the transaction, the state will change.
    setState(() {
      //The .removeWhere accepts a function, which returns true whenever the conditions inside the
      //anonymous function are met (i.e. when the userTransaction.id == id)
      // _userTransactions.removeWhere((tx) {
      //   return tx.id == id;
      // });

      //As there is only one line here, the above can be converted to use the "fat arrow" method instead
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          :
          //Need to pass the userTransactions and the deleteTransaction function, to enable the TransactionList class to use
          //the list and the deleteTransaction function.
          txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  //Build the app bar, based on if it's iOS or Android
  Widget _buildAppBar(){
    return Platform.isIOS
        ? _buildCupertinoNavBar()
        : _buildMaterialAppBar();
  }

  //Build the iOS app Bar
  PreferredSizeWidget _buildCupertinoNavBar(){
    return CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // CupertinoButton(child: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),)
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          );
  }

  //Build the Android app bar
  PreferredSizeWidget _buildMaterialAppBar() {
    return AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    //The app bar can be stored as a widget, to get it's height
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;
    //Get the app bar for each OS through the builder
    final PreferredSizeWidget appBar = _buildAppBar();

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //spaceAround will evenly space the children around the screen
          mainAxisAlignment: MainAxisAlignment.start,
          // CrossAxisAlignment.stretch will use max width in the column
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_isLandscape)
            //The _buildLandscapeContent function returns a list of widgets
            //Using "..." will allow the list to be flattened into the widget array being used by the children:
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!_isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            //To hide the FAB for iOS, use the line below
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
