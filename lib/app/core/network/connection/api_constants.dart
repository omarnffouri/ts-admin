import 'environments.dart';

class ApiConstants {
  ApiConstants._();

  // Environment Configuration
  static const Environment _env = Environment.production;
  static final String kServerURL = 'https://${_env.host}/api/v2/';

  static bool get isDev => _env == Environment.dev;
  static bool get isStaging => _env == Environment.staging;
  static bool get isProduction => _env == Environment.production;

  static final String host = _env.host;

  //! headers
  static const String acceptHeader = "Accept";
  static const String authorizationHeader = "Authorization";
  static const String jsonContentType = "application/json";
  static const String platformHeader = "X-Platform";
  static const String platformHeaderValue = "mobile";
  static String bearer(String token) => "Bearer $token";

  //! auth
  static const String login = "admin/login";
  static const String verifyOtp = "otp/verification";
  static const String userPermissions = "admin/permissions";
  static const String logout = "admin/logout";
  static const String updateVoip = "voip/update";
  static const String realtimeConfiguration = "admin/realtime-configuration";

  //! chat
  static const String getContacts = "chat/contacts";
  static const String getConversations = "chat/conversations";
  static const String getGroupConversations = "chat/groups";
  static const String getGroupHeads = "chat/groups";
  static const String getSubGroup = "chat/conversation/getByGroupName";
  static const String createConversation = "chat/conversation/create";
  static const String getConversationDetails = "chat/conversation";
  static const String postMessage = "chat/conversation/store";
  static const String forwardMessage = "chat/conversation/message/forward";
  static const String editMessage = "chat/conversation/message/update";
  static const String reactMessage = "chat/conversation/react";
  static const String deleteMessage = "chat/conversation/message";
  static const String markMessageAsRead = "chat/conversation/message/read";
  static const String createGroup = "chat/conversation/create/group";
  static const String updateGroupName = "chat/conversation/group/update";
  static const String updateGroupLogo = "chat/conversation/group/logo/update";
  static const String addParticipant =
      "chat/conversation/group/add/participants";
  static const String removeParticipant =
      "chat/conversation/group/remove/participants";
  static const String archiveConversation = "chat/conversation/update";
  static const String updateParticipant =
      "chat/conversation/group/update/participant";
  static const String muteConversations =
      "chat/conversation/notificationSettings";
  static const String buzzMessage = "chat/conversation/send/buzz";
  static const String chatInfoTags = "chat/getTags";
  static const String getMessageNotifications = "chat/get-unread-messages";

  //! clock in out
  static const String checkClockIn = "admin/check-clock";
  static const String clockIn = "admin/clockin";
  static const String clockOut = "admin/clockout";
  static const String clockInOut = "admin/clock-in-out";
  static const String clockInOutHistory = "admin/clock-in-out-history";
  static const String weeklyHours = "admin/get-monthly-timesheet-summary";

  //! profile
  static const String profile = "admin/profile";
  static const String updateProfile = "admin/update/profile";
  static const String updatePassword = "admin/update/password";

  //! request loads
  static const String requestLoads = "admin/load-request";

  // calling
  static const String callEvent = "chat/agora/call";
  static const String placeCall = "chat/agora/call-user";
  static const String declineCall = "chat/agora/call-decline";
  static const String getAgoraToken = "chat/agora/token";
  static const String startCallRecording = "chat/agora/startCallRecording";
  static const String stopCallRecording = "chat/agora/stopCallRecording";

  // invoice payments
  static const String getInvoicePayments = "invoices/payment-requests/history";
  static const String updateInvoicePaymentStatus =
      "invoices/update-payment-request";

  //! leave management
  // new request
  static const String getLeaveTypes = "usermanagement/leave/types";
  static const String remainingLeavesPerCategory =
      "usermanagement/leave/remaining-per-category";
  static const String getSupervisors = "usermanagement/supervisor";
  static const String getAlternativeUsers =
      "usermanagement/leave/get-replacement-employees";
  static const String checkEligibility = "usermanagement/leave/eligibility";
  static const String submitLeaveRequest = "usermanagement/leave/submit";

  // leave requested
  static const String getRequestedLeaves = "usermanagement/leave/requests";

  // manage leave
  static const String getUsersLeaves = "usermanagement/leave/management";
  static const String adminAction = "usermanagement/leave/action";

  // leave history
  static const String getLeaveHistory = "usermanagement/leave/history";

  //! inspection management
  static const String sumbitInspectionRequest = "inspection/create-inspection";

  static const String getInspectionRequests = "inspection/requests";
  static const String getInspectionInspected = "inspection/inspected";

  static const String getInspectionFields = "inspection/checks";

  static const String deleteInspection = "inspection/delete";

