

import '../models/quote_item_model.dart';

class QuoteCalculatorService {
  /// Calculates the total for a single item based on tax mode.
  Map<String, double> getItemTotals(QuoteItem item, bool isTaxInclusive) {
    double baseTotal;
    double taxAmount;
    double lineTotal;

    // Use a small epsilon to avoid floating point comparison issues
    const epsilon = 0.00001;

    // Ensure discount is not more than rate
    final discount = (item.discount > item.rate) ? item.rate : item.discount;
    final rateAfterDiscount = item.rate - discount;

    if (isTaxInclusive) {
      // The rate *includes* tax.
      lineTotal = rateAfterDiscount * item.quantity;
      baseTotal = lineTotal / (1 + (item.taxPercent / 100));
      taxAmount = lineTotal - baseTotal;
    } else {
      // The rate *excludes* tax.
      baseTotal = rateAfterDiscount * item.quantity;
      taxAmount = baseTotal * (item.taxPercent / 100);
      lineTotal = baseTotal + taxAmount;
    }

    // Handle potential -0.00 results from floating point math
    return {
      'baseTotal': (baseTotal.abs() < epsilon) ? 0.0 : baseTotal,
      'taxAmount': (taxAmount.abs() < epsilon) ? 0.0 : taxAmount,
      'lineTotal': (lineTotal.abs() < epsilon) ? 0.0 : lineTotal,
    };
  }

  /// Calculates the subtotal (sum of all base totals)
  double getSubtotal(List<QuoteItem> items, bool isTaxInclusive) {
    return items.fold(0.0, (sum, item) {
      return sum + getItemTotals(item, isTaxInclusive)['baseTotal']!;
    });
  }

  /// Calculates the total tax (sum of all tax amounts)
  double getTotalTax(List<QuoteItem> items, bool isTaxInclusive) {
    return items.fold(0.0, (sum, item) {
      return sum + getItemTotals(item, isTaxInclusive)['taxAmount']!;
    });
  }

  /// Calculates the grand total (sum of all line totals)
  double getGrandTotal(List<QuoteItem> items, bool isTaxInclusive) {
    return items.fold(0.0, (sum, item) {
      return sum + getItemTotals(item, isTaxInclusive)['lineTotal']!;
    });
  }
}