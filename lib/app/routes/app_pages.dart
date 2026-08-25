import 'package:get/get.dart';

import '../modules/shipment/presentation/additional_pay/bindings/additional_pay_binding.dart';
import '../modules/shipment/presentation/additional_pay/views/additional_pay_view.dart';
import '../modules/annoucments/presentation/announcements/bindings/annoucments_binding.dart';
import '../modules/annoucments/presentation/announcements/views/annoucments_view.dart';
import '../modules/annoucments/presentation/create_announcement/bindings/create_announcement_binding.dart';
import '../modules/annoucments/presentation/create_announcement/views/create_announcement_view.dart';
import '../modules/assets_management/presentation/create_trailer/bindings/create_trailer_binding.dart';
import '../modules/assets_management/presentation/create_trailer/views/create_trailer_view.dart';
import '../modules/assets_management/presentation/create_truck/bindings/create_truck_binding.dart';
import '../modules/assets_management/presentation/create_truck/views/create_truck_view.dart';
import '../modules/assets_management/presentation/safety/bindings/safety_binding.dart';
import '../modules/assets_management/presentation/safety/views/safety_view.dart';
import '../modules/assets_management/presentation/trailer_details/bindings/trailer_details_binding.dart';
import '../modules/assets_management/presentation/trailer_details/views/trailer_details_view.dart';
import '../modules/assets_management/presentation/trailers/bindings/trailers_binding.dart';
import '../modules/assets_management/presentation/trailers/views/trailers_view.dart';
import '../modules/assets_management/presentation/truck_details/bindings/truck_details_binding.dart';
import '../modules/assets_management/presentation/truck_details/views/truck_details_view.dart';
import '../modules/assets_management/presentation/trucks/bindings/trucks_binding.dart';
import '../modules/assets_management/presentation/trucks/views/trucks_view.dart';
import '../modules/auth/presentation/change_password/bindings/change_password_binding.dart';
import '../modules/auth/presentation/change_password/views/change_password_view.dart';
import '../modules/auth/presentation/login/bindings/login_binding.dart';
import '../modules/auth/presentation/login/views/login_view.dart';
import '../modules/auth/presentation/otp/bindings/otp_binding.dart';
import '../modules/auth/presentation/otp/views/otp_view.dart';
import '../modules/auth/presentation/signup/bindings/signup_binding.dart';
import '../modules/auth/presentation/signup/views/signup_view.dart';
import '../modules/chat/presentation/add_admin_participants/bindings/add_admin_participants_binding.dart';
import '../modules/chat/presentation/add_admin_participants/views/add_admin_participants_view.dart';
import '../modules/chat/presentation/add_driver_participants/bindings/add_driver_participants_binding.dart';
import '../modules/chat/presentation/add_driver_participants/views/add_driver_participants_view.dart';
import '../modules/chat/presentation/chat_theme_settings/bindings/chat_theme_settings_binding.dart';
import '../modules/chat/presentation/chat_theme_settings/views/chat_theme_settings_view.dart';
import '../modules/chat/presentation/contacts/bindings/contacts_binding.dart';
import '../modules/chat/presentation/contacts/views/contacts_view.dart';
import '../modules/chat/presentation/conversations/bindings/conversations_binding.dart';
import '../modules/chat/presentation/conversations/views/conversations_view.dart';
import '../modules/chat/presentation/create_group/bindings/create_group_binding.dart';
import '../modules/chat/presentation/create_group/views/create_group_view.dart';
import '../modules/chat/presentation/group_conversations/bindings/group_conversations_binding.dart';
import '../modules/chat/presentation/group_conversations/views/group_conversations_view.dart';
import '../modules/chat/presentation/group_inner_conversations/bindings/group_inner_conversations_binding.dart';
import '../modules/chat/presentation/group_inner_conversations/views/group_inner_conversations_view.dart';
import '../modules/chat/presentation/group_settings/bindings/group_settings_binding.dart';
import '../modules/chat/presentation/group_settings/views/group_settings_view.dart';
import '../modules/chat/presentation/message_notifications/bindings/message_notifications_binding.dart';
import '../modules/chat/presentation/message_notifications/views/message_notifications_view.dart';
import '../modules/chat/presentation/oto_conversations/bindings/oto_conversations_binding.dart';
import '../modules/chat/presentation/oto_conversations/views/oto_conversations_view.dart';
import '../modules/chat_detail/presentation/bindings/chat_detail_binding.dart';
import '../modules/chat_detail/presentation/views/chat_detail_view.dart';
import '../modules/clock-in-out/presentation/bindings/clock_in_out_binding.dart';
import '../modules/clock-in-out/presentation/views/clock_in_out_view.dart';
import '../modules/forms/presintation/form_detail_view/bindings/form_detail_view_binding.dart';
import '../modules/forms/presintation/form_detail_view/views/form_detail_view_view.dart';
import '../modules/forms/presintation/forms/bindings/forms_binding.dart';
import '../modules/forms/presintation/forms/views/forms_view.dart';
import '../modules/forward_message/bindings/forward_message_binding.dart';
import '../modules/forward_message/views/forward_message_view.dart';
import '../modules/hr/presentation/application_detail_view/bindings/application_detail_view_binding.dart';
import '../modules/hr/presentation/application_detail_view/views/application_detail_view_view.dart';
import '../modules/hr/presentation/applications/bindings/applications_binding.dart';
import '../modules/hr/presentation/applications/views/applications_view.dart';
import '../modules/inspection_management/presintation/create_inspection_request/bindings/create_inspection_request_binding.dart';
import '../modules/inspection_management/presintation/create_inspection_request/views/create_inspection_request_view.dart';
import '../modules/inspection_management/presintation/driver_inspection/bindings/driver_inspection_binding.dart';
import '../modules/inspection_management/presintation/driver_inspection/views/driver_inspection_view.dart';
import '../modules/inspection_management/presintation/inspection_details/bindings/inspection_details_binding.dart';
import '../modules/inspection_management/presintation/inspection_details/views/inspection_details_view.dart';
import '../modules/inspection_management/presintation/new_inspection/bindings/new_inspection_binding.dart';
import '../modules/inspection_management/presintation/new_inspection/views/new_inspection_view.dart';
import '../modules/inspection_management/presintation/truck_trailer_inspection/bindings/truck_trailer_inspection_binding.dart';
import '../modules/inspection_management/presintation/truck_trailer_inspection/views/truck_trailer_inspection_view.dart';
import '../modules/invoices_management/presentation/invoice_payment_requests/bindings/invoice_payment_requests_binding.dart';
import '../modules/invoices_management/presentation/invoice_payment_requests/views/invoice_payment_requests_view.dart';
import '../modules/invoices_management/presentation/invoice_payments_revert/bindings/invoice_payments_revert_binding.dart';
import '../modules/invoices_management/presentation/invoice_payments_revert/views/invoice_payments_revert_view.dart';
import '../modules/leave_management/presentation/leave_requested/bindings/leave_requested_binding.dart';
import '../modules/leave_management/presentation/leave_requested/views/leave_requested_view.dart';
import '../modules/leave_management/presentation/leave_requests_history/bindings/leave_requests_history_binding.dart';
import '../modules/leave_management/presentation/leave_requests_history/views/leave_requests_history_view.dart';
import '../modules/leave_management/presentation/manage_leave_requests/bindings/manage_leave_requests_binding.dart';
import '../modules/leave_management/presentation/manage_leave_requests/views/manage_leave_requests_view.dart';
import '../modules/leave_management/presentation/new_leave_request/bindings/new_leave_request_binding.dart';
import '../modules/leave_management/presentation/new_leave_request/views/new_leave_request_view.dart';
import '../modules/main_screen/bindings/main_screen_binding.dart';
import '../modules/main_screen/views/main_screen_view.dart';
import '../modules/media_picker_previewer/bindings/media_picker_previewer_binding.dart';
import '../modules/media_picker_previewer/views/media_picker_previewer_view.dart';
import '../modules/menu_page/presentation/menu/bindings/menu_page_binding.dart';
import '../modules/menu_page/presentation/menu/views/menu_page_view.dart';
import '../modules/menu_page/presentation/settings/bindings/settings_binding.dart';
import '../modules/menu_page/presentation/settings/views/settings_view.dart';
import '../modules/request_loads/presentation/bindings/request_loads_binding.dart';
import '../modules/request_loads/presentation/views/request_loads_view.dart';
import '../modules/shipment/presentation/create_shipment/bindings/create_shipment_binding.dart';
import '../modules/shipment/presentation/create_shipment/views/create_shipment_view.dart';
import '../modules/shipment/presentation/shipment_details/bindings/shipment_details_binding.dart';
import '../modules/shipment/presentation/shipment_details/views/shipment_details_view.dart';
import '../modules/shipment/presentation/shipments/bindings/shipments_binding.dart';
import '../modules/shipment/presentation/shipments/views/shipments_view.dart';
import '../modules/shop_management/presentation/create_edit_client/bindings/create_edit_client_binding.dart';
import '../modules/shop_management/presentation/create_edit_client/views/create_edit_client_view.dart';
import '../modules/shop_management/presentation/create_edit_inventory/bindings/create_edit_inventory_binding.dart';
import '../modules/shop_management/presentation/create_edit_inventory/views/create_edit_inventory_view.dart';
import '../modules/shop_management/presentation/create_edit_supplier/bindings/create_edit_supplier_binding.dart';
import '../modules/shop_management/presentation/create_edit_supplier/views/create_edit_supplier_view.dart';
import '../modules/shop_management/presentation/create_edit_technician/bindings/create_edit_technician_binding.dart';
import '../modules/shop_management/presentation/create_edit_technician/views/create_edit_technician_view.dart';
import '../modules/shop_management/presentation/purchased_orders/create_edit_purchased_order/bindings/create_edit_purchased_order_binding.dart';
import '../modules/shop_management/presentation/purchased_orders/create_edit_purchased_order/views/create_edit_purchased_order_view.dart';
import '../modules/shop_management/presentation/purchased_orders/purchased_order_detail/bindings/purchased_order_detail_binding.dart';
import '../modules/shop_management/presentation/purchased_orders/purchased_order_detail/views/purchased_order_detail_view.dart';
import '../modules/shop_management/presentation/purchased_orders/purchased_orders/bindings/purchased_orders_binding.dart';
import '../modules/shop_management/presentation/purchased_orders/purchased_orders/views/purchased_orders_view.dart';
import '../modules/shop_management/presentation/service_orders/create_edit_service_order/bindings/create_edit_service_order_binding.dart';
import '../modules/shop_management/presentation/service_orders/create_edit_service_order/views/create_edit_service_order_view.dart';
import '../modules/shop_management/presentation/service_orders/service_order_details/bindings/service_order_details_binding.dart';
import '../modules/shop_management/presentation/service_orders/service_order_details/views/service_order_details_view.dart';
import '../modules/shop_management/presentation/service_orders/service_orders/bindings/service_orders_binding.dart';
import '../modules/shop_management/presentation/service_orders/service_orders/views/service_orders_view.dart';
import '../modules/shop_management/presentation/shop_clients/bindings/shop_clients_binding.dart';
import '../modules/shop_management/presentation/shop_clients/views/shop_clients_view.dart';
import '../modules/shop_management/presentation/shop_inventories/bindings/shop_inventories_binding.dart';
import '../modules/shop_management/presentation/shop_inventories/views/shop_inventories_view.dart';
import '../modules/shop_management/presentation/shop_suppliers/bindings/shop_suppliers_binding.dart';
import '../modules/shop_management/presentation/shop_suppliers/views/shop_suppliers_view.dart';
import '../modules/shop_management/presentation/technicians/bindings/technicians_binding.dart';
import '../modules/shop_management/presentation/technicians/views/technicians_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/storage/presentation/resource_details/bindings/resource_details_binding.dart';
import '../modules/storage/presentation/resource_details/views/resource_details_view.dart';
import '../modules/storage/presentation/share_resource/bindings/share_resource_binding.dart';
import '../modules/storage/presentation/share_resource/views/share_resource_view.dart';
import '../modules/storage/presentation/storage_drive/bindings/storage_drive_binding.dart';
import '../modules/storage/presentation/storage_drive/views/storage_drive_view.dart';
import '../modules/storage/presentation/verify_drive_otp/bindings/verify_drive_otp_binding.dart';
import '../modules/storage/presentation/verify_drive_otp/views/verify_drive_otp_view.dart';
import '../modules/task_management/presentation/create_task/bindings/create_task_binding.dart';
import '../modules/task_management/presentation/create_task/views/create_task_view.dart';
import '../modules/task_management/presentation/task_detail_view/bindings/task_detail_view_binding.dart';
import '../modules/task_management/presentation/task_detail_view/views/task_detail_view_view.dart';
import '../modules/task_management/presentation/task_management/bindings/task_management_binding.dart';
import '../modules/task_management/presentation/task_management/views/task_management_view.dart';
import '../modules/task_management/presentation/view_all_task/bindings/view_all_task_binding.dart';
import '../modules/task_management/presentation/view_all_task/views/view_all_task_view.dart';
import '../modules/update_profile/presentation/bindings/update_profile_binding.dart';
import '../modules/update_profile/presentation/views/update_profile_view.dart';
import '../modules/user_management/presentation/all_user/bindings/all_user_binding.dart';
import '../modules/user_management/presentation/all_user/views/all_user_view.dart';
import '../modules/user_management/presentation/delete_user/bindings/delete_user_binding.dart';
import '../modules/user_management/presentation/delete_user/views/delete_user_view.dart';
import '../modules/user_management/presentation/new_account/bindings/new_account_binding.dart';
import '../modules/user_management/presentation/new_account/views/new_account_view.dart';
import '../modules/user_management/presentation/reset_user_password/bindings/reset_user_password_binding.dart';
import '../modules/user_management/presentation/reset_user_password/views/reset_user_password_view.dart';
import '../modules/user_management/presentation/update_user_details/bindings/update_user_details_binding.dart';
import '../modules/user_management/presentation/update_user_details/views/update_user_details_view.dart';
import '../modules/user_management/presentation/user_detail_view/bindings/user_detail_view_binding.dart';
import '../modules/user_management/presentation/user_detail_view/views/user_detail_view_view.dart';

