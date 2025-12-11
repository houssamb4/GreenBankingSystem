import 'package:flutter/material.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/models/models.dart';

/// KPI Card Component - displays metric + value + optional variation
class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final Color? iconColor;
  final double? variation;
  final bool isPositive;
  final VoidCallback? onTap;

  const KpiCard({
    Key? key,
    required this.label,
    required this.value,
    this.unit,
    required this.icon,
    this.iconColor,
    this.variation,
    this.isPositive = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final variationColor = isPositive
        ? AppTheme.successGreen
        : AppTheme.warningOrange;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  Icon(
                    icon,
                    size: 20,
                    color: iconColor ?? AppTheme.primaryDarkGreen,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: Theme.of(context).textTheme.headlineSmall),
                  if (unit != null) ...[
                    const SizedBox(width: AppTheme.paddingSmall),
                    Text(unit!, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ],
              ),
              if (variation != null) ...[
                const SizedBox(height: AppTheme.paddingSmall),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: variationColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${variation!.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: variationColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Transaction Card Component
class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.transport:
        return const Color(0xFFFF6B6B);
      case Category.food:
        return const Color(0xFF4ECDC4);
      case Category.shopping:
        return const Color(0xFFFFE66D);
      case Category.utilities:
        return const Color(0xFF95E1D3);
      case Category.entertainment:
        return const Color(0xFFA8E6CF);
      case Category.health:
        return const Color(0xFFFF8B94);
      case Category.travel:
        return const Color(0xFF8EC5FC);
      case Category.other:
        return const Color(0xFFCCCCCC);
    }
  }

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.transport:
        return Icons.directions_car;
      case Category.food:
        return Icons.restaurant;
      case Category.shopping:
        return Icons.shopping_bag;
      case Category.utilities:
        return Icons.bolt;
      case Category.entertainment:
        return Icons.movie;
      case Category.health:
        return Icons.local_hospital;
      case Category.travel:
        return Icons.flight;
      case Category.other:
        return Icons.category;
    }
  }

  String _formatCO2(double grams) {
    if (grams >= 1000) {
      return '${(grams / 1000).toStringAsFixed(2)} kg';
    }
    return '${grams.toStringAsFixed(0)} g';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(transaction.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    AppTheme.smallCornerRadius,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(transaction.category),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.paddingMedium),
              // Transaction Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.merchant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            transaction.category
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: categoryColor.withOpacity(0.2),
                          labelStyle: TextStyle(color: categoryColor),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CO₂: ${_formatCO2(transaction.estimatedCO2grams)}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.primaryDarkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.paddingMedium),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date.toString().split(' ')[0],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              if (onEdit != null || onDelete != null) ...[
                const SizedBox(width: AppTheme.paddingSmall),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem(onTap: onEdit, child: const Text('Edit')),
                    if (onDelete != null)
                      PopupMenuItem(
                        onTap: onDelete,
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: AppTheme.errorRed),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Category Badge Component
class CategoryBadge extends StatelessWidget {
  final Category category;
  final bool compact;

  const CategoryBadge({Key? key, required this.category, this.compact = false})
    : super(key: key);

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.transport:
        return const Color(0xFFFF6B6B);
      case Category.food:
        return const Color(0xFF4ECDC4);
      case Category.shopping:
        return const Color(0xFFFFE66D);
      case Category.utilities:
        return const Color(0xFF95E1D3);
      case Category.entertainment:
        return const Color(0xFFA8E6CF);
      case Category.health:
        return const Color(0xFFFF8B94);
      case Category.travel:
        return const Color(0xFF8EC5FC);
      case Category.other:
        return const Color(0xFFCCCCCC);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(category);
    final label = category.toString().split('.').last;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppTheme.smallCornerRadius),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Confirm Dialog Component
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive
                ? AppTheme.errorRed
                : AppTheme.primaryDarkGreen,
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Carbon Detail Accordion Component
class CarbonDetailAccordion extends StatefulWidget {
  final Transaction transaction;

  const CarbonDetailAccordion({Key? key, required this.transaction})
    : super(key: key);

  @override
  State<CarbonDetailAccordion> createState() => _CarbonDetailAccordionState();
}

class _CarbonDetailAccordionState extends State<CarbonDetailAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carbon Footprint',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.transaction.estimatedCO2kg.toStringAsFixed(3)} kg CO₂e',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppTheme.primaryDarkGreen,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.primaryDarkGreen,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: AppTheme.borderLight),
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: 'Amount',
                    value:
                        '${widget.transaction.amount.toStringAsFixed(2)} ${widget.transaction.currency}',
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _DetailRow(
                    label: 'Category',
                    value: widget.transaction.category
                        .toString()
                        .split('.')
                        .last,
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _DetailRow(label: 'Emission Factor', value: '100 gCO₂e/€'),
                  const SizedBox(height: AppTheme.paddingMedium),
                  _DetailRow(label: 'Formula', value: 'Amount × Factor = CO₂'),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLightGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppTheme.smallCornerRadius,
                      ),
                    ),
                    child: Text(
                      'This transaction is equivalent to driving a car for ${(widget.transaction.estimatedCO2grams / 100).toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMedium),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

/// Empty State Component
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.textLight),
          const SizedBox(height: AppTheme.paddingLarge),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: AppTheme.paddingLarge),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Loading State Component
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.primaryDarkGreen,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.paddingMedium),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
