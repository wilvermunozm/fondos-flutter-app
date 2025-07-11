import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../funds/domain/models/fund.dart';
import '../providers/subscription_provider.dart';

class SubscriptionForm extends ConsumerStatefulWidget {
  final Fund fund;
  final VoidCallback onSuccess;

  const SubscriptionForm({
    Key? key,
    required this.fund,
    required this.onSuccess,
  }) : super(key: key);

  @override
  ConsumerState<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends ConsumerState<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionsState = ref.watch(subscriptionProvider);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.of(context).subscribeToFund(widget.fund.name),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          

          _buildFundSummary(),
          SizedBox(height: 24.h),
          

          Text(
            Strings.of(context).amountToInvest,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: Strings.of(context).enterAmount,
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Strings.of(context).pleaseEnterAmount;
              }
              
              final amount = double.tryParse(value);
              if (amount == null) {
                return Strings.of(context).invalidAmount;
              }
              
              if (amount < widget.fund.minInvestment) {
                return Strings.of(context).minimumInvestmentRequired(
                  widget.fund.minInvestment.toString(),
                );
              }
              
              return null;
            },
          ),
          SizedBox(height: 16.h),
          

          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
              ),
              Expanded(
                child: Text(
                  Strings.of(context).acceptTermsAndConditions,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          

          ElevatedButton(
                  onPressed: _termsAccepted ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  child: Text(Strings.of(context).subscribe),
                ),
          
          if (subscriptionsState.hasError)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Text(
                subscriptionsState.error.toString(),
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFundSummary() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.fund.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: widget.fund.type == 'FPV' 
                      ? AppColors.primary.withOpacity(0.1) 
                      : AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  widget.fund.type,
                  style: TextStyle(
                    color: widget.fund.type == 'FPV' 
                        ? AppColors.primary 
                        : AppColors.secondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            Strings.of(context).category,
            widget.fund.category,
          ),
          _buildInfoRow(
            Strings.of(context).risk,
            widget.fund.risk,
            isRisk: true,
          ),
          _buildInfoRow(
            Strings.of(context).minimumInvestment,
            '\$${widget.fund.minInvestment}',
          ),
          _buildInfoRow(
            Strings.of(context).annualReturn,
            '${widget.fund.returnRates.oneYear}%',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false, bool isRisk = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          isRisk 
            ? _buildRiskIndicator(value)
            : Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  color: isHighlighted ? AppColors.success : AppColors.textPrimary,
                ),
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          risk,
          style: TextStyle(
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      
      ref.read(subscriptionProvider.notifier).subscribeToFund(
        fundId: widget.fund.id,
        amount: amount,
      ).then((_) {
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Strings.of(context).subscriptionSuccessful),
            backgroundColor: AppColors.success,
          ),
        );
      });
    }
  }
}
