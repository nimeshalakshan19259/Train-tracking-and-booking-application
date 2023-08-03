import 'package:flutter/material.dart';
import '../widgets/add_credit_card_screen.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String walletBalance = '0';
  List<String> creditCards = [];

  // Example method to update the wallet balance
  void updateWalletBalance() {
    // Implement your logic to retrieve the wallet balance here
    // For example, you might fetch the balance from an API or database
    // and update the walletBalance variable
    setState(() {
      walletBalance = '100'; // Replace with your actual wallet balance
    });
  }

  // Method to navigate to the Add Credit Card screen
  void navigateToAddCreditCardScreen() async {
    final cardDetails = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCreditCardScreen()),
    );

    if (cardDetails != null) {
      // Perform necessary operations with the returned card details
      String newCard = 'Card Number: ${cardDetails['cardNumber']}\n'
          'Card Holder Name: ${cardDetails['cardHolderName']}\n'
          'Expiration Date: ${cardDetails['expirationDate']}\n'
          'CVV: ${cardDetails['cvv']}';

      setState(() {
        creditCards.add(newCard);
      });
    }
  }



  @override
  void initState() {
    super.initState();
    // Call the method to update the wallet balance when the screen loads
    updateWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wallet Balance: $walletBalance',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
        ElevatedButton(
          onPressed: navigateToAddCreditCardScreen,
          child: Text('Add Credit Card'),
        ),


            SizedBox(height: 20),
            Text(
              'Credit Cards:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: creditCards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(creditCards[index]),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}
