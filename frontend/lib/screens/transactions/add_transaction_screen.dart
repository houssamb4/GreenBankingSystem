import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/router.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/providers/providers.dart';
import 'package:frontend/widgets/components.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId;

  const AddTransactionScreen({Key? key, this.transactionId}) : super(key: key);

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _merchantController;
  late TextEditingController _detailsController;

  DateTime? _selectedDate;
  Category? _selectedCategory;
  PaymentMethod? _selectedPaymentMethod;
  String _currency = 'EUR';
  bool _autoCategory = false;
  CarbonEstimate? _carbonEstimate;

  // Merchant suggestions (mock)
  final List<String> _merchantSuggestions = [
    'Amazon',
    'Supermarket ABC',
    'Shell Gas Station',
    'Restaurant XYZ',
    'Airline Booking',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _merchantController = TextEditingController();
    _detailsController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _calculateCarbonEstimate() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() => _carbonEstimate = null);
      return;
    }

    // Mock calculation - replace with actual GraphQL query
    final factor = _getEmissionFactor(_selectedCategory);
    final grams = amount * factor * 1000;

    setState(() {
      _carbonEstimate = CarbonEstimate(
        grams: grams,
        emissionFactor: factor,
        factorUnit: 'kg CO₂e / €',
        formula:
            '${amount.toStringAsFixed(2)} € × $factor = ${(grams / 1000).toStringAsFixed(3)} kg CO₂e',
        explanation:
            'Based on ${_selectedCategory?.toString().split('.').last ?? 'general'} emission factor',
      );
    });
  }

  double _getEmissionFactor(Category? category) {
    switch (category) {
      case Category.transport:
        return 0.25;
      case Category.food:
        return 0.15;
      case Category.shopping:
        return 0.08;
      case Category.utilities:
        return 0.30;
      case Category.entertainment:
        return 0.12;
      case Category.health:
        return 0.10;
      case Category.travel:
        return 0.35;
      case Category.other:
        return 0.10;
      default:
        return 0.10;
    }
  }

  void _saveTransaction() {
    if (_amountController.text.isEmpty ||
        _merchantController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction saved successfully')),
    );

    // Navigate back
    context.go(Routes.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: isDesktop
          ? _DesktopAddTransactionLayout(
              amountController: _amountController,
              merchantController: _merchantController,
              detailsController: _detailsController,
              selectedDate: _selectedDate,
              selectedCategory: _selectedCategory,
              selectedPaymentMethod: _selectedPaymentMethod,
              currency: _currency,
              autoCategory: _autoCategory,
              carbonEstimate: _carbonEstimate,
              merchantSuggestions: _merchantSuggestions,
              onDateChanged: (date) => setState(() => _selectedDate = date),
              onCategoryChanged: (category) {
                setState(() => _selectedCategory = category);
                _calculateCarbonEstimate();
              },
              onPaymentMethodChanged: (method) =>
                  setState(() => _selectedPaymentMethod = method),
              onCurrencyChanged: (currency) =>
                  setState(() => _currency = currency),
              onAutoCategoryChanged: (value) =>
                  setState(() => _autoCategory = value),
              onAmountChanged: (_) => _calculateCarbonEstimate(),
              onSave: _saveTransaction,
            )
          : _MobileAddTransactionLayout(
              amountController: _amountController,
              merchantController: _merchantController,
              detailsController: _detailsController,
              selectedDate: _selectedDate,
              selectedCategory: _selectedCategory,
              selectedPaymentMethod: _selectedPaymentMethod,
              currency: _currency,
              autoCategory: _autoCategory,
              carbonEstimate: _carbonEstimate,
              merchantSuggestions: _merchantSuggestions,
              onDateChanged: (date) => setState(() => _selectedDate = date),
              onCategoryChanged: (category) {
                setState(() => _selectedCategory = category);
                _calculateCarbonEstimate();
              },
              onPaymentMethodChanged: (method) =>
                  setState(() => _selectedPaymentMethod = method),
              onCurrencyChanged: (currency) =>
                  setState(() => _currency = currency),
              onAutoCategoryChanged: (value) =>
                  setState(() => _autoCategory = value),
              onAmountChanged: (_) => _calculateCarbonEstimate(),
              onSave: _saveTransaction,
            ),
    );
  }
}

