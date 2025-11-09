Product Quote Builder - Flutter

This Flutter application fulfills the requirements for the "Product Quote Builder" assignment.

It allows a user to create a professional quote by:

Entering client information.

Dynamically adding and removing product/service line items.

Inputting quantity, rate, discount, and tax % for each item.

The app provides real-time calculations for line totals, subtotal, total tax, and a grand total.

Features Implemented

Dynamic Line Items: Users can add or remove an unlimited number of line items.

Real-time Calculations: All totals are recalculated instantly on any change using a ChangeNotifier and a dedicated QuoteCalculatorService.

Responsive UI:

The line item input row (quote_item_row.dart) uses a Wrap widget to stack inputs vertically on smaller screens, ensuring no horizontal overflow.

The main form is in a ListView to allow scrolling.

Professional Layout: Clean, padded, and well-organized UI components.

Quote Preview: A "Preview" button in the app bar navigates to a read-only, professional-looking preview screen that uses a DataTable for a clean, printable layout.

Separation of Concerns:

Models: quote.dart, quote_item.dart, client_info.dart

Services: quote_calculator_service.dart (handles all business logic).

View Models: quote_view_model.dart (manages state with ChangeNotifier).

Screens: quote_builder_screen.dart, quote_preview_screen.dart.

Widgets: Reusable components like client_info_form.dart, quote_item_row.dart, quote_summary.dart.

Bonus Features Implemented

Tax Mode: A toggle switch allows the user to select between "Tax Exclusive" (default) and "Tax Inclusive" calculations.

Currency Formatting: All totals are formatted as USD ($X,XXX.XX) using the intl package.

Quote Status (Partial): The Quote model includes a QuoteStatus enum (Draft, Sent, Accepted), and the "Send" button simulates this change, which is visible on the preview screen.

Screenshots Description

As requested, here is a description of what screenshots would show:

Filled Form (Mobile):

A mobile view of the QuoteBuilderScreen.

The "Client Info" section at the top shows a filled name, address, and reference.

The "Tax Exclusive / Inclusive" toggle is visible.

Two line items are shown. Because of the small screen, the inputs for each line item (Product, Qty, Rate, etc.) are "wrapped" and stacked vertically.

Below the line items, the QuoteSummary card is visible, showing the calculated Subtotal, Total Tax, and Grand Total, all formatted as currency.

The "Add Item" and "Send Quote" buttons are at the bottom.

Quote Preview (Desktop/Tablet):

A wider view of the QuotePreviewScreen.

The top shows "YOUR COMPANY" details and the "CLIENT" details side-by-side.

Below that, "Quote Details" show the Reference # and the "Status" (e.g., "Sent").

A DataTable neatly displays the line items with columns like "Product", "Qty", "Rate", "Base Total", "Tax", and "Line Total".

At the bottom right of the table, the Subtotal, Total Tax, and Grand Total are displayed clearly, aligning with professional invoice standards.
