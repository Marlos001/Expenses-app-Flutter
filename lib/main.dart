import './components/chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import './components/transaction_form.dart';
import './components/transaction_list.dart';
import '../models/transaction.dart';
import 'package:flutter/cupertino.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Quicksand',
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber[800],
        ),
        textTheme: tema.textTheme.copyWith(
          bodyLarge: TextStyle(fontFamily: 'Quicksand'),
          bodyMedium: TextStyle(fontFamily: 'Quicksand'),
          bodySmall: TextStyle(fontFamily: 'Quicksand'),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber[800],
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColorDark: Colors.purple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber[800],
          foregroundColor: Colors.black,
          iconSize: 40,
          elevation: 5,
        ),
        appBarTheme: AppBarTheme(
          elevation: 5,
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyPage = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.6 : 0.2),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.8),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      );

    final MediaQuery = MediaQuery.of(context)
    bool isLandscape =
        MediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Expenses App',
        style: TextStyle(
          fontSize: MediaQuery.textScalerOf(context).scale(14),
        ),
      ),
      actions: [
        if (isLandscape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.bar_chart),
            onPressed: () => {
              setState(() {
                _showChart = !_showChart;
              }),
            },
          ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
    );

    final availableHeight = MediaQuery.size.height -
        appBar.preferredSize.height -
        MediaQuery.padding.top;

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLandscape)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showChart = !_showChart;
                        });
                      },
                      child: Icon(_showChart ? CupertinoIcons.list_bullet : CupertinoIcons.chart_bar),
                    ),
                  GestureDetector(
                    onTap: () => _openTransactionFormModal(context),
                    child: Icon(CupertinoIcons.add),
                  ),
                ],
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
  }
}
