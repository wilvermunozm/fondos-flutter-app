import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/loader_widget.dart';
import '../../../funds/domain/models/fund.dart';
import '../../../funds/presentation/providers/funds_provider.dart';
import '../widgets/subscription_form.dart';

class SubscribePage extends ConsumerWidget {
  final String fundId;

  const SubscribePage({
    Key? key,
    required this.fundId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fundState = ref.watch(fundByIdProvider(fundId));

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).subscribe),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: fundState.when(
        data: (fund) {
          if (fund == null) {
            return Center(
              child: Text(Strings.of(context).fundNotFound),
            );
          }
          
          return _buildContent(context, fund);
        },
        loading: () => const Center(child: FullScreenLoader()),
        error: (error, _) => Center(
          child: Text(
            '${Strings.of(context).errorLoadingFund}: $error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Fund fund) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SubscriptionForm(
        fund: fund,
        onSuccess: () => context.pop(),
      ),
    );
  }
}
