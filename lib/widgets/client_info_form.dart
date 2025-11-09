import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/quote_viewModel.dart';


class ClientInfoForm extends StatefulWidget {
  const ClientInfoForm({super.key});

  @override
  State<ClientInfoForm> createState() => _ClientInfoFormState();
}

class _ClientInfoFormState extends State<ClientInfoForm> {
  // Use controllers to avoid losing input on rebuild
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _refController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<QuoteViewModel>();
    _nameController = TextEditingController(text: viewModel.clientInfo.name);
    _addressController =
        TextEditingController(text: viewModel.clientInfo.address);
    _refController =
        TextEditingController(text: viewModel.clientInfo.reference);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _refController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<QuoteViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Info', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Client Name'),
              onChanged: (value) => viewModel.updateClientInfo(name: value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (value) => viewModel.updateClientInfo(address: value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _refController,
              decoration: const InputDecoration(labelText: 'Reference / PO Number'),
              onChanged: (value) => viewModel.updateClientInfo(reference: value),
            ),
          ],
        ),
      ),
    );
  }
}