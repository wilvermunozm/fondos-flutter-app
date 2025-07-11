import 'package:flutter/material.dart';
import '../atoms/app_button.dart';
import '../../constants/colors.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorView({
    Key? key,
    this.title = 'Error',
    required this.message,
    this.buttonText,
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null && buttonText != null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: AppButton(
                  text: buttonText!,
                  onPressed: onRetry,
                  type: ButtonType.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NetworkErrorView extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorView({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      title: 'Network Error',
      message: 'Unable to connect to the server. Please check your internet connection and try again.',
      buttonText: 'Retry',
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyStateView({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onAction,
    this.icon = Icons.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && buttonText != null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: AppButton(
                  text: buttonText!,
                  onPressed: onAction,
                  type: ButtonType.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
