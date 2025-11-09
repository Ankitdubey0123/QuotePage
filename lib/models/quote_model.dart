import 'package:meru/models/quote_item_model.dart';

import 'client_info_model.dart';

// Bonus: Quote Status Tracking
enum QuoteStatus { Draft, Sent, Accepted }

class Quote {
  ClientInfo client;
  List<QuoteItem> items;
  QuoteStatus status;
  bool isTaxInclusive; // Bonus: Tax mode

  Quote({
    required this.client,
    required this.items,
    this.status = QuoteStatus.Draft,
    this.isTaxInclusive = false,
  });
}