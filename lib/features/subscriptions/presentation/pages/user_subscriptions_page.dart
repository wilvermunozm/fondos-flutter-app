import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/subscription_provider.dart';
import '../../../funds/presentation/providers/funds_provider.dart';
import '../../../funds/presentation/pages/fund_details_page.dart';
import '../../../auth/presentation/providers/user_provider.dart';

class UserSubscriptionsPage extends ConsumerWidget {
  const UserSubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsAsync = ref.watch(subscriptionProvider);
    final userAsync = ref.watch(userProvider);
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mySubscriptions),
      ),
      body: Column(
        children: [

          userAsync.when(
            data: (user) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.currentBalance,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '\$${user.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('${l10n.errorLoadingUserData}: $error'),
            ),
          ),
          

          Expanded(
            child: subscriptionsAsync.when(
              data: (subscriptions) {
                if (subscriptions.isEmpty) {
                  return Center(
                    child: Text(l10n.noActiveSubscriptions),
                  );
                }
                
                return ListView.builder(
                  itemCount: subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscription = subscriptions[index];
                    
                    return FutureBuilder(
                      future: ref.read(fundByIdProvider(subscription.fundId).future),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Center(child: CircularProgressIndicator()),
                          );
                        }
                        
                        if (snapshot.hasError || !snapshot.hasData) {
                          return ListTile(
                            title: Text('${l10n.errorLoadingFundData}: ${snapshot.error}'),
                          );
                        }
                        
                        final fund = snapshot.data!;
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(fund.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${l10n.invested}: \$${subscription.amount.toStringAsFixed(2)}'),
                                Text(
                                  '${l10n.subscriptionDate}: ${subscription.date.toLocal().toString().split(' ')[0]}',
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () async {
                                final userId = ref.read(currentUserIdProvider);
                                
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(l10n.cancelSubscription),
                                    content: Text(l10n.confirmCancelSubscription),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(l10n.no),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(l10n.yes),
                                      ),
                                    ],
                                  ),
                                );
                                
                                if (confirmed == true) {
                                  try {
                                    await ref.read(subscriptionProvider.notifier).cancelSubscription(subscription.id);
                                    
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
                                        SnackBar(content: Text('${l10n.unsubscriptionFailed}: $e')),
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FundDetailsPage(fundId: fund.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('${l10n.errorLoadingSubscriptions}: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
