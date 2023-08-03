import 'package:flutter/material.dart';

class AddCreditCardScreen extends StatefulWidget {
  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  String cardNumber = '';
  String cardHolderName = '';
  String expirationDate = '';
  String cvv = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Credit Card'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
              onChanged: (value) {
                setState(() {
                  cardNumber = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Holder Name',
              ),
              onChanged: (value) {
                setState(() {
                  cardHolderName = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiration Date',
              ),
              onChanged: (value) {
                setState(() {
                  expirationDate = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
              ),
              onChanged: (value) {
                setState(() {
                  cvv = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Perform necessary operations to add the credit card
                // For example, you can pass the card details back to the WalletScreen
                Navigator.pop(context, {
                  'cardNumber': cardNumber,
                  'cardHolderName': cardHolderName,
                  'expirationDate': expirationDate,
                  'cvv': cvv,
                });
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
