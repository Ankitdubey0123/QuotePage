class QuoteItem {
  final String id; // Unique ID for managing list state
  String name;
  double quantity;
  double rate;
  double discount;
  double taxPercent;

  QuoteItem({
    required this.id,
    this.name = '',
    this.quantity = 1,
    this.rate = 0,
    this.discount = 0,
    this.taxPercent = 0,
  });
}