class _DesktopAddTransactionLayout extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController merchantController;
  final TextEditingController detailsController;
  final DateTime? selectedDate;
  final Category? selectedCategory;
  final PaymentMethod? selectedPaymentMethod;
  final String currency;
  final bool autoCategory;
  final CarbonEstimate? carbonEstimate;
  final List<String> merchantSuggestions;
  final Function(DateTime) onDateChanged;
  final Function(Category?) onCategoryChanged;
  final Function(PaymentMethod?) onPaymentMethodChanged;
  final Function(String) onCurrencyChanged;
  final Function(bool) onAutoCategoryChanged;
  final Function(String) onAmountChanged;
  final VoidCallback onSave;

  const _DesktopAddTransactionLayout({
    required this.amountController,
    required this.merchantController,
    required this.detailsController,
    required this.selectedDate,
    required this.selectedCategory,
    required this.selectedPaymentMethod,
    required this.currency,
    required this.autoCategory,
    required this.carbonEstimate,
    required this.merchantSuggestions,
    required this.onDateChanged,
    required this.onCategoryChanged,
    required this.onPaymentMethodChanged,
    required this.onCurrencyChanged,
    required this.onAutoCategoryChanged,
    required this.onAmountChanged,
    required this.onSave,
  });

  @override
  State<_DesktopAddTransactionLayout> createState() =>
      _DesktopAddTransactionLayoutState();
}

