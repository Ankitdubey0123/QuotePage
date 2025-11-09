import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/currency_service_util.dart';
import '../viewModel/quote_viewModel.dart';

class QuoteSummary extends StatelessWidget {
  const QuoteSummary({super.key});

  Widget _buildSummaryRow(String label, String value, BuildContext context,
      {bool isTotal = false}) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
      color: Theme.of(context).colorScheme.primary,
    )
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use 'watch' to rebuild this widget whenever totals change
    final viewModel = context.watch<QuoteViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(
              'Subtotal',
              CurrencyFormatter.format(viewModel.subtotal),
              context,
            ),
            _buildSummaryRow(
              'Total Tax',
              CurrencyFormatter.format(viewModel.totalTax),
              context,
            ),
            const Divider(height: 24, thickness: 1),
            _buildSummaryRow(
              'GRAND TOTAL',
              CurrencyFormatter.format(viewModel.grandTotal),
              context,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}