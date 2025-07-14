import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/widgets/comon_widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _existingQuantityController =
      TextEditingController();
  final TextEditingController _newOrderQuantityController =
      TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String? _selectedShop;
  final List<String> _shopDetailsOptions = [
    'Shop A - Downtown',
    'Shop B - Northside',
    'Shop C - East End',
    'Shop D - Westgate',
  ];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _existingQuantityController.dispose();
    _newOrderQuantityController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Date Field
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Select Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                readOnly:
                    true, // Makes the field non-editable, only selectable via picker
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 15),

              // Time Field
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  hintText: 'Select Time',
                  prefixIcon: const Icon(Icons.access_time),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 15),

              // Shop Details Dropdown
              DropdownButtonFormField<String>(
                value: _selectedShop,
                decoration: InputDecoration(
                  labelText: 'Shop Details',
                  hintText: 'Select a Shop',
                  prefixIcon: const Icon(Icons.store),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                items: _shopDetailsOptions.map((String shop) {
                  return DropdownMenuItem<String>(
                    value: shop,
                    child: Text(shop),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedShop = newValue;
                  });
                },
                isExpanded: true,
              ),
              const SizedBox(height: 15),

              // Existing Quantity Textbox
              TextFormField(
                controller: _existingQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Existing Quantity',
                  hintText: 'Enter existing quantity',
                  prefixIcon: const Icon(Icons.inventory),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // New Order Quantity (represented as a text field, but in real app could be a GridView/DataTable)
              TextFormField(
                controller: _newOrderQuantityController,
                keyboardType: TextInputType
                    .text, // Could be number or text based on grid content
                decoration: InputDecoration(
                  labelText: 'New Order Quantity (Grid)',
                  hintText: 'Enter new order quantity details',
                  prefixIcon: const Icon(Icons.grid_on),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                maxLines:
                    2, // Allow multiple lines for potential grid-like input description
              ),
              const SizedBox(height: 20),

              CommonWidgets.button(
                lable: 'Capture Photo',
                color: Colors.blue.shade600,
                onPressed: (){
                  _showMessage(
                    context,
                    'Capture Photo functionality not implemented.',
                  );
                },
                icon: const Icon(Icons.camera,color: Colors.white,),
              ),
                            const SizedBox(height: 15),

              CommonWidgets.button(
                lable: 'Capture Video',
                color: Colors.blue.shade600,
                onPressed: _submitForm,
                icon: const Icon(Icons.video_call,color: Colors.white,),
              ),
  
              const SizedBox(height: 15),

              // Remarks MultiText Box
              TextFormField(
                controller: _remarksController,
                maxLines: 4, // Allows for multiple lines of input
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  hintText: 'Enter any additional remarks here...',
                  prefixIcon: const Icon(Icons.notes),
                  alignLabelWithHint: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CommonWidgets.button(
                      lable: 'Submit',
                      color: Colors.blue.shade800,
                      onPressed: _submitForm,
                    ),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: CommonWidgets.button(
                      lable: 'Reset',
                      color: Colors.blue.shade800,
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  // Function to handle form submission
  void _submitForm() {
    // Basic validation
    if (_dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _selectedShop == null ||
        _existingQuantityController.text.isEmpty ||
        _newOrderQuantityController.text.isEmpty ||
        _remarksController.text.isEmpty) {
      _showMessage(context, 'Please fill all fields.');
      return;
    }
    // You can process the form data here
    final formData = {
      'date': _dateController.text,
      'time': _timeController.text,
      'shopDetails': _selectedShop,
      'existingQuantity': _existingQuantityController.text,
      'newOrderQuantity': _newOrderQuantityController.text,
      'remarks': _remarksController.text,
    };
    print('Form Data: $formData');
    _showMessage(context, 'Form Submitted Successfully!');
    // Clear fields after submission
    _dateController.clear();
    _timeController.clear();
    _existingQuantityController.clear();
    _newOrderQuantityController.clear();
    _remarksController.clear();
    setState(() {
      _selectedShop = null;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  // Helper function to show a message (instead of alert)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
