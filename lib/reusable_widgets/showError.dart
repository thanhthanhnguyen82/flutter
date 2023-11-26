import 'package:flutter/material.dart';

class ErrorHandling {
  final String _errormessage;
  final BuildContext _context;
  ErrorHandling(this._context, this._errormessage);
  showErr() {
    return ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(_errormessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
