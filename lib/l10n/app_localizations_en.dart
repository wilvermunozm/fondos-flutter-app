// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BTG Funds Management';

  @override
  String get funds => 'Funds';

  @override
  String get fundDetails => 'Fund Details';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get all => 'All';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noFundsFound => 'No funds found';

  @override
  String get errorLoadingFunds => 'Error loading funds';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get fundNotFound => 'Fund not found';

  @override
  String get errorLoadingFund => 'Error loading fund';

  @override
  String get performance => 'Performance';

  @override
  String get details => 'Details';

  @override
  String get description => 'Description';

  @override
  String get risk => 'Risk';

  @override
  String get category => 'Category';

  @override
  String get minimumInvestment => 'Minimum Investment';

  @override
  String get managementFee => 'Management Fee';

  @override
  String get fundSize => 'Fund Size';

  @override
  String get annualReturn => 'Annual Return';

  @override
  String get monthlyReturn => 'Monthly Return';

  @override
  String get yearToDateReturn => 'Year to Date Return';

  @override
  String subscribeToFund(Object name) {
    return 'Subscribe to $name';
  }

  @override
  String get enterAmountToInvest => 'Enter amount to invest';

  @override
  String get amount => 'Amount';

  @override
  String get amountToInvest => 'Amount to Invest';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String minimumInvestmentRequired(Object amount) {
    return 'Minimum investment required: $amount';
  }

  @override
  String get acceptTermsAndConditions => 'I accept the terms and conditions';

  @override
  String get subscriptionSuccessful => 'Subscription successful';

  @override
  String get subscriptionFailed => 'Subscription failed';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get errorLoadingTransactions => 'Error loading transactions';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get cancelTransactionConfirmation =>
      'Are you sure you want to cancel this transaction?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get transactionCancelledSuccessfully =>
      'Transaction cancelled successfully';

  @override
  String get subscription => 'Subscription';

  @override
  String get redemption => 'Redemption';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get welcomeToFunds => 'Welcome to BTG Funds Management';

  @override
  String get testCredentials => 'Test credentials:';

  @override
  String get mySubscriptions => 'My Subscriptions';

  @override
  String get units => 'Units';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String fundId(Object id) {
    return 'Fund: $id';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get currency => 'Currency';

  @override
  String get about => 'About';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDescription => 'Use dark theme throughout the app';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get notificationsDescription =>
      'Receive updates about your investments';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get aboutApp => 'About App';

  @override
  String get aboutAppDescription =>
      'BTG Funds Management is an application for managing your investments in BTG Pactual funds.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get balance => 'Balance';

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get subscribeConfirmation =>
      'Are you sure you want to subscribe to this fund?';

  @override
  String get cancelSubscription => 'Cancel subscription';

  @override
  String get confirmCancelSubscription =>
      'Are you sure you want to cancel your subscription to this fund?';

  @override
  String get unsubscriptionSuccessful => 'Unsubscription successful';

  @override
  String get unsubscriptionFailed => 'Unsubscription failed';

  @override
  String get yourBalance => 'Your current balance';

  @override
  String get requiredAmount => 'Required amount';

  @override
  String get noActiveSubscriptions => 'No active subscriptions';

  @override
  String get subscriptionDate => 'Subscription date';

  @override
  String get invested => 'Invested';

  @override
  String get currentValue => 'Current value';

  @override
  String get currentBalance => 'Current balance';

  @override
  String get errorLoadingUserData => 'Error loading user data';

  @override
  String get errorLoadingSubscriptions => 'Error loading subscriptions';

  @override
  String get retry => 'Retry';

  @override
  String get noFundsMessage => 'No funds available at the moment';

  @override
  String get noFundsTitle => 'No Funds';

  @override
  String get oneYearReturn => '1 Year Return';

  @override
  String get minInvestment => 'Min. Investment';

  @override
  String get viewDetails => 'View Details';

  @override
  String get errorLoadingFundData => 'Error loading fund data';

  @override
  String get goBack => 'Go back';

  @override
  String get riskLevel => 'Risk level';

  @override
  String get type => 'Type';
}
