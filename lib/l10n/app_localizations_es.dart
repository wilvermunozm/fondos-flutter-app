// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'BTG Gestión de Fondos';

  @override
  String get funds => 'Fondos';

  @override
  String get fundDetails => 'Detalles del Fondo';

  @override
  String get subscribe => 'Suscribir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get settings => 'Configuración';

  @override
  String get history => 'Historial';

  @override
  String get transactionHistory => 'Historial de Transacciones';

  @override
  String get all => 'Todos';

  @override
  String get pending => 'Pendiente';

  @override
  String get completed => 'Completado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get noFundsFound => 'No se encontraron fondos';

  @override
  String get errorLoadingFunds => 'Error al cargar fondos';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get fundNotFound => 'Fondo no encontrado';

  @override
  String get errorLoadingFund => 'Error al cargar el fondo';

  @override
  String get performance => 'Rendimiento';

  @override
  String get details => 'Detalles';

  @override
  String get description => 'Descripción';

  @override
  String get risk => 'Riesgo';

  @override
  String get category => 'Categoría';

  @override
  String get minimumInvestment => 'Inversión Mínima';

  @override
  String get managementFee => 'Comisión de Gestión';

  @override
  String get fundSize => 'Tamaño del Fondo';

  @override
  String get annualReturn => 'Rendimiento Anual';

  @override
  String get monthlyReturn => 'Rendimiento Mensual';

  @override
  String get yearToDateReturn => 'Rendimiento del Año a la Fecha';

  @override
  String subscribeToFund(Object name) {
    return 'Suscribir a $name';
  }

  @override
  String get enterAmountToInvest => 'Ingrese el monto a invertir';

  @override
  String get amount => 'Monto';

  @override
  String get amountToInvest => 'Monto a Invertir';

  @override
  String get enterAmount => 'Ingrese monto';

  @override
  String get pleaseEnterAmount => 'Por favor ingrese un monto';

  @override
  String get invalidAmount => 'Monto inválido';

  @override
  String minimumInvestmentRequired(Object amount) {
    return 'Inversión mínima requerida: $amount';
  }

  @override
  String get acceptTermsAndConditions => 'Acepto los términos y condiciones';

  @override
  String get subscriptionSuccessful => 'Suscripción exitosa';

  @override
  String get subscriptionFailed => 'Error en la suscripción';

  @override
  String get noTransactionsFound => 'No se encontraron transacciones';

  @override
  String get errorLoadingTransactions => 'Error al cargar transacciones';

  @override
  String get confirmCancellation => 'Confirmar Cancelación';

  @override
  String get cancelTransactionConfirmation =>
      '¿Está seguro que desea cancelar esta transacción?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get transactionCancelledSuccessfully =>
      'Transacción cancelada exitosamente';

  @override
  String get subscription => 'Suscripción';

  @override
  String get redemption => 'Rescate';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get username => 'Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get usernameRequired => 'El usuario es requerido';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String get welcomeToFunds => 'Bienvenido a BTG Gestión de Fondos';

  @override
  String get testCredentials => 'Credenciales de prueba:';

  @override
  String get mySubscriptions => 'Mis Suscripciones';

  @override
  String get units => 'Unidades';

  @override
  String get unitPrice => 'Precio Unitario';

  @override
  String fundId(Object id) {
    return 'Fondo: $id';
  }

  @override
  String get appearance => 'Apariencia';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get currency => 'Moneda';

  @override
  String get about => 'Acerca de';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkModeDescription => 'Usar tema oscuro en toda la aplicación';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get enableNotifications => 'Habilitar Notificaciones';

  @override
  String get notificationsDescription =>
      'Recibir actualizaciones sobre sus inversiones';

  @override
  String get selectCurrency => 'Seleccionar Moneda';

  @override
  String get aboutApp => 'Acerca de la Aplicación';

  @override
  String get aboutAppDescription =>
      'BTG Gestión de Fondos es una aplicación para gestionar sus inversiones en fondos de BTG Pactual.';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get balance => 'Saldo';

  @override
  String get insufficientBalance => 'Saldo insuficiente';

  @override
  String get subscribeConfirmation =>
      '¿Está seguro que desea suscribirse a este fondo?';

  @override
  String get cancelSubscription => 'Cancelar suscripción';

  @override
  String get confirmCancelSubscription =>
      '¿Está seguro que desea cancelar su suscripción a este fondo?';

  @override
  String get unsubscriptionSuccessful => 'Suscripción cancelada con éxito';

  @override
  String get unsubscriptionFailed => 'Error al cancelar la suscripción';

  @override
  String get yourBalance => 'Su saldo actual';

  @override
  String get requiredAmount => 'Monto requerido';

  @override
  String get noActiveSubscriptions => 'No tiene suscripciones activas';

  @override
  String get subscriptionDate => 'Fecha de suscripción';

  @override
  String get invested => 'Invertido';

  @override
  String get currentValue => 'Valor actual';

  @override
  String get currentBalance => 'Saldo actual';

  @override
  String get errorLoadingUserData => 'Error al cargar datos del usuario';

  @override
  String get errorLoadingSubscriptions => 'Error al cargar suscripciones';

  @override
  String get retry => 'Reintentar';

  @override
  String get noFundsMessage => 'No hay fondos disponibles en este momento';

  @override
  String get noFundsTitle => 'Sin Fondos';

  @override
  String get oneYearReturn => 'Rendimiento a 1 Año';

  @override
  String get minInvestment => 'Inversión Mín.';

  @override
  String get viewDetails => 'Ver Detalles';

  @override
  String get errorLoadingFundData => 'Error al cargar datos del fondo';

  @override
  String get goBack => 'Volver';

  @override
  String get riskLevel => 'Nivel de riesgo';

  @override
  String get type => 'Tipo';
}
