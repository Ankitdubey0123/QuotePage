import 'package:flutter/material.dart';
import 'package:meru/screens/quote_preview_screen.dart';
import 'package:provider/provider.dart';
import '../viewModel/quote_viewModel.dart';
import '../widgets/client_info_form.dart';
import '../widgets/quote_item_row.dart';
import '../widgets/quote_summary.dart';


class QuoteBuilderScreen extends StatelessWidget {
  const QuoteBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuoteViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            tooltip: 'Preview Quote',
            onPressed: () {
              Navigator.pushNamed(context, QuotePreviewScreen.routeName);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Client Info ---
          const ClientInfoForm(),

          // --- Tax Mode Toggle (Bonus) ---
          Card(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax Mode',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Text(
                        'Exclusive',
                        style: TextStyle(
                            color: !viewModel.quote.isTaxInclusive
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                      ),
                      Switch(
                        value: viewModel.quote.isTaxInclusive,
                        onChanged: (val) {
                          viewModel.setTaxMode(val);
                        },
                      ),
                      Text(
                        'Inclusive',
                        style: TextStyle(
                            color: viewModel.quote.isTaxInclusive
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- Line Items ---
          const SizedBox(height: 16),
          Text('Line Items', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (viewModel.items.isEmpty)
            const Center(
              child: Text(
                'No items added. Tap "Add Item" to start.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              final item = viewModel.items[index];
              return QuoteItemRow(
                key: ValueKey(item.id), // Important for list state
                item: item,
                onUpdate: viewModel.updateItem,
                onRemove: viewModel.removeItem,
              );
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              onPressed: () {
                context.read<QuoteViewModel>().addItem();
              },
            ),
          ),

          // --- Totals ---
          const SizedBox(height: 24),
          const QuoteSummary(),

          // --- Actions ---
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              child: const Text('Send Quote'),
              onPressed: () {
                context.read<QuoteViewModel>().sendQuote();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quote status set to "Sent"'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushNamed(context, QuotePreviewScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}