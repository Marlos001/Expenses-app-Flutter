import 'package:expenses/components/adaptativeDate.dart';
import 'package:expenses/components/adaptiveButton.dart';
import 'package:expenses/components/adaptiveField.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  TransactionForm(this.onSubmit, {super.key});

  final void Function(String, double, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
            top: 15,
            right: 15,
            left: 15,
            bottom: 15 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Adaptivefield(
                  label: 'Title',
                  onPressed: _submitForm,
                  controller: _titleController,
                  keyboardType: TextInputType.text),
              Adaptivefield(
                  label: 'Value',
                  onPressed: _submitForm,
                  controller: _valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true)),
              AdaptativeDate(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  adaptiveButton(
                    label: 'Nova Transação',
                    onPressed: _submitForm,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
