import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/graphql_config.dart';
import '../../utils/app_colors.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'FOOD';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'value': 'FOOD', 'label': 'Food', 'icon': Icons.restaurant},
    {'value': 'TRANSPORT', 'label': 'Transport', 'icon': Icons.directions_car},
    {'value': 'SHOPPING', 'label': 'Shopping', 'icon': Icons.shopping_bag},
    {'value': 'ENERGY', 'label': 'Energy', 'icon': Icons.bolt},
    {'value': 'SERVICES', 'label': 'Services', 'icon': Icons.room_service},
    {'value': 'ENTERTAINMENT', 'label': 'Entertainment', 'icon': Icons.movie},
    {'value': 'TRAVEL', 'label': 'Travel', 'icon': Icons.flight},
    {'value': 'HEALTHCARE', 'label': 'Healthcare', 'icon': Icons.local_hospital},
    {'value': 'EDUCATION', 'label': 'Education', 'icon': Icons.school},
    {'value': 'TECHNOLOGY', 'label': 'Technology', 'icon': Icons.computer},
    {'value': 'FASHION', 'label': 'Fashion', 'icon': Icons.checkroom},
    {'value': 'HOME', 'label': 'Home', 'icon': Icons.home},
    {'value': 'GREEN', 'label': 'Green', 'icon': Icons.eco},
    {'value': 'OTHER', 'label': 'Other', 'icon': Icons.payment},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(
        MutationOptions(
          document: gql(GraphQLConfig.createTransactionMutation),
          variables: {
            'amount': double.parse(_amountController.text),
            'category': _selectedCategory,
            'merchant': _merchantController.text.isEmpty
                ? null
                : _merchantController.text.trim(),
            'description': _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text.trim(),
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add transaction: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['value'] as String,
                    child: Row(
                      children: [
                        Icon(category['icon'] as IconData, size: 20),
                        const SizedBox(width: 12),
                        Text(category['label'] as String),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  labelText: 'Merchant (Optional)',
                  prefixIcon: Icon(Icons.store),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                color: AppColors.info.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Carbon footprint will be calculated automatically based on the category',
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _handleSubmit(context),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