part 'app_routes.dart';

/// App pages (screens) of the project.
class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  /// List of all routes of the project.
  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_SCREEN,
      page: () => const MainScreenView(),
      binding: MainScreenBinding(),
    ),
    GetPage(
      name: _Paths.CONVERSATIONS,
      page: () => const ConversationsView(),
      binding: ConversationsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_SETTINGS,
      page: () => const GroupSettingsView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_INNER_CONVERSATIONS,
      page: () => const GroupInnerConversationsView(),
      binding: GroupInnerConversationsBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTS,
      page: () => const ContactsView(),
      binding: ContactsBinding(),
    ),
    GetPage(
      name: _Paths.OTO_CONVERSATIONS,
      page: () => const OtoConversationsView(),
      binding: OtoConversationsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_GROUP,
      page: () => const CreateGroupView(),
      binding: CreateGroupBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_CONVERSATIONS,
      page: () => const GroupConversationsView(),
      binding: GroupConversationsBinding(),
    ),
    GetPage(
      name: _Paths.CLOCK_IN_OUT,
      page: () => const ClockInOutView(),
      binding: ClockInOutBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAIL,
      page: () => const ChatDetailView(),
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: _Paths.MENU_PAGE,
      page: () => const MenuPageView(),
      binding: MenuPageBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.REQUEST_LOADS,
      page: () => const RequestLoadsView(),
      binding: RequestLoadsBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE_PAYMENT_REQUESTS,
      page: () => const InvoicePaymentRequestsView(),
      binding: InvoicePaymentRequestsBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE_PAYMENTS_DELETE,
      page: () => const InvoicePaymentsDeleteView(),
      binding: InvoicePaymentsRevertBinding(),
    ),
    GetPage(
      name: _Paths.FORWARD_MESSAGE,
      page: () => const ForwardMessageView(),
      binding: ForwardMessageBinding(),
    ),
    GetPage(
      name: _Paths.LEAVE_REQUESTED,
      page: () => const LeaveRequestedView(),
      binding: LeaveRequestedBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_LEAVE_REQUESTS,
      page: () => const ManageLeaveRequestsView(),
      binding: ManageLeaveRequestsBinding(),
    ),
    GetPage(
      name: _Paths.LEAVE_REQUESTS_HISTORY,
      page: () => const LeaveRequestsHistoryView(),
      binding: LeaveRequestsHistoryBinding(),
    ),
    GetPage(
      name: _Paths.NEW_LEAVE_REQUEST,
      page: () => const NewLeaveRequestView(),
      binding: NewLeaveRequestBinding(),
    ),
    GetPage(
      name: _Paths.NEW_INSPECTION,
      page: () => const NewInspectionView(),
      binding: NewInspectionBinding(),
    ),
    GetPage(
      name: _Paths.ALL_USER,
      page: () => const AllUserView(),
      binding: AllUserBinding(),
    ),
    GetPage(
      name: _Paths.NEW_ACCOUNT,
      page: () => const NewAccountView(),
      binding: NewAccountBinding(),
    ),
    GetPage(
      name: _Paths.USER_DETAIL_VIEW,
      page: () => const UserDetailViewView(),
      binding: UserDetailViewBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_USER_DETAILS,
      page: () => const UpdateUserDetailsView(),
      binding: UpdateUserDetailsBinding(),
    ),
    GetPage(
      name: _Paths.RESET_USER_PASSWORD,
      page: () => const ResetUserPasswordView(),
      binding: ResetUserPasswordBinding(),
    ),
    GetPage(
      name: _Paths.DELETE_USER,
      page: () => const DeleteUserView(),
      binding: DeleteUserBinding(),
    ),
    GetPage(
      name: _Paths.DRIVER_INSPECTION,
      page: () => const DriverInspectionView(),
      binding: DriverInspectionBinding(),
    ),
    GetPage(
      name: _Paths.TRUCK_TRAILER_INSPECTION,
      page: () => const TruckTrailerInspectionView(),
      binding: TruckTrailerInspectionBinding(),
    ),
    GetPage(
      name: _Paths.FORMS,
      page: () => const FormsView(),
      binding: FormsBinding(),
    ),
    GetPage(
      name: _Paths.FORM_DETAIL_VIEW,
      page: () => const FormDetailViewView(),
      binding: FormDetailViewBinding(),
    ),
    GetPage(
      name: _Paths.ANNOUCMENTS,
      page: () => const AnnoucmentsView(),
      binding: AnnoucmentsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_SHIPMENT,
      page: () => const CreateShipmentView(),
      binding: CreateShipmentBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ADMIN_PARTICIPANTS,
      page: () => const AddAdminParticipantsView(),
      binding: AddAdminParticipantsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DRIVER_PARTICIPANTS,
      page: () => const AddDriverParticipantsView(),
      binding: AddDriverParticipantsBinding(),
    ),
    GetPage(
      name: _Paths.SHIPMENT_LISTING,
      page: () => const ShipmentsView(),
      binding: ShipmentsBinding(),
    ),
    GetPage(
      name: _Paths.SHIPMENT_DETAILS,
      page: () => const ShipmentDetailsView(),
      binding: ShipmentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.TASK_MANAGEMENT,
      page: () => const TaskManagementView(),
      binding: TaskManagementBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_ALL_TASK,
      page: () => const ViewAllTaskView(),
      binding: ViewAllTaskBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_TASK,
      page: () => const CreateTaskView(),
      binding: CreateTaskBinding(),
    ),
    GetPage(
      name: _Paths.TASK_DETAIL_VIEW,
      page: () => const TaskDetailViewView(),
      binding: TaskDetailViewBinding(),
    ),
    GetPage(
      name: _Paths.APPLICATIONS,
      page: () => const ApplicationsView(),
      binding: ApplicationsBinding(),
    ),
    GetPage(
      name: _Paths.APPLICATION_DETAIL_VIEW,
      page: () => const ApplicationDetailViewView(),
      binding: ApplicationDetailViewBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.STORAGE_DRIVE,
      page: () => const StorageDriveView(),
      binding: StorageDriveBinding(),
    ),
    GetPage(
      name: _Paths.RESOURCE_DETAILS,
      page: () => const ResourceDetailsView(),
      binding: ResourceDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SHARE_RESOURCE,
      page: () => const ShareResourceView(),
      binding: ShareResourceBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_DRIVE_OTP,
      page: () => const VerifyDriveOtpView(),
      binding: VerifyDriveOtpBinding(),
    ),
    GetPage(
      name: _Paths.MEDIA_PICKER_PREVIEWER,
      page: () => const MediaPickerPreviewerView(),
      binding: MediaPickerPreviewerBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_ORDERS,
      page: () => const ServiceOrdersView(),
      binding: ServiceOrdersBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_ORDER_DETAILS,
      page: () => const ServiceOrderDetailsView(),
      binding: ServiceOrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_INVENTORIES,
      page: () => const ShopInventoriesView(),
      binding: ShopInventoriesBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_SUPPLIERS,
      page: () => const ShopSuppliersView(),
      binding: ShopSuppliersBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EDIT_SUPPLIER,
      page: () => const CreateEditSupplierView(),
      binding: CreateEditSupplierBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EDIT_INVENTORY,
      page: () => const CreateEditInventoryView(),
      binding: CreateEditInventoryBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EDIT_SERVICE_ORDER,
      page: () => const CreateEditServiceOrderView(),
      binding: CreateEditServiceOrderBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_CLIENTS,
      page: () => const ShopClientsView(),
      binding: ShopClientsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EDIT_CLIENT,
      page: () => const CreateEditClientView(),
      binding: CreateEditClientBinding(),
    ),
    GetPage(
      name: _Paths.INSPECTION_DETAILS,
      page: () => const InspectionDetailsView(),
      binding: InspectionDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_INSPECTION_REQUEST,
      page: () => const CreateInspectionRequestView(),
      binding: CreateInspectionRequestBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EDIT_TECHNICIAN,
      page: () => const CreateEditTechnicianView(),
      binding: CreateEditTechnicianBinding(),
    ),
    GetPage(
      name: _Paths.TECHNICIANS,
      page: () => const TechniciansView(),
      binding: TechniciansBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ANNOUNCEMENT,
      page: () => const CreateAnnouncementView(),
      binding: CreateAnnouncementBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASED_ORDERS,
      page: () => const PurchasedOrdersView(),
      binding: PurchasedOrdersBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_EDIT_PURCHASED_ORDER,
      page: () => const CreateEditPurchasedOrderView(),
      binding: CreateEditPurchasedOrderBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASED_ORDER_DETAIL,
      page: () => const PurchasedOrderDetailView(),
      binding: PurchasedOrderDetailBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE_NOTIFICATIONS,
      page: () => const MessageNotificationsView(),
      binding: MessageNotificationsBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_THEME_SETTINGS,
      page: () => const ChatThemeSettingsView(),
      binding: ChatThemeSettingsBinding(),
    ),
    GetPage(
      name: _Paths.TRUCKS,
      page: () => const TrucksView(),
      binding: TrucksBinding(),
    ),
    GetPage(
      name: _Paths.TRAILERS,
      page: () => const TrailersView(),
      binding: TrailersBinding(),
    ),
    GetPage(
      name: _Paths.TRUCK_DETAILS,
      page: () => const TruckDetailsView(),
      binding: TruckDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SAFETY,
      page: () => const SafetyView(),
      binding: SafetyBinding(),
    ),
    GetPage(
      name: _Paths.TRAILER_DETAILS,
      page: () => const TrailerDetailsView(),
      binding: TrailerDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_TRUCK,
      page: () => const CreateTruckView(),
      binding: CreateTruckBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_TRAILER,
      page: () => const CreateTrailerView(),
      binding: CreateTrailerBinding(),
    ),
    GetPage(
      name: _Paths.ADDITIONAL_PAY,
      page: () => const AdditionalPayView(),
      binding: AdditionalPayBinding(),
    ),
  ];
}