  static const String getInspectionDetails = "inspection/details";

  static const String getInspectionDropdown = "inspection/get-lookup";

  static const String createInspectionRequest = "inspection/create-request";

  //! user management
  static const String createAdmin = "usermanagement/user/create";
  static const String updateAdmin = "usermanagement/user/update";
  static const String deleteAdmin = "usermanagement/user/";
  static const String updateAdminsPassword =
      "usermanagement/user/reset/password";
  static const String getAllRules = "usermanagement/all-roles";
  static const String getAllCountries = "usermanagement/countries";
  static const String getAllSupervisors = "usermanagement/user/supervisors";
  static const String getAllDepartments = "usermanagement/departments";
  static const String getAllDesignations = "usermanagement/designations";
  static const String getAllUsers = "usermanagement/users/all";
  static const String upadateUserStatus = "usermanagement/user/update-status";
  static const String getUserOffDays = "usermanagement/user/off-days";

  //! admin forms
  static const String getForms = "admin/forms";
  static const String signForm = "admin/sign-form";
  static const String rejectForm = "admin/applicant-form/reject";

  //! annoucements endpoints
  static const String getAllAnnoucements = "notifications/get-announcements";
  static const String updateAccoucementReadStatus =
      "notifications/mark-announcements-as-read";
  static const String getAllUserTypes = "notifications/get-all-users";
  static const String sendNotification = "notifications/send-notification";

  //
  //! shipment
  static const String getCSDropdowns = "admin/shipment-template/dropdowns";
  static const String createShipmentTemplate = "admin/shipment-template/create";
  static const String getTemplateShipments = "admin/shipment-template/list";
  static const String updateShipmentTemplate =
      "admin/shipment-template/shipment/";
  static const String getAllShipments = "admin/shipments/list";
  static const String getShipmentDetails = "admin/shipment";

  /// GET lists; PUT `<base>/<id>` decides one.
  static const String additionalPayApprovals =
      "admin/paymanagement/additional-pay-approvals";

  //
  //! tasks management
  static const String createTask = "task/create";
  static const String getTasksDropdowns = "task/dropdowns";
  static const String getTasksListing = "task/listings";
  static const String getAllTasks = "task/list/all";
  static const String updateTaskProgress = "task/update/progress";
  static const String updateTask = "task/update";
  static const String updateTaskStatus = "task/update/status";

  //
  // hr
  static const String getApplications = "hr/applicant/list";
  static const String getApplicationDetails = "hr/applicant";

  //
  //
  // storage / drive
  static const String getResources = "drive/get-user-resources";
  static const String getUserForResourceShare = "drive/get-lookup";
  static const String downloadResource = "drive/download-resource";
  static const String revokeResourcePermission =
      "drive/revoke-resource-permission";
  static const String shareResource = "drive/share-resource";
  static const String deleteResource = "drive/delete-resource";
  static const String saveResource = "drive/save-user-resource";
  static const String sendDriveOtp = "drive/send-otp-code";
  static const String verifyDriveOtp = "drive/verify-otp-code";
  static const String revokeAllResourcePermission =
      "drive/revoke-resource-all-permission";

  //
  //! shop management
  // service order
  static const String getServiceOrders =
      "admin/shopmanagement/getServiceOrders";
  static const String getServiceOrderDetails =
      "admin/shopmanagement/getServiceOrderDetails";
  static const String getSericeDropdowns = "admin/shopmanagement/getDropdowns";
  static const String createOrEditServiceOrder =
      "admin/shopmanagement/createServiceOrder";
  static const String getCustomerDetail =
      "admin/shopmanagement/get-customer-detail";
  static const String getCarrierVehicles =
      "admin/shopmanagement/getCarrierVehicles";

  static const String changeServiceOrderStatus =
      "admin/shopmanagement/changeServiceOrderStatus";
  static const String completeServiceOrder =
      "admin/shopmanagement/completeServiceOrder";

  static const String resubmitServiceOrder =
      "admin/shopmanagement/resubmitServiceOrder";
  // inventory
  static const String getInventoryItems =
      "admin/shopmanagement/getInventoryItems";
  static const String createInventory =
      "admin/shopmanagement/createInventoryItem";
  static const String editInventoryItem =
      "admin/shopmanagement/editInventoryItem";
  static const String deleteInventoryItem =
      "admin/shopmanagement/deleteInventoryItem";
  static const String disableInventory =
      "admin/shopmanagement/change-inventory-status";
  //
  // suppliers
  static const String getAllSuppliers = "admin/shopmanagement/getAllSuppliers";
  static const String createSupplier = "admin/shopmanagement/createSupplier";
  static const String editSupplier = "admin/shopmanagement/editSupplier";
  static const String deleteSupplier = "admin/shopmanagement/deleteSupplier";
  static const String disableSupplier =
      "admin/shopmanagement/change-supplier-status";

