import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/fund.dart';
import '../providers/funds_provider.dart';
import 'fund_details_page.dart';
import '../../../auth/presentation/providers/user_provider.dart';

class FundsListPage extends ConsumerWidget {
  const FundsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fundsAsync = ref.watch(fundsProvider);
    final userAsync = ref.watch(userProvider);
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG Funds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {

              ref.invalidate(fundsProvider);
              ref.invalidate(userProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [

          userAsync.when(
            data: (user) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.currentBalance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${user.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.red.shade100,
              child: Text(
                '${l10n.errorLoadingUserData}: $error',
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          ),
          

          Expanded(
            child: fundsAsync.when(
              data: (funds) => ListView.builder(
                itemCount: funds.length,
                itemBuilder: (context, index) {
                  final fund = funds[index];
                  return FundCard(fund: fund);
                },
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${error.toString()}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FundCard extends StatelessWidget {
  final Fund fund;

  const FundCard({Key? key, required this.fund}) : super(key: key);

  Color _getRiskColor() {
    switch (fund.risk.toLowerCase()) {
      case 'bajo':
        return Colors.green.shade700;
      case 'medio':
        return Colors.orange.shade700;
      case 'alto':
        return Colors.red.shade700;
      case 'low':
        return Colors.green.shade700;
      case 'medium':
        return Colors.orange.shade700;
      case 'high':
        return Colors.red.shade700;
      default:
        return Colors.blue.shade700;
    }
  }
  
  Widget _buildRiskIndicator() {
    Color color = _getRiskColor();
    String riskText = fund.risk;
    
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          riskText,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundDetailsPage(fundId: fund.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fund.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildRiskIndicator(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: l10n.type,
                      value: fund.type,
                      icon: Icons.category,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: l10n.minimumInvestment,
                      value: '\$${fund.minInvestment}',
                      icon: Icons.attach_money,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: l10n.managementFee,
                      value: '${fund.managementFee}%',
                      icon: Icons.percent,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: l10n.performance,
                      value: '${fund.performance}%',
                      icon: Icons.trending_up,
                      valueColor: fund.performance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
