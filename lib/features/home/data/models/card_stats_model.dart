import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CardStatsModel extends Equatable {
  final String title;
  final String amount;
  final String percentage;
  final IconData icon;

  const CardStatsModel({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.icon,
  });

  @override
  List<Object?> get props => [title, amount, percentage, icon];
}

final List<CardStatsModel> dummyCardStats = [
  const CardStatsModel(
    title: 'Total Sales',
    amount: '12,450.00 EGP',
    percentage: '+15.5%',
    icon: Icons.trending_up,
  ),
  const CardStatsModel(
    title: 'Total Orders',
    amount: '1,284',
    percentage: '+8.2%',
    icon: Icons.shopping_cart,
  ),
  const CardStatsModel(
    title: 'Total Customers',
    amount: '3,421',
    percentage: '+12.3%',
    icon: Icons.people,
  ),
  const CardStatsModel(
    title: 'Average Order Value',
    amount: '96.50 EGP',
    percentage: '+3.1%',
    icon: Icons.receipt,
  ),
];