  //
  //
  // clients
  static const String getAllClients =
      "admin/shopmanagement/get-shop-client-data";
  static const String createOrEditClient =
      "admin/shopmanagement/add-new-shop-client-data";
  static const String disableClient =
      "admin/shopmanagement/change-shop-client-status";

  //
  //
  // technicians
  static const String getAllTechnicians =
      "admin/shopmanagement/getAllTechnicians";
  static const String createTechnician =
      "admin/shopmanagement/createTechnicians";
  static const String editTechnician = "admin/shopmanagement/editTechnicians";
  static const String deleteTechnician =
      "admin/shopmanagement/deleteTechnicians";
  static const String disableTechnician =
      "admin/shopmanagement/change-technician-status";

  //
  // used parts
  // used-part inventories
  static const String usedInventoryUrl =
      "admin/shopmanagement/used-part/shopInventories";
  static const String disableUsedInventory =
      "admin/shopmanagement/used-part/change-inventory-status";

  // used-part suppliers

  static const String usedSupplierUrl =
      "admin/shopmanagement/used-part/supplier";
  static const String disableUsedSupplier =
      "admin/shopmanagement/used-part/change-supplier-status";

  // used-part clients

  static const String usedClientUrl = "admin/shopmanagement/used-part/client";
  static const String disableUsedClient =
      "admin/shopmanagement/used-part/change-shop-client-status";

  // used-part purchase orders
  static const String usedPartPurchaseUrl =
      "admin/shopmanagement/used-part/purchase-orders";
  static const String changeUsedPurchaseOrderStatus =
      "admin/shopmanagement/used-part/update-purchase-order-status";

  //! assets management
  static const String getAllTrucks = "admin/safetymanagement/trucks";
  static const String getSingleTruck = "admin/safetymanagement/truck";
  static const String getTruckDetails = "admin/safetymanagement/truck/overview";
  static const String deleteTruckDocument =
      "admin/safetymanagement/truck/delete-document-request-file";
  static const String deleteTruckOtherDocument =
      "admin/safetymanagement/truck/delete-other-document";
  static const String updateChecklist =
      "admin/safetymanagement/truck/update-checklist";
  static const String createTruckDocumentRequest =
      "admin/safetymanagement/truck/create-new-document";

  static const String uploadDocumentPictures =
      "admin/safetymanagement/truck/upload-pictures";
  static const String updateDocumentRequest =
      "admin/safetymanagement/truck/update-document-request-file";
  static const String updateTruckDocumentExpiration =
      "admin/safetymanagement/truck/save-document-expiration-date";
  static const String uploadPictures =
      "admin/safetymanagement/truck/upload-pictures";
  static const String uninstallTruckDevice =
      "admin/safetymanagement/truck/uninstall-device";

  static const String getTruckCreateData =
      "admin/safetymanagement/trucks/get-create-data";
  static const String createTruck = "admin/safetymanagement/trucks/store";
  static const String updateTruck = "admin/safetymanagement/trucks";

  static const String addNewNote = "admin/safetymanagement/notes/store";
  static const String getAllTeams = "admin/safetymanagement/get-all-teams";
  static const String getDeviceTypes =
      "admin/safetymanagement/preload/device-data";
  static const String getSelectedDevice =
      "admin/safetymanagement/get-selected-device";
  static const String installNewDevice =
      "admin/safetymanagement/install-new-devices";

  static const String getAllTrailers = "admin/safetymanagement/trailers";
  static const String getSingleTrailer = "admin/safetymanagement/trailer";
  static const String getTrailerDetails =
      "admin/safetymanagement/trailer/overview";

  static const String deleteTrailerDocument =
      "admin/safetymanagement/trailer/delete-document-request-file";
  static const String deleteTrailerOtherDocument =
      "admin/safetymanagement/trailer/delete-other-document";
  static const String createTrailerDocumentRequest =
      "admin/safetymanagement/trailer/create-new-document";
  static const String updateTrailerDocumentExpiration =
      "admin/safetymanagement/trailer/save-document-expiration-date";
  static const String uninstallTrailerDevice =
      "admin/safetymanagement/trailer/uninstall-device";

  static const String getTrailerCreateData =
      "admin/safetymanagement/trailers/get-create-data";
  static const String createTrailer = "admin/safetymanagement/trailers/store";
  static const String updateTrailer = "admin/safetymanagement/trailers";

  //! SETTINGS
  static const String updateOtpValue = "otp/settings/enable-or-disable-otp";

  //! OTHER
  static const String getAppConfiguration = "admin/get-app-configuration";
}
