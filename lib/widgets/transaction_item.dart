import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';

import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  Color _bgColor;

  @override
  void initState() { 
    super.initState();
    const availableColors = [Colors.red, Colors.black, Colors.blue, Colors.purple,];
    _bgColor = availableColors[Random().nextInt(4)];
;  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
              padding: EdgeInsets.all(6),
              child: FittedBox(
                  child: Text('\$${widget.transaction.amount}'))),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: TextStyle(color: Colors.grey),
        ),
        trailing: MediaQuery.of(context).size.width > 560 ? FlatButton.icon(icon: Icon(Icons.delete),
          textColor: Theme.of(context).errorColor, label: Text('Delete'), onPressed: () => widget.deleteTransaction(widget.transaction.id),) : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.deleteTransaction(widget.transaction.id),
        ),
      ),
    );
  }
}