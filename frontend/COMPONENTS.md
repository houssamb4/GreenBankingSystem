# Green Banking System - Component Library

Complete reference for reusable UI components in the application.

## KpiCard

Displays a key performance indicator with value, unit, and optional variation.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| label | String | ✅ | Card label (e.g., "Total CO₂") |
| value | String | ✅ | Main value to display |
| unit | String | ❌ | Unit suffix (e.g., "kg", "grams") |
| icon | IconData | ✅ | Icon to display |
| iconColor | Color | ❌ | Icon color (defaults to primary) |
| variation | double | ❌ | Variation percentage (with +/- arrow) |
| isPositive | bool | ❌ | Determines arrow direction (default: true) |
| onTap | VoidCallback | ❌ | Tap handler |

### Example
```dart
KpiCard(
  label: 'Total CO₂ This Month',
  value: '45.2',
  unit: 'kg',
  icon: Icons.leaf,
  iconColor: AppTheme.primaryDarkGreen,
  variation: -12.5,
  isPositive: true,
  onTap: () => print('Tapped'),
);
```

---

## TransactionCard

Displays a single transaction with category, amount, and CO₂ estimate.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| transaction | Transaction | ✅ | Transaction object |
| onTap | VoidCallback | ❌ | Tap on card |
| onEdit | VoidCallback | ❌ | Edit button callback |
| onDelete | VoidCallback | ❌ | Delete button callback |

### Features
- Colored category icon
- Category badge with color
- CO₂ estimate display
- Date on right side
- Popup menu for actions (if callbacks provided)

### Example
```dart
TransactionCard(
  transaction: transaction,
  onTap: () => context.go(Routes.transactionDetailPath(transaction.id)),
  onEdit: () => _editTransaction(transaction),
  onDelete: () => _deleteTransaction(transaction),
);
```

---

## CategoryBadge

Displays a category as a colored badge.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| category | Category | ✅ | Transaction category enum |
| compact | bool | ❌ | Compact size (default: false) |

### Supported Categories
- `Category.transport` - Red (#FF6B6B)
- `Category.food` - Teal (#4ECDC4)
- `Category.shopping` - Yellow (#FFE66D)
- `Category.utilities` - Mint (#95E1D3)
- `Category.entertainment` - Green (#A8E6CF)
- `Category.health` - Pink (#FF8B94)
- `Category.travel` - Blue (#8EC5FC)
- `Category.other` - Gray (#CCCCCC)

### Example
```dart
// Normal size
CategoryBadge(category: Category.food)

// Compact (for tables)
CategoryBadge(category: Category.food, compact: true)
```

---

## ConfirmDialog

Alert dialog for confirmations with optional destructive styling.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| title | String | ✅ | Dialog title |
| message | String | ✅ | Dialog message |
| onConfirm | VoidCallback | ✅ | Confirmation callback |
| confirmText | String | ❌ | Confirm button text (default: "Confirm") |
| cancelText | String | ❌ | Cancel button text (default: "Cancel") |
| isDestructive | bool | ❌ | Red styling for destructive action |

### Example
```dart
showDialog(
  context: context,
  builder: (context) => ConfirmDialog(
    title: 'Delete Transaction',
    message: 'This action cannot be undone.',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    isDestructive: true,
    onConfirm: () => _deleteTransaction(),
  ),
);
```

---

## CarbonDetailAccordion

Expandable accordion showing detailed CO₂ calculation breakdown.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| transaction | Transaction | ✅ | Transaction with CO₂ data |

### Content (Expanded)
- Amount and currency
- Category
- Emission factor
- Calculation formula
- Contextual comparison (e.g., km driven)

### Example
```dart
CarbonDetailAccordion(
  transaction: transaction,
)
```

---

## EmptyState

Placeholder shown when no data is available.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| title | String | ✅ | Main message |
| message | String | ✅ | Description text |
| icon | IconData | ✅ | Display icon |
| action | Widget | ❌ | Optional action button |

### Example
```dart
EmptyState(
  title: 'No Transactions',
  message: 'Start by adding your first transaction.',
  icon: Icons.receipt,
  action: ElevatedButton(
    onPressed: () => context.go(Routes.addTransaction),
    child: const Text('Add Transaction'),
  ),
);
```

---

## LoadingState

Loading indicator with optional message.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| message | String | ❌ | Loading text message |

### Example
```dart
LoadingState(message: 'Loading transactions...')
```

---

## Internal Components (Not exported)

### _SidebarNavItem (Desktop only)
Navigation item for sidebar with selection styling.

### _DrawerNavItem (Mobile only)
Navigation item for drawer.

### _BottomNavItem (Mobile only)
Navigation item for bottom app bar.

### _DetailRow
Generic label-value row for information display.

---

## Theme Constants

Access design system values via `AppTheme`:

### Colors
```dart
AppTheme.primaryDarkGreen      // #0B6B3A
AppTheme.primaryLightGreen     // #3CB371
AppTheme.backgroundNeutral     // #F6F8F7
AppTheme.textDark              // #1F2937
AppTheme.textMedium            // #6B7280
AppTheme.textLight             // #9CA3AF
AppTheme.white                 // #FFFFFF
AppTheme.borderLight           // #E5E7EB
AppTheme.errorRed              // #DC2626
AppTheme.warningOrange         // #F97316
AppTheme.successGreen          // #16A34A
AppTheme.infoBlue              // #0EA5E9
```

### Spacing
```dart
AppTheme.paddingXSmall    // 4px
AppTheme.paddingSmall     // 8px
AppTheme.paddingMedium    // 16px
AppTheme.paddingLarge     // 24px
AppTheme.paddingXLarge    // 32px
```

### Border Radius
```dart
AppTheme.smallCornerRadius    // 8px
AppTheme.cornerRadius         // 12px
AppTheme.largeCornerRadius    // 16px
```

### Shadows
```dart
AppTheme.softShadow       // 0, 2, 8px blur
AppTheme.mediumShadow     // 0, 4, 12px blur
```

---

## Best Practices

### 1. Always Use Theme Spacing
```dart
// ✅ Good
padding: const EdgeInsets.all(AppTheme.paddingMedium),

// ❌ Bad
padding: const EdgeInsets.all(16),
```

### 2. Wrap Cards in Padding
```dart
// Use soft shadow for subtle elevation
boxShadow: const [AppTheme.softShadow],
```

### 3. Responsive Layout
```dart
// Check for desktop/mobile
final isDesktop = MediaQuery.of(context).size.width > 900;

if (isDesktop) {
  // Desktop layout
} else {
  // Mobile layout
}
```

### 4. Handle Async Data
```dart
final dataAsync = ref.watch(dataProvider);

dataAsync.when(
  data: (data) => _buildContent(data),
  loading: () => const LoadingState(),
  error: (error, stack) => _buildErrorState(error),
);
```

### 5. Navigation
```dart
// Use GoRouter for navigation
context.go(Routes.dashboard);
context.go(Routes.transactionDetailPath(id));
context.push(Routes.addTransaction); // Push for back button
```

---

## Accessibility

All components follow WCAG AA standards:

- ✅ Minimum touch target size (44px)
- ✅ Sufficient color contrast (4.5:1 for text)
- ✅ Semantic labels on inputs
- ✅ Focus visible states
- ✅ Keyboard navigation support

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Dec 2024 | Initial implementation |

---

For more information, see [IMPLEMENTATION.md](IMPLEMENTATION.md)
