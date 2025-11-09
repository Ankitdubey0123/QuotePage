import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/quote_item_model.dart';

class QuoteItemRow extends StatefulWidget {
  final QuoteItem item;
  final Function(String id, {String? name, double? quantity, double? rate, double? discount, double? taxPercent}) onUpdate;
  final Function(String id) onRemove;

  const QuoteItemRow({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<QuoteItemRow> createState() => _QuoteItemRowState();
}

class _QuoteItemRowState extends State<QuoteItemRow> {
  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _rateController;
  late final TextEditingController _discountController;
  late final TextEditingController _taxController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _qtyController =
        TextEditingController(text: widget.item.quantity.toString());
    _rateController = TextEditingController(text: widget.item.rate.toString());
    _discountController =
        TextEditingController(text: widget.item.discount.toString());
    _taxController =
        TextEditingController(text: widget.item.taxPercent.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      Function(String) onChanged, {
        bool isNumeric = false,
      }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      // Use flexible width for responsiveness
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 100, // Min width for small screens
          maxWidth: 200, // Max width on large screens
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          ),
          onChanged: onChanged,
          keyboardType: isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
              : [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Responsive Wrap for form fields
            Wrap(
              spacing: 8.0, // Horizontal space between items
              runSpacing: 8.0, // Vertical space between lines
              alignment: WrapAlignment.start,
              children: [
                // Product Name (Wider)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 150,
                      maxWidth: 300,
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product/Service',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                      ),
                      onChanged: (val) =>
                          widget.onUpdate(widget.item.id, name: val),
                    ),
                  ),
                ),
                _buildTextField(
                  'Qty',
                  _qtyController,
                      (val) => widget.onUpdate(widget.item.id,
                      quantity: double.tryParse(val) ?? 0),
                  isNumeric: true,
                ),
                _buildTextField(
                  'Rate',
                  _rateController,
                      (val) => widget.onUpdate(widget.item.id,
                      rate: double.tryParse(val) ?? 0),
                  isNumeric: true,
                ),
                _buildTextField(
                  'Discount',
                  _discountController,
                      (val) => widget.onUpdate(widget.item.id,
                      discount: double.tryParse(val) ?? 0),
                  isNumeric: true,
                ),
                _buildTextField(
                  'Tax %',
                  _taxController,
                      (val) => widget.onUpdate(widget.item.id,
                      taxPercent: double.tryParse(val) ?? 0),
                  isNumeric: true,
                ),
              ],
            ),
            // Remove Button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Remove Item',
                onPressed: () => widget.onRemove(widget.item.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}