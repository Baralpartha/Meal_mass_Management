import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    this.initialDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime _selected;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate ?? DateTime.now();
    _controller = TextEditingController(
        text: DateFormat('dd MMM yyyy').format(_selected));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: widget.firstDate ?? DateTime(2020),
      lastDate: widget.lastDate ?? DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selected = picked;
        _controller.text = DateFormat('dd MMM yyyy').format(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: _pick,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
          ),
        ),
      ],
    );
  }
}
