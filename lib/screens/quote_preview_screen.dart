import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/quote_model.dart';
import '../services/currency_service_util.dart';
import '../services/quote_calculation_service.dart';
import '../viewModel/quote_viewModel.dart';

class QuotePreviewScreen extends StatelessWidget {
  static const routeName = '/preview';

  const QuotePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuoteViewModel>();
    final quote = viewModel.quote;
    final calculator = QuoteCalculatorService(); // Use a local instance for preview

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print Quote',
            onPressed: () {
              // Placeholder for print functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print functionality not implemented.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            _buildHeader(context, quote),
            const SizedBox(height: 32),
            // --- Line Items Table ---
            Text('Items', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildItemsTable(context, viewModel, calculator),
            const SizedBox(height: 24),
            // --- Summary ---
            _buildSummary(context, viewModel),
            const SizedBox(height: 48),
            // --- Footer ---
            const Center(
              child: Text(
                'Thank you for your business!',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Quote quote) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Company Info ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR COMPANY',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text('123 Main Street\nYour City, ST 12345\n(123) 456-7890'),
            ],
          ),
        ),
        // --- Client & Quote Info ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'CLIENT',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                quote.client.name.isEmpty ? 'N/A' : quote.client.name,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                quote.client.address.isEmpty ? 'N/A' : quote.client.address,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 16),
              Text(
                'QUOTE DETAILS',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Ref #: ${quote.client.reference.isEmpty ? 'N/A' : quote.client.reference}',
                textAlign: TextAlign.end,
              ),
              Text(
                'Status: ${quote.status.name}',
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(
      BuildContext context, QuoteViewModel viewModel, QuoteCalculatorService calculator) {
    final textTheme = Theme.of(context).textTheme;
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);

    // Data table is great for this layout, but wrap in horizontal scroll
    // on small devices.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Product/Service', style: headerStyle)),
          DataColumn(label: Text('Qty', style: headerStyle), numeric: true),
          DataColumn(label: Text('Rate', style: headerStyle), numeric: true),
          DataColumn(label: Text('Base Total', style: headerStyle), numeric: true),
          DataColumn(label: Text('Tax', style: headerStyle), numeric: true),
          DataColumn(label: Text('Line Total', style: headerStyle), numeric: true),
        ],
        rows: viewModel.items.map((item) {
          final totals =
          calculator.getItemTotals(item, viewModel.quote.isTaxInclusive);
          final baseTotal = totals['baseTotal']!;
          final taxAmount = totals['taxAmount']!;
          final lineTotal = totals['lineTotal']!;

          return DataRow(
            cells: [
              DataCell(Text(item.name)),
              DataCell(Text(item.quantity.toStringAsFixed(2))),
              DataCell(Text(CurrencyFormatter.format(item.rate))),
              DataCell(Text(CurrencyFormatter.format(baseTotal))),
              DataCell(Text(CurrencyFormatter.format(taxAmount))),
              DataCell(Text(
                CurrencyFormatter.format(lineTotal),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, QuoteViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    Widget buildRow(String label, String value, [TextStyle? style]) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style ?? textTheme.bodyLarge),
          Text(value, style: style ?? textTheme.bodyLarge),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildRow(
                'Subtotal',
                CurrencyFormatter.format(viewModel.subtotal),
              ),
              const SizedBox(height: 8),
              buildRow(
                'Total Tax',
                CurrencyFormatter.format(viewModel.totalTax),
              ),
              const Divider(height: 24),
              buildRow(
                'GRAND TOTAL',
                CurrencyFormatter.format(viewModel.grandTotal),
                textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}