import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/loader_widget.dart';
import '../../../../core/widgets/molecules/error_view.dart';
import '../providers/funds_provider.dart';
import '../../domain/models/fund.dart';

class FundsPage extends ConsumerWidget {
  const FundsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fundsAsync = ref.watch(fundsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).funds),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,

      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(fundsProvider.notifier).refresh(),
        child: fundsAsync.when(
          data: (funds) => _buildFundsList(context, funds),
          loading: () => const LoaderWidget(),
          error: (error, stackTrace) => ErrorView(
            message: error.toString(),
            buttonText: Strings.of(context).retry,
            onRetry: () => ref.read(fundsProvider.notifier).refresh(),
          ),
        ),
      ),
    );
  }

  Widget _buildFundsList(BuildContext context, List<Fund> funds) {
    if (funds.isEmpty) {
      return EmptyStateView(
        title: Strings.of(context).noFundsTitle,
        message: Strings.of(context).noFundsMessage,
        icon: Icons.account_balance_wallet,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: funds.length,
      itemBuilder: (context, index) {
        final fund = funds[index];
        return _FundCard(fund: fund);
      },
    );
  }
}

class _FundCard extends StatelessWidget {
  final Fund fund;

  const _FundCard({Key? key, required this.fund}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => context.push('/fund/${fund.id}'),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fund.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _buildFundTypeBadge(context, fund.type),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                fund.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    context,
                    Strings.of(context).category,
                    fund.category,
                  ),
                  _buildInfoItem(
                    context,
                    Strings.of(context).risk,
                    fund.risk,
                  ),
                  _buildInfoItem(
                    context,
                    Strings.of(context).oneYearReturn,
                    '${(fund.returnRates.oneYear * 100).toStringAsFixed(2)}%',
                    valueColor: fund.returnRates.oneYear >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${Strings.of(context).minInvestment}: ${_formatCurrency(fund.minInvestment, fund.currency)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Strings.of(context).viewDetails,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFundTypeBadge(BuildContext context, String type) {
    final Color backgroundColor = type == 'FPV' ? AppColors.primary : AppColors.secondary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount, String currency) {
    if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(2)}';
    } else {
      return '${amount.toStringAsFixed(0)} $currency';
    }
  }
}
