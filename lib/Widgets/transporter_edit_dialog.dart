import 'package:flutter/material.dart';

import 'package:shipper_app/Widgets/custom_text_field.dart';

class TransporterEditDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController vendorNumberController = TextEditingController();

  TransporterEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        heightFactor: 0.8,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF152968),
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        icon: const Icon(Icons.close), // Add a close icon
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Enter Transporter name ',
                          labelText: 'Transporter name',
                          controller: nameController,
                        ),
                      ),
                      const SizedBox(width: 15), // Add spacing between columns
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Enter Contact Number ',
                          labelText: 'Contact Number',
                          controller: emailController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Enter Email id',
                          labelText: 'Email id',
                          controller: nameController,
                        ),
                      ),
                      const SizedBox(width: 15), // Add spacing between columns
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Enter Pan Number',
                          labelText: 'Pan Number',
                          controller: emailController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Enter GST Number',
                          labelText: 'GST Number',
                          controller: gstNumberController,
                        ),
                      ),
                      const SizedBox(width: 15), // Add spacing between columns
                      Flexible(
                        flex: 2,
                        child: CustomTextField(
                          hintText: 'Enter Vendor Number',
                          labelText: 'Vendor Number',
                          controller: vendorNumberController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 325), // Add horizontal padding
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(40, 50),
                        alignment: Alignment.center,
                        primary:
                            Colors.green, // Set the background color to green
                        onPrimary: Colors.white, // Set the text color to white
                      ),
                      child: const Text('Save Details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
