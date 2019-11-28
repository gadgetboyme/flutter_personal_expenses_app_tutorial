import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  // const NewTransaction({Key key}) : super(key: key);

  final Function addTx;

  NewTransaction(this.addTx) {
    print('Constructor NewTransaction Widget');
  }

  @override
  _NewTransactionState createState() {
    print('createState NewTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState(){
    print('Constructor NewTransaction State');
  }

  @override
  void initState() {
    super.initState();
    print('initState NewTransaction Widget');
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget()');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose() NewTransaction');
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    //Used to close the modal
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    //Show date picker returns a "future". The future will be an anonymous function to be executed after the date picker returns a value
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019, 01, 01),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return; //The user pressed cancel
      }

      //wrapping the setting of the date should fire setState, to update the date
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  //on Submitted passes a value, however it is not needed. In this case, the "_" means the value can be ignored, as there is no plan to use it.
                  //Must use submitData() instead of submitData, as an anonymous function is being used.
                  onSubmitted: (_) => _submitData()
                  // onChanged: (value) {
                  //   titleInput = value;
                  // },
                  ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //on Submitted passes a value, however it is not needed. In this case, the "_" means the value can be ignored, as there is no plan to use it.
                //Must use submitData() instead of submitData, as an anonymous function is being used.
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Chosen Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: () => _submitData(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
