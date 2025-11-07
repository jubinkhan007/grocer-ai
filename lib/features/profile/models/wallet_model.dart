// lib/features/profile/models/wallet_model.dart
class Wallet {
  final String balance;
  final String usableBalance;

  Wallet({required this.balance, required this.usableBalance});

  // --- MODIFIED ---
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      // Use .toString() to convert the incoming number (double/int) to a String
      balance: (json['balance'] ?? '0.00').toString(),
      usableBalance: (json['usable_balance'] ?? '0.00').toString(),
    );
  }
// --- END MODIFIED ---
}