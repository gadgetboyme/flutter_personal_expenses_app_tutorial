import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    //If there are no transactions, show this, and the image. Else, show the transactions
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No Transactions added yet',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ))
                ],
              );
            },
          )
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTransaction: deleteTransaction,
                    ))
                .toList(),
          );

    // ListView.builder(
    //     itemBuilder: (ctx, index) {
    //       return TransactionItem(transaction: transactions[index], deleteTransaction: deleteTransaction);

    //  // return Card(
    //  //   //The card will be made up or a row
    //  //   child: Row(
    //  //     children: <Widget>[
    //  //       //The container will create the style and contain the text for the price
    //  //       Container(
    //  //         margin:
    //  //             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //  //         decoration: BoxDecoration(
    //  //           border: Border.all(
    //  //               color: Theme.of(context).primaryColor, width: 2),
    //  //         ),
    //  //         padding: EdgeInsets.all(10),
    //  //         child: Text(
    //  //           '\$${transactions[index].amount.toStringAsFixed(2)}',
    //  //           style: TextStyle(
    //  //               fontWeight: FontWeight.bold,
    //  //               fontSize: 20,
    //  //               color: Theme.of(context).primaryColor),
    //  //         ),
    //  //       ),
    //  //       //The column will contain the title and date, stacked vertically.
    //  //       Column(
    //  //         //Left align the values
    //  //         crossAxisAlignment: CrossAxisAlignment.start,
    //  //         children: <Widget>[
    //  //           Text(
    //  //             transactions[index].title,
    //  //             //New way to reference the theme in the main.dart file (taken from context)
    //  //             style: Theme.of(context).textTheme.title,
    //  //             // style:
    //  //             //     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //  //           ),
    //  //           Text(
    //  //             DateFormat.yMMMd().format(transactions[index].date),
    //  //             style: TextStyle(color: Colors.grey),
    //  //           )
    //  //         ],
    //  //       )
    //  //     ],
    //  //   ),
    //  // );
    // },
    // itemCount: transactions.length,
    // //The map() will return an anonymous function which will generate a new card inside of it. This will then return a list of cards, depending on the number of transactions.
    // // children: transactions.map((tx) {

    // // }).toList(),
    // );
  }
}
