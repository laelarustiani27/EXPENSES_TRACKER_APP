import 'dart:core';
import 'package:flutter/material.dart';

enum TransactionType { income, expense }

enum TransactionCategory { travel, food, shopping, entertainment, bills, other }

class TransactionModel {
  final String id;
  final TransactionCategory category;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final IconData icon;

  TransactionModel({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.icon,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  String get title => category.name;
  String get subtitle => description;

  String get formattedAmount {
    final sign = isIncome ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(0)}';
  }

  static List<TransactionModel> getSampleTransactions() {
    final now = DateTime.now();
    return [
      TransactionModel(
        id: '1',
        category: TransactionCategory.travel,
        description: 'Indigo ticket',
        amount: 100,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 1)),
        icon: Icons.flight,
      ),
      TransactionModel(
        id: '2',
        category: TransactionCategory.food,
        description: 'Groceries',
        amount: 50,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 2)),
        icon: Icons.restaurant,
      ),
      TransactionModel(
        id: '3',
        category: TransactionCategory.entertainment,
        description: 'Movie ticket',
        amount: 25,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 3)),
        icon: Icons.movie,
      ),
    ];
  }

  static Map<String, double> calculateTotals(
    List<TransactionModel> transactions,
  ) {
    double income = 0;
    double expense = 0;

    for (final t in transactions) {
      t.isIncome ? income += t.amount : expense += t.amount;
    }

    return {'income': income, 'expense': expense, 'balance': income - expense};
  }

  static Iterable<TransactionModel> filterByType(
    List<TransactionModel> transactions,
    TransactionType type,
  ) {
    return transactions.where((t) => t.type == type);
  }

  static Iterable<TransactionModel> filterByMonth(
    List<TransactionModel> transactions,
    int month,
    int year,
  ) {
    return transactions.where(
      (t) => t.date.month == month && t.date.year == year,
    );
  }

  TransactionModel copyWith({
    String? id,
    TransactionCategory? category,
    String? description,
    double? amount,
    TransactionType? type,
    DateTime? date,
    IconData? icon,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'description': description,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
      'icon': icon.codePoint,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      type:
          json['type'] == 'income'
              ? TransactionType.income
              : TransactionType.expense,
      date: DateTime.parse(json['date']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}
