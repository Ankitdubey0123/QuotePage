import 'package:flutter/material.dart';
import '../models/client_info_model.dart';
import '../models/quote_item_model.dart';
import '../models/quote_model.dart';
import '../services/quote_calculation_service.dart';
import 'package:uuid/uuid.dart';

class QuoteViewModel extends ChangeNotifier {
  late Quote _quote;
  final QuoteCalculatorService _calculator = QuoteCalculatorService();
  final Uuid _uuid = const Uuid();

  // Public getters
  Quote get quote => _quote;
  ClientInfo get clientInfo => _quote.client;
  List<QuoteItem> get items => _quote.items;

  // Calculated properties
  double get subtotal =>
      _calculator.getSubtotal(_quote.items, _quote.isTaxInclusive);
  double get totalTax =>
      _calculator.getTotalTax(_quote.items, _quote.isTaxInclusive);
  double get grandTotal =>
      _calculator.getGrandTotal(_quote.items, _quote.isTaxInclusive);

  QuoteViewModel() {
    _quote = Quote(
      client: ClientInfo(),
      items: [],
    );
  }

  // --- Client Info Methods ---
  void updateClientInfo({String? name, String? address, String? reference}) {
    if (name != null) _quote.client.name = name;
    if (address != null) _quote.client.address = address;
    if (reference != null) _quote.client.reference = reference;
    notifyListeners();
  }

  // --- Line Item Methods ---
  void addItem() {
    _quote.items.add(QuoteItem(id: _uuid.v4()));
    notifyListeners();
  }

  void removeItem(String id) {
    _quote.items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateItem(
      String id, {
        String? name,
        double? quantity,
        double? rate,
        double? discount,
        double? taxPercent,
      }) {
    try {
      final item = _quote.items.firstWhere((item) => item.id == id);
      if (name != null) item.name = name;
      if (quantity != null) item.quantity = quantity;
      if (rate != null) item.rate = rate;
      if (discount != null) item.discount = discount;
      if (taxPercent != null) item.taxPercent = taxPercent;
      notifyListeners();
    } catch (e) {
      // Handle error: item not found
      debugPrint("Error updating item: $e");
    }
  }

  // --- Quote Status & Tax Mode ---
  void setTaxMode(bool isInclusive) {
    _quote.isTaxInclusive = isInclusive;
    notifyListeners();
  }

  void sendQuote() {
    _quote.status = QuoteStatus.Sent;
    notifyListeners();
    // Here you would typically save to a database or API
  }
}