class _DesktopAddTransactionLayoutState
    extends State<_DesktopAddTransactionLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Form Section (Left)
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: _TransactionForm(
              amountController: widget.amountController,
              merchantController: widget.merchantController,
              detailsController: widget.detailsController,
              selectedDate: widget.selectedDate,
              selectedCategory: widget.selectedCategory,
              selectedPaymentMethod: widget.selectedPaymentMethod,
              currency: widget.currency,
              autoCategory: widget.autoCategory,
              merchantSuggestions: widget.merchantSuggestions,
              onDateChanged: widget.onDateChanged,
              onCategoryChanged: widget.onCategoryChanged,
              onPaymentMethodChanged: widget.onPaymentMethodChanged,
              onCurrencyChanged: widget.onCurrencyChanged,
              onAutoCategoryChanged: widget.onAutoCategoryChanged,
              onAmountChanged: widget.onAmountChanged,
            ),
          ),
        ),
        const VerticalDivider(color: AppTheme.borderLight),
        // Preview Section (Right)
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carbon Estimate',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                if (widget.carbonEstimate != null)
                  _CarbonEstimatePreview(estimate: widget.carbonEstimate!)
                else
                  Container(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundNeutral,
                      borderRadius: BorderRadius.circular(
                        AppTheme.cornerRadius,
                      ),
                    ),
                    child: Text(
                      'Fill in the form to calculate carbon estimate',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: AppTheme.paddingXLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onSave,
                    child: const Text('Save Transaction'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileAddTransactionLayout extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController merchantController;
  final TextEditingController detailsController;
  final DateTime? selectedDate;
  final Category? selectedCategory;
  final PaymentMethod? selectedPaymentMethod;
  final String currency;
  final bool autoCategory;
  final CarbonEstimate? carbonEstimate;
  final List<String> merchantSuggestions;
  final Function(DateTime) onDateChanged;
  final Function(Category?) onCategoryChanged;
  final Function(PaymentMethod?) onPaymentMethodChanged;
  final Function(String) onCurrencyChanged;
  final Function(bool) onAutoCategoryChanged;
  final Function(String) onAmountChanged;
  final VoidCallback onSave;

  const _MobileAddTransactionLayout({
    required this.amountController,
    required this.merchantController,
    required this.detailsController,
    required this.selectedDate,
    required this.selectedCategory,
    required this.selectedPaymentMethod,
    required this.currency,
    required this.autoCategory,
    required this.carbonEstimate,
    required this.merchantSuggestions,
    required this.onDateChanged,
    required this.onCategoryChanged,
    required this.onPaymentMethodChanged,
    required this.onCurrencyChanged,
    required this.onAutoCategoryChanged,
    required this.onAmountChanged,
    required this.onSave,
  });

  @override
  State<_MobileAddTransactionLayout> createState() =>
      _MobileAddTransactionLayoutState();
}

class _MobileAddTransactionLayoutState
    extends State<_MobileAddTransactionLayout> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TransactionForm(
              amountController: widget.amountController,
              merchantController: widget.merchantController,
              detailsController: widget.detailsController,
              selectedDate: widget.selectedDate,
              selectedCategory: widget.selectedCategory,
              selectedPaymentMethod: widget.selectedPaymentMethod,
              currency: widget.currency,
              autoCategory: widget.autoCategory,
              merchantSuggestions: widget.merchantSuggestions,
              onDateChanged: widget.onDateChanged,
              onCategoryChanged: widget.onCategoryChanged,
              onPaymentMethodChanged: widget.onPaymentMethodChanged,
              onCurrencyChanged: widget.onCurrencyChanged,
              onAutoCategoryChanged: widget.onAutoCategoryChanged,
              onAmountChanged: widget.onAmountChanged,
            ),
            const SizedBox(height: AppTheme.paddingXLarge),
            Text(
              'Carbon Estimate',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            if (widget.carbonEstimate != null)
              _CarbonEstimatePreview(estimate: widget.carbonEstimate!)
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundNeutral,
                  borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                ),
                child: Text(
                  'Fill in the form to calculate carbon estimate',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: AppTheme.paddingLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSave,
                child: const Text('Save Transaction'),
              ),
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go(Routes.transactions),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionForm extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController merchantController;
  final TextEditingController detailsController;
  final DateTime? selectedDate;
  final Category? selectedCategory;
  final PaymentMethod? selectedPaymentMethod;
  final String currency;
  final bool autoCategory;
  final List<String> merchantSuggestions;
  final Function(DateTime) onDateChanged;
  final Function(Category?) onCategoryChanged;
  final Function(PaymentMethod?) onPaymentMethodChanged;
  final Function(String) onCurrencyChanged;
  final Function(bool) onAutoCategoryChanged;
  final Function(String) onAmountChanged;

  const _TransactionForm({
    required this.amountController,
    required this.merchantController,
    required this.detailsController,
    required this.selectedDate,
    required this.selectedCategory,
    required this.selectedPaymentMethod,
    required this.currency,
    required this.autoCategory,
    required this.merchantSuggestions,
    required this.onDateChanged,
    required this.onCategoryChanged,
    required this.onPaymentMethodChanged,
    required this.onCurrencyChanged,
    required this.onAutoCategoryChanged,
    required this.onAmountChanged,
  });

  @override
  State<_TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<_TransactionForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.paddingMedium),

        // Date Picker
        Text('Date *', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: widget.selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              widget.onDateChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMedium,
              vertical: AppTheme.paddingMedium,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              border: Border.all(color: AppTheme.borderLight),
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedDate != null
                      ? DateFormat('MMM d, yyyy').format(widget.selectedDate!)
                      : 'Select date',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppTheme.paddingLarge),

        // Amount & Currency
        Text('Amount *', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: widget.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '0.00'),
                onChanged: widget.onAmountChanged,
              ),
            ),
            const SizedBox(width: AppTheme.paddingMedium),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                ),
                child: DropdownButton<String>(
                  value: widget.currency,
                  items: ['EUR', 'USD', 'GBP'].map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      widget.onCurrencyChanged(value ?? 'EUR'),
                  underline: const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.paddingLarge),

        // Merchant
        Text('Merchant *', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        TextField(
          controller: widget.merchantController,
          decoration: InputDecoration(
            hintText: 'Enter merchant name',
            suffixIcon: widget.merchantController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.merchantController.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppTheme.paddingLarge),

        // Category
        Text('Category *', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingMedium,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderLight),
            borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
          ),
          child: DropdownButton<Category>(
            value: widget.selectedCategory,
            hint: const Text('Select category'),
            isExpanded: true,
            underline: const SizedBox.shrink(),
            items: Category.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.toString().split('.').last),
                  ),
                )
                .toList(),
            onChanged: widget.onCategoryChanged,
          ),
        ),
        const SizedBox(height: AppTheme.paddingMedium),

        // Auto Category Chip
        if (widget.autoCategory)
          Chip(
            label: const Text('Category Suggested'),
            backgroundColor: AppTheme.primaryLightGreen.withOpacity(0.2),
            labelStyle: const TextStyle(color: AppTheme.primaryDarkGreen),
          ),
        const SizedBox(height: AppTheme.paddingLarge),

        // Payment Method
        Text('Payment Method', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: AppTheme.paddingMedium,
          children: PaymentMethod.values
              .map(
                (method) => FilterChip(
                  label: Text(method.toString().split('.').last),
                  selected: widget.selectedPaymentMethod == method,
                  onSelected: (selected) {
                    widget.onPaymentMethodChanged(selected ? method : null);
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppTheme.paddingLarge),

        // Details (Optional)
        Text(
          'Details (Optional)',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.detailsController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Add any additional notes...',
          ),
        ),
      ],
    );
  }
}

class _CarbonEstimatePreview extends StatelessWidget {
  final CarbonEstimate estimate;

  const _CarbonEstimatePreview({required this.estimate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco, color: AppTheme.primaryDarkGreen, size: 24),
              const SizedBox(width: AppTheme.paddingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    estimate.grams >= 1000
                        ? '${(estimate.grams / 1000).toStringAsFixed(3)} kg'
                        : '${estimate.grams.toStringAsFixed(0)} g',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryDarkGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CO₂ Equivalent',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingLarge),
          const Divider(color: AppTheme.borderLight),
          const SizedBox(height: AppTheme.paddingMedium),
          _DetailRow(
            label: 'Emission Factor',
            value: '${estimate.emissionFactor} ${estimate.factorUnit}',
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          _DetailRow(label: 'Formula', value: estimate.formula),
          const SizedBox(height: AppTheme.paddingMedium),
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            decoration: BoxDecoration(
              color: AppTheme.primaryDarkGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppTheme.smallCornerRadius),
            ),
            child: Text(
              estimate.explanation,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
