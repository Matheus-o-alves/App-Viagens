import 'package:flutter/material.dart';

class MakePaymentComponent extends StatelessWidget {
  const MakePaymentComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you want to make a payment? ',
            style: TextStyle(
              color: Color(0xFF37404E),
              fontSize: 16,
              fontFamily: 'Lato',
            ),
          ),
          GestureDetector(
            onTap: () {
            },
            child: const Text(
              'Click here',
              style: TextStyle(
                color: Color(0xFF2C681D),
                fontSize: 16,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

