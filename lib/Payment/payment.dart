import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cash_on_delivery';

  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _selectedPaymentMethod = value!;
    });

    if (value != 'cash_on_delivery') {
      _showComingSoonDialog();
    }
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Coming Soon', style: TextStyle(color: Colors.red)),
          content: const Text('This payment method is coming soon.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                // Reset to 'cash_on_delivery' if user selects a non-available payment method
                setState(() {
                  _selectedPaymentMethod = 'cash_on_delivery';
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white70,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Payment Options',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Choose your payment method:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash on Delivery'),
              trailing: Radio<String>(
                activeColor: Colors.red,
                value: 'cash_on_delivery',
                groupValue: _selectedPaymentMethod,
                onChanged: _onPaymentMethodChanged,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Master Card'),
              trailing: Radio<String>(
                activeColor: Colors.red,
                value: 'master_card',
                groupValue: _selectedPaymentMethod,
                onChanged: _onPaymentMethodChanged,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Easy Paisa'),
              trailing: Radio<String>(
                activeColor: Colors.red,
                value: 'easy_paisa',
                groupValue: _selectedPaymentMethod,
                onChanged: _onPaymentMethodChanged,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Proceed to checkout logic here
                  // For demonstration, let's just navigate to a dummy checkout screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Checkout Screen
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: const Center(
        child: Text('Checkout Screen'),
      ),
    );
  }
}
