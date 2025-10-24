// lib/features/order/views/_order_models.dart
class OrderItem {
  final int id;
  final String emoji;
  final String title;
  final String pricePer;
  final String price;
  int qty;

  OrderItem({
    required this.id,
    required this.emoji,
    required this.title,
    required this.pricePer,
    required this.price,
    this.qty = 3,
  });
}

// Quick mock dataset (aligned with your Figma text)
final mockItems = <OrderItem>[
  OrderItem(id: 1, emoji: '🍜', title: 'Royal Basmati Rice', pricePer: '\$8.75/kg', price: '\$26.25'),
  OrderItem(id: 2, emoji: '🧴', title: 'Sunny Valley Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 3, emoji: '🧺', title: 'Golden Harvest Quinoa', pricePer: '\$4.29/kg', price: '\$42.7'),
  OrderItem(id: 4, emoji: '🍯', title: 'Maple Grove Honey', pricePer: '\$12.50/kg', price: '\$34.7'),
  OrderItem(id: 5, emoji: '🧂', title: 'Emerald Isle Sea Salt', pricePer: '\$5.50/kg', price: '\$28.3'),
  OrderItem(id: 6, emoji: '🥤', title: 'Crisp Apple Juice', pricePer: '\$3.49/litter', price: '\$31.4'),
  OrderItem(id: 7, emoji: '☕️', title: 'Mountain Coffee Beans', pricePer: '\$12.99/kg', price: '\$19.6'),
];

final related = <OrderItem>[
  OrderItem(id: 21, emoji: '🧴', title: 'Mediterranean Breeze Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 22, emoji: '🧴', title: 'Verdant Valley Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 23, emoji: '🧴', title: 'Golden Fields Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
  OrderItem(id: 24, emoji: '🧴', title: 'Maple Leaf Olive Oil', pricePer: '\$75.30/litter', price: '\$23.8'),
];
