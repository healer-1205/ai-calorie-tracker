import 'package:flutter/material.dart';

class AlertMessageWidget extends StatelessWidget {
  final String? errorMessage;
  final String? successMessage;
  final VoidCallback onClose;

  const AlertMessageWidget({
    Key? key,
    this.errorMessage,
    this.successMessage,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: errorMessage != null ? Colors.red[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            errorMessage != null ? Icons.error : Icons.check_circle,
            color: errorMessage != null ? Colors.red : Colors.green,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage ?? successMessage ?? '',
              style: TextStyle(
                color: errorMessage != null ? Colors.red[900] : Colors.green[900],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onClose,
            color: errorMessage != null ? Colors.red[900] : Colors.green[900],
          ),
        ],
      ),
    );
  }
} 