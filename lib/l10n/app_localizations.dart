import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BTG Funds Management'**
  String get appTitle;

  /// No description provided for @funds.
  ///
  /// In en, this message translates to:
  /// **'Funds'**
  String get funds;

  /// No description provided for @fundDetails.
  ///
  /// In en, this message translates to:
  /// **'Fund Details'**
  String get fundDetails;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noFundsFound.
  ///
  /// In en, this message translates to:
  /// **'No funds found'**
  String get noFundsFound;

  /// No description provided for @errorLoadingFunds.
  ///
  /// In en, this message translates to:
  /// **'Error loading funds'**
  String get errorLoadingFunds;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @fundNotFound.
  ///
  /// In en, this message translates to:
  /// **'Fund not found'**
  String get fundNotFound;

  /// No description provided for @errorLoadingFund.
  ///
  /// In en, this message translates to:
  /// **'Error loading fund'**
  String get errorLoadingFund;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get risk;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @minimumInvestment.
  ///
  /// In en, this message translates to:
  /// **'Minimum Investment'**
  String get minimumInvestment;

  /// No description provided for @managementFee.
  ///
  /// In en, this message translates to:
  /// **'Management Fee'**
  String get managementFee;

  /// No description provided for @fundSize.
  ///
  /// In en, this message translates to:
  /// **'Fund Size'**
  String get fundSize;

  /// No description provided for @annualReturn.
  ///
  /// In en, this message translates to:
  /// **'Annual Return'**
  String get annualReturn;

  /// No description provided for @monthlyReturn.
  ///
  /// In en, this message translates to:
  /// **'Monthly Return'**
  String get monthlyReturn;

  /// No description provided for @yearToDateReturn.
  ///
  /// In en, this message translates to:
  /// **'Year to Date Return'**
  String get yearToDateReturn;

  /// No description provided for @subscribeToFund.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {name}'**
  String subscribeToFund(Object name);

  /// No description provided for @enterAmountToInvest.
  ///
  /// In en, this message translates to:
  /// **'Enter amount to invest'**
  String get enterAmountToInvest;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountToInvest.
  ///
  /// In en, this message translates to:
  /// **'Amount to Invest'**
  String get amountToInvest;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @minimumInvestmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum investment required: {amount}'**
  String minimumInvestmentRequired(Object amount);

  /// No description provided for @acceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms and conditions'**
  String get acceptTermsAndConditions;

  /// No description provided for @subscriptionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Subscription successful'**
  String get subscriptionSuccessful;

  /// No description provided for @subscriptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Subscription failed'**
  String get subscriptionFailed;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @errorLoadingTransactions.
  ///
  /// In en, this message translates to:
  /// **'Error loading transactions'**
  String get errorLoadingTransactions;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @cancelTransactionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this transaction?'**
  String get cancelTransactionConfirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @transactionCancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Transaction cancelled successfully'**
  String get transactionCancelledSuccessfully;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @redemption.
  ///
  /// In en, this message translates to:
  /// **'Redemption'**
  String get redemption;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @welcomeToFunds.
  ///
  /// In en, this message translates to:
  /// **'Welcome to BTG Funds Management'**
  String get welcomeToFunds;

  /// No description provided for @testCredentials.
  ///
  /// In en, this message translates to:
  /// **'Test credentials:'**
  String get testCredentials;

  /// No description provided for @mySubscriptions.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @fundId.
  ///
  /// In en, this message translates to:
  /// **'Fund: {id}'**
  String fundId(Object id);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme throughout the app'**
  String get darkModeDescription;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @notificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive updates about your investments'**
  String get notificationsDescription;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'BTG Funds Management is an application for managing your investments in BTG Pactual funds.'**
  String get aboutAppDescription;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientBalance;

  /// No description provided for @subscribeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to subscribe to this fund?'**
  String get subscribeConfirmation;

  /// No description provided for @cancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get cancelSubscription;

  /// No description provided for @confirmCancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your subscription to this fund?'**
  String get confirmCancelSubscription;

  /// No description provided for @unsubscriptionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Unsubscription successful'**
  String get unsubscriptionSuccessful;

  /// No description provided for @unsubscriptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Unsubscription failed'**
  String get unsubscriptionFailed;

  /// No description provided for @yourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your current balance'**
  String get yourBalance;

  /// No description provided for @requiredAmount.
  ///
  /// In en, this message translates to:
  /// **'Required amount'**
  String get requiredAmount;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions'**
  String get noActiveSubscriptions;

  /// No description provided for @subscriptionDate.
  ///
  /// In en, this message translates to:
  /// **'Subscription date'**
  String get subscriptionDate;

  /// No description provided for @invested.
  ///
  /// In en, this message translates to:
  /// **'Invested'**
  String get invested;

  /// No description provided for @currentValue.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get currentValue;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalance;

  /// No description provided for @errorLoadingUserData.
  ///
  /// In en, this message translates to:
  /// **'Error loading user data'**
  String get errorLoadingUserData;

  /// No description provided for @errorLoadingSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Error loading subscriptions'**
  String get errorLoadingSubscriptions;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noFundsMessage.
  ///
  /// In en, this message translates to:
  /// **'No funds available at the moment'**
  String get noFundsMessage;

  /// No description provided for @noFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Funds'**
  String get noFundsTitle;

  /// No description provided for @oneYearReturn.
  ///
  /// In en, this message translates to:
  /// **'1 Year Return'**
  String get oneYearReturn;

  /// No description provided for @minInvestment.
  ///
  /// In en, this message translates to:
  /// **'Min. Investment'**
  String get minInvestment;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @errorLoadingFundData.
  ///
  /// In en, this message translates to:
  /// **'Error loading fund data'**
  String get errorLoadingFundData;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk level'**
  String get riskLevel;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
