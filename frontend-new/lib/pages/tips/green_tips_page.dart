import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';

class GreenTipsPage extends StatelessWidget {
  const GreenTipsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _tips = const [
    {
      'icon': Icons.directions_bus,
      'title': 'Use Public Transport',
      'description':
          'Reduce your carbon footprint by 75% compared to driving alone.',
      'impact': 'Save ~5 kg CO₂/month',
    },
    {
      'icon': Icons.local_grocery_store,
      'title': 'Shop Local',
      'description':
          'Buy from local merchants to reduce transportation emissions.',
      'impact': 'Save ~2.5 kg CO₂/month',
    },
    {
      'icon': Icons.description,
      'title': 'Go Paperless',
      'description':
          'Switch to digital statements and receipts to save trees and resources.',
      'impact': 'Save ~0.5 kg CO₂/month',
    },
    {
      'icon': Icons.energy_savings_leaf,
      'title': 'Choose Organic',
      'description':
          'Organic products require less energy and chemicals to produce.',
      'impact': 'Save ~3 kg CO₂/month',
    },
    {
      'icon': Icons.ev_station,
      'title': 'Switch to Electric Vehicle',
      'description':
          'Electric vehicles produce 50% less emissions over their lifetime.',
      'impact': 'Save ~15 kg CO₂/month',
    },
    {
      'icon': Icons.home,
      'title': 'Energy-Efficient Home',
      'description':
          'Use LED lights, insulate properly, and optimize heating/cooling.',
      'impact': 'Save ~8 kg CO₂/month',
    },
    {
      'icon': Icons.shopping_bag,
      'title': 'Buy Second-Hand',
      'description':
          'Reduce manufacturing emissions by purchasing pre-owned items.',
      'impact': 'Save ~4 kg CO₂/month',
    },
    {
      'icon': Icons.water_drop,
      'title': 'Conserve Water',
      'description':
          'Shorter showers and fixing leaks reduce water treatment emissions.',
      'impact': 'Save ~1.5 kg CO₂/month',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Tips'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Intro Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFF10B981),
                    size: 32,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Small Actions, Big Impact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Every action counts. Implement these tips to reduce your carbon footprint and build a sustainable future.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF10B981),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Tips List
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1 / 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _tips.length,
              itemBuilder: (context, index) {
                final tip = _tips[index];
                return _buildTipCard(
                  icon: tip['icon'],
                  title: tip['title'],
                  description: tip['description'],
                  impact: tip['impact'],
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required String impact,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF10B981),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GlobalColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: GlobalColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              impact,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
