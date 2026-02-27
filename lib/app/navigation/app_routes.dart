class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const loginDetails = '/login/details';
  static const registration = '/registration';
  static const registrationDocuments = '/registration/documents';

  static const home = '/home';
  static const homeStatus = '/home/status';
  static const homeStartWorkday = '/home/start-workday';
  static const homeRoutes = '/home/routes';
  static const homeOfflineQueue = '/home/offline-queue';
  static const homeProfile = '/home/profile';
  static const homeVehicle = '/home/vehicle';
  static const homeDocuments = '/home/documents';
  static const homeSecurity = '/home/security';
  static const homeMessages = '/home/messages';
  static const homeQr = '/home/qr';

  static String routeDetails(String routeId) => '$homeRoutes/$routeId';

  static String routeMap(String routeId) => '${routeDetails(routeId)}/map';

  static String stopDetails(String routeId, String stopId) =>
      '${routeDetails(routeId)}/stops/$stopId';

  static String stopPickup(String routeId, String stopId) =>
      '${stopDetails(routeId, stopId)}/pickup';

  static String stopDelivery(String routeId, String stopId) =>
      '${stopDetails(routeId, stopId)}/delivery';

  static String stopDeliveryPod(String routeId, String stopId) =>
      '${stopDelivery(routeId, stopId)}/pod';

  static String stopDeliveryFailed(String routeId, String stopId) =>
      '${stopDelivery(routeId, stopId)}/failed';

  static bool isInSection(String location, String sectionPath) =>
      location == sectionPath || location.startsWith('$sectionPath/');
}
