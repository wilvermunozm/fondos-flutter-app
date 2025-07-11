import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/funds_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../subscriptions/presentation/providers/subscription_provider.dart';
import '../../../subscriptions/domain/models/subscription.dart';
import '../../domain/models/fund.dart';

class FundDetailsPage extends ConsumerWidget {
  final String fundId;

  const FundDetailsPage({
    Key? key,
    required this.fundId,
  }) : super(key: key);

  Widget _buildInfoRow(String label, String value, {bool isRisk = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isRisk 
              ? _buildRiskIndicator(value)
              : Text(value),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRiskIndicator(String risk) {
    Color color;
    
    switch (risk.toLowerCase()) {
      case 'bajo':
      case 'low':
        color = Colors.green.shade700;
        break;
      case 'medio':
      case 'medium':
        color = Colors.orange.shade700;
        break;
      case 'alto':
      case 'high':
        color = Colors.red.shade700;
        break;
      default:
        color = Colors.blue.shade700;
    }
    
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
        const SizedBox(width: 8),
        Text(
          risk,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Future<void> _showSubscriptionDialog(BuildContext context, WidgetRef ref, double minInvestment, String fundName) async {
    final l10n = AppLocalizations.of(context)!;
    final textController = TextEditingController(text: minInvestment.toString());
    
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.subscribeToFund(fundName)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.enterAmountToInvest),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.amount,
                  prefixText: '\$',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.subscribe),
              onPressed: () {
                final amount = double.tryParse(textController.text) ?? 0;
                if (amount < minInvestment) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.minimumInvestmentRequired}: \$${minInvestment}')),
                  );
                  return;
                }
                Navigator.of(context).pop(amount);
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null) {
        final amount = value;
        
        try {
          await ref.read(subscriptionProvider.notifier).subscribeToFund(
            fundId: fundId,
            amount: amount,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.subscriptionSuccessful)),
            );
            // La actualización ya se maneja en el provider
            ref.invalidate(userProvider);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.subscriptionFailed}: ${e.toString()}')),
            );
          }
        }
      }
    });
  }
  
  Future<void> _showUnsubscribeDialog(BuildContext context, WidgetRef ref, String subscriptionId) async {
    final l10n = AppLocalizations.of(context)!;
    
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.cancelSubscription),
          content: Text(l10n.confirmCancelSubscription),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.no),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(l10n.yes),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await ref.read(subscriptionProvider.notifier).cancelSubscription(subscriptionId);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.unsubscriptionSuccessful)),
            );
            // La actualización ya se maneja en el provider
            ref.invalidate(userProvider);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.unsubscriptionFailed}: ${e.toString()}')),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fundAsync = ref.watch(fundByIdProvider(fundId));
    final userAsync = ref.watch(userProvider);
    final subscriptionsAsync = ref.watch(subscriptionProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fundDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: fundAsync.when(
        data: (fund) {

          bool isSubscribed = false;
          String? subscriptionId;
          
          if (userAsync.hasValue && subscriptionsAsync.hasValue) {
            final subscriptions = subscriptionsAsync.value!;
            
            final subscription = subscriptions.firstWhere(
              (s) => s.fundId == fundId && s.status == 'active',
              orElse: () => Subscription(
                id: '', userId: '', fundId: '', fundName: '', amount: 0,
                date: DateTime.now(), status: 'inactive', fund: null
              ),
            );
            
            isSubscribed = subscription.id.isNotEmpty;
            subscriptionId = subscription.id;
          }
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      fund.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(l10n.category, fund.category),
                  _buildInfoRow(l10n.type, fund.type),
                  _buildInfoRow(l10n.riskLevel, fund.risk, isRisk: true),
                  _buildInfoRow(l10n.currency, fund.currency),
                  _buildInfoRow(l10n.minimumInvestment, '${fund.minInvestment}'),
                  _buildInfoRow(l10n.managementFee, '${fund.managementFee}%'),
                  
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.description}:',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(fund.description),
                  
                  const SizedBox(height: 20),
                  

                  userAsync.when(
                    data: (user) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(l10n.yourBalance, '\$${user.balance.toStringAsFixed(2)}'),
                        const SizedBox(height: 16),
                        Center(
                          child: isSubscribed
                              ? ElevatedButton(
                                  onPressed: () => _showUnsubscribeDialog(context, ref, subscriptionId!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text(l10n.cancelSubscription),
                                )
                              : ElevatedButton(
                                  onPressed: user.balance >= fund.minInvestment
                                      ? () => _showSubscriptionDialog(context, ref, fund.minInvestment, fund.name)
                                      : null,
                                  child: Text(l10n.subscribeToFund(fund.name)),
                                ),
                        ),
                        if (!isSubscribed && user.balance < fund.minInvestment)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                l10n.insufficientBalance,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('${l10n.errorLoadingUserData}: $error'),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.goBack),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text('Error: $error', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.goBack),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
