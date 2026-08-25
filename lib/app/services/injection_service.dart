import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ts_admin/app/controllers/location_controller.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/assets_attachments_manager.dart';

import 'package:ts_admin/app/core/helpers/file_helpers/chat_audios_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_documents_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_images_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/chat_videos_thumbnail_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/compressed_images_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/hr_attachments_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/storage_files_manager.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/task_attachments_manager.dart';
import 'package:ts_admin/app/core/helpers/pusher_manager.dart';

import 'package:ts_admin/app/core/resources/app_colors.dart';
import 'package:ts_admin/app/modules/annoucments/data/datasources/annoucements_remote_datasource.dart';
import 'package:ts_admin/app/modules/annoucments/data/repositories/annoucements_repository_impl.dart';
import 'package:ts_admin/app/modules/annoucments/domain/repositories/annoucements_repository.dart';
import 'package:ts_admin/app/modules/annoucments/domain/usecases/create_announcement_usecase.dart';
import 'package:ts_admin/app/modules/annoucments/domain/usecases/get_all_announcements_usecase.dart';
import 'package:ts_admin/app/modules/annoucments/domain/usecases/get_announcements_user_types_usecase.dart';
import 'package:ts_admin/app/modules/annoucments/domain/usecases/update_announcement__read_status_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/data/datasource/assets_remote_datasource.dart';
import 'package:ts_admin/app/modules/assets_management/data/repositories/assets_repository_impl.dart';
import 'package:ts_admin/app/modules/assets_management/domain/repositories/assets_repository.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/add_new_note_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/create_vehicle_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/delete_trailer_document_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/delete_truck_document_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_all_teams_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_all_trailers_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_all_trucks_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_create_dropdown_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_device_types_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_device_type_serials_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_single_trailer_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_single_truck_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_trailer_details_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/get_truck_details_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/install_new_device_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/uninstall_device_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/update_document_expiration_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/update_document_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/update_truck_checklist_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/create_new_documents_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/update_vehicle_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/upload_document_pictures_usecase.dart';
import 'package:ts_admin/app/modules/assets_management/domain/usecases/upload_pictures_usecase.dart';
import 'package:ts_admin/app/modules/auth/data/data_sources/firebase_remote_datasource.dart';
import 'package:ts_admin/app/modules/auth/data/repositories/firebase_repository_impl.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/firebase_repository.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/firebase/sign_in_with_email_password_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_app_configration_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_profile_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_realtime_configuration_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/get_user_permissions_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/update_voip_token_usecase.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/messages_notifications_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/buzz_message_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_message_notifications_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/mute_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_group_logo_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_participant_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/call_event_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/delete_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/edit_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/forward_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_chat_info_tags_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/react_message_usecase.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/group_conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_heads_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_conversatiosn_details_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/clock_in_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/clock_out_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/weekly_hours_usscase.dart';

import 'package:ts_admin/app/modules/forms/data/datasources/form_remote_datasource.dart';
import 'package:ts_admin/app/modules/forms/data/repositories/form_repository_impl.dart';
import 'package:ts_admin/app/modules/forms/domain/repositories/form_repository.dart';
import 'package:ts_admin/app/modules/forms/domain/usecases/get_all_forms_usecase.dart';
import 'package:ts_admin/app/modules/forms/domain/usecases/reject_form_usecase.dart';
import 'package:ts_admin/app/modules/forms/domain/usecases/sign_form_usecase.dart';
import 'package:ts_admin/app/modules/hr/data/data_sources/hr_remote_data_source.dart';
import 'package:ts_admin/app/modules/hr/data/repositories/hr_repository_imp.dart';
import 'package:ts_admin/app/modules/hr/domain/repositories/hr_repository.dart';
import 'package:ts_admin/app/modules/hr/domain/usecases/get_application_details_usecase.dart';
import 'package:ts_admin/app/modules/hr/domain/usecases/get_applications_usecase.dart';

import 'package:ts_admin/app/modules/inspection_management/data/datasources/inspection_management_remote_datasource.dart';

import 'package:ts_admin/app/modules/inspection_management/data/repositories/inspection_management_repository.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/repositories/inspection_management_repository.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/create_inspection_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/delete_inspection_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspected_drivers_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspected_trailer_truck_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspection_details_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspection_dropdown.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_inspection_fields_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_pending_drivers_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/get_pending_trailer_truck_usecase.dart';
import 'package:ts_admin/app/modules/inspection_management/domain/usecases/submit_inspection_request_usecase.dart';

import 'package:ts_admin/app/modules/invoices_management/data/data_sources/invoice_payments_remote_data_source.dart';
import 'package:ts_admin/app/modules/invoices_management/data/repostories/invoice_payments_repository.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/repositories/invoice_payments_repository.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/usecases/invoice_payments_use_case.dart';
import 'package:ts_admin/app/modules/invoices_management/domain/usecases/update_invoice_payment_status_use_case.dart';

import 'package:ts_admin/app/modules/auth/data/data_sources/auth_data_source.dart';
import 'package:ts_admin/app/modules/auth/data/repositories/auth_repository.dart';
import 'package:ts_admin/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ts_admin/app/modules/auth/domain/usecases/update_password_usecase.dart';

import 'package:ts_admin/app/modules/chat_detail/data/datasources/conversation_details_remote_data_source.dart';
import 'package:ts_admin/app/modules/chat_detail/data/datasources/send_message_remote_data_source.dart';
import 'package:ts_admin/app/modules/chat_detail/data/repositories/conversation_details_repository_impl.dart';
import 'package:ts_admin/app/modules/chat_detail/data/repositories/messages_db_manager.dart';
import 'package:ts_admin/app/modules/chat_detail/data/repositories/send_message_repository_impl.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/conversation_details_repository.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/repositories/send_message_repository.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_conversation_details_usercase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/get_previous_messages_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/message_mark_as_read_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/send_file_message_usecase.dart';
import 'package:ts_admin/app/modules/chat_detail/domain/usecases/send_text_message_usecase.dart';

import 'package:ts_admin/app/modules/clock-in-out/data/datasources/clock_ic_out_remote_data_source.dart';
import 'package:ts_admin/app/modules/clock-in-out/data/repositories/clock_in_out_repository.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/repositories/clock_in_out_repository.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/check_clock_in_usecase.dart';
import 'package:ts_admin/app/modules/clock-in-out/domain/usecases/clock_in_out_history_usecase.dart';

import 'package:ts_admin/app/modules/chat/data/data_sources/conversation_remote_data_source.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/conversation_repository.dart';
import 'package:ts_admin/app/modules/chat/data/repositories/conversations_db_manager.dart';
import 'package:ts_admin/app/modules/chat/domain/repositories/conversation_repository.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/add_participants_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/archive_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/create_group_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/create_new_conversation_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_all_contacts_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_all_conversations_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_all_group_conversations_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/get_group_contacts_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/remove_participants_usecase.dart';
import 'package:ts_admin/app/modules/chat/domain/usecases/update_group_name_usecase.dart';

import 'package:ts_admin/app/modules/leave_management/data/datasources/leave_management_remote_datasource.dart';
import 'package:ts_admin/app/modules/leave_management/data/repositories/leave_management_repository.dart';
import 'package:ts_admin/app/modules/leave_management/domain/repositories/leave_management_repository.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/check_eligibility_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_all_leave_types_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_remaining_leaves_per_category_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_all_super_visors_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_alternative_users_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/admin_action_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_users_requested_leaves_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/submit_leave_request_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_all_requested_leaves_usecase.dart';
import 'package:ts_admin/app/modules/leave_management/domain/usecases/get_requested_history_usecase.dart';

import 'package:ts_admin/app/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/data/datasources/settings_data_source.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/data/repositories/settings_repository_impl.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/domain/repositories/settings_repository.dart';
import 'package:ts_admin/app/modules/menu_page/presentation/settings/domain/usecases/update_otp_usecase.dart';

import 'package:ts_admin/app/modules/request_loads/data/data_sources/loads_remote_data_source.dart';
import 'package:ts_admin/app/modules/request_loads/data/repositories/loads_repository.dart';
import 'package:ts_admin/app/modules/request_loads/domain/repositories/loads_repository.dart';
import 'package:ts_admin/app/modules/request_loads/domain/usecases/request_loads_use_case.dart';
import 'package:ts_admin/app/modules/shipment/data/datasources/shipment_remote_datasource.dart';
import 'package:ts_admin/app/modules/shipment/data/repositories/shipment_repository.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/create_shipment_template.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_additional_pays_usecase.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/resolve_additional_pay_usecase.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_all_shipments.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_shipment_details.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_shipment_dropdowns.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/get_shipments_template.dart';
import 'package:ts_admin/app/modules/shipment/domain/usecases/update_shipment_template.dart';
import 'package:ts_admin/app/modules/shop_management/data/datasources/shop_remote_datasource.dart';
import 'package:ts_admin/app/modules/shop_management/data/repositories/shop_repository.dart';
import 'package:ts_admin/app/modules/shop_management/domain/repositories/shop_repository.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/change_service_order_status.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/complete_service_order.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/create_edit_client.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/create_edit_service_order.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/create_inventory.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/create_supplier.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/create_technician.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/delete_inventory.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/delete_supplier.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/delete_technician.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/disable_client.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/disable_inventory.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/disable_supplier.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/disable_technican.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/edit_inventory.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/edit_supplier.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/edit_technician.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_all_clients.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_all_service_orders.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_all_shop_inventories.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_all_suppliers.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_all_technicians.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_carrier_vehicles.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_customer_details.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_service_dropdown.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/get_service_order_details.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/resubmit_service_order.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/change_purchase_order_status_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/create_or_edit_used_client_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/create_purchase_order_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/create_used_inventory_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/create_used_supplier_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/delete_used_inventory_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/delete_used_supplier_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/disable_used_client_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/disable_used_inventory_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/disable_used_supplier_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/edit_purchase_order_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/edit_used_inventory_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/edit_used_supplier_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/get_all_purchase_orders_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/get_all_used_clients_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/get_all_used_inventories_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/get_all_used_suppliers_usecase.dart';
import 'package:ts_admin/app/modules/shop_management/domain/usecases/used_part/get_purchase_details_usecase.dart';
import 'package:ts_admin/app/modules/storage/data/data_sources/storage_data_source.dart';
import 'package:ts_admin/app/modules/storage/data/repositories/storage_repository_imp.dart';
import 'package:ts_admin/app/modules/storage/domain/repositories/storage_repository.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/delete_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/download_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/get_resources_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/get_storage_users_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/rename_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/revoke_all_resource_permission_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/revoke_resource_permission_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/create_folder_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/send_drive_otp_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/share_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/upload_file_resource_usecase.dart';
import 'package:ts_admin/app/modules/storage/domain/usecases/verify_drive_otp_usecase.dart';
import 'package:ts_admin/app/modules/task_management/data/data_sources/tasks_remote_data_source.dart';
import 'package:ts_admin/app/modules/task_management/data/repositories/tasks_repository.dart';
import 'package:ts_admin/app/modules/task_management/domain/repositories/tasks_repository.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/create_task_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/get_all_tasks_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/get_tasks_listing_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/get_task_dropdown_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/refresh_tasks_listing_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/update_task_progress_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/update_task_status_usecase.dart';
import 'package:ts_admin/app/modules/task_management/domain/usecases/update_task_usecase.dart';

import 'package:ts_admin/app/modules/update_profile/data/data_sources/update_profile_remote_data_source.dart';
import 'package:ts_admin/app/modules/update_profile/data/repositories/update_profile_repository.dart';
import 'package:ts_admin/app/modules/update_profile/domain/repositories/update_profile_repository.dart';
import 'package:ts_admin/app/modules/update_profile/domain/usecases/update_profile_usecase.dart';
import 'package:ts_admin/app/modules/user_management/data/datasources/user_management_remote_datasource.dart';
import 'package:ts_admin/app/modules/user_management/data/repositories/user_management_repository.dart';
import 'package:ts_admin/app/modules/user_management/domain/repositories/user_management_repository.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/create_admin_request_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/delete_admin_request_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/get_all_supervisors_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/get_user_off_days_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/update_admin_password_request_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/update_admin_request_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/get_all_countries_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/get_all_departments_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/get_all_designations_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/get_all_rules_usecase.dart';
import 'package:ts_admin/app/modules/user_management/domain/usecases/update_user_status_usecase.dart';

import '../core/network/connection/dio_client.dart';
import '../core/network/connection/network_info.dart';
import '../core/widgets/local_notification.dart';
import '../modules/auth/domain/usecases/login_use_case.dart';
import '../modules/user_management/domain/usecases/get_all_users_usecase.dart';
import 'firebase_options.dart';

/// Main instance of [GetIt] for whole project
final sl = GetIt.instance;

/// Main initiliazer and injecter
/// Initailizing and injecting netwrok, pusher, repos, data sources, network configs
Future<void> init() async {
  // initializing network related things
  initNetwork();

  // initializing repositories
  initRepositories();

  // initilaizing datasources
  initDataSources();

  // initializing usecases
  initUsecases();

  // initializing other things
  await initExtra();
}

/// Initialing [MessagesDatabase], FileManagers, [ConversationsDatabase] and injecting them into [GetIt]
initExtra() async {
  //
  // initialize offline databases
  await initDatabases();

  await FlutterDownloader.initialize(
    // optional: set to false to disable printing logs to console (default: true)
    debug: false,
    // option: set to false to disable working with http links (default: false)
    ignoreSsl: true,
  );

  // checking system current theme and set it to controller
  Get.put<ThemeController>(ThemeController(), permanent: true);

  // location controller injection
  Get.put<LocationController>(LocationController(), permanent: true);

  //
  //
  // file managers
  Get.put<ChatVideosManager>(ChatVideosManager(), permanent: true);
  Get.put<ChatVideosThumbnailManager>(ChatVideosThumbnailManager(),
      permanent: true);
  Get.put<ChatImagesManager>(ChatImagesManager(), permanent: true);
  Get.put<ChatAudiosManager>(ChatAudiosManager(), permanent: true);
  Get.put<ChatDocumentsManager>(ChatDocumentsManager(), permanent: true);
  Get.put<TaskAttachmentsManager>(TaskAttachmentsManager(), permanent: true);
  Get.put<HrAttachmentsManager>(HrAttachmentsManager(), permanent: true);
  Get.put<AssetsAttachmentsManager>(
    AssetsAttachmentsManager(),
    permanent: true,
  );
  Get.put<StorageFilesManager>(StorageFilesManager(), permanent: true);
  Get.put<CompressedImagesManager>(CompressedImagesManager(), permanent: true);
}

///
///
/// Initialize offline databases
initDatabases() async {
  // messages database registeration
  final messagesDatabase = MessagesDatabase();
  await messagesDatabase.database;
  sl.registerLazySingleton<MessagesDatabase>(() => messagesDatabase);

  // conversations database registeration
  final conversationsDatabase = ConversationsDatabase();
  await conversationsDatabase.database;
  sl.registerLazySingleton<ConversationsDatabase>(() => conversationsDatabase);

  // group conversations database registeration
  final groupConversationsDatabase = GroupConversationsDatabase();
  await groupConversationsDatabase.database;
  sl.registerLazySingleton<GroupConversationsDatabase>(
      () => groupConversationsDatabase);

  // messages notifications  database registeration
  final messagesNotificationsDatabase = MessagesNotificationsDatabase();
  await messagesNotificationsDatabase.database;
  sl.registerLazySingleton<MessagesNotificationsDatabase>(
      () => messagesNotificationsDatabase);
}

/// Initiating [PusherManager].
/// Injecting [PusherManager] in [GetIt]
Future<void> initPusherManager() async {
  if (sl.isRegistered<PusherManager>()) {
    final pusherManager = sl<PusherManager>();
    await pusherManager.dispose();
    // The websocket handshake can stall/retry indefinitely (see the reconnect
    // handler in PusherManager). Don't await it here or it blocks callers such
    // as the login flow from navigating. The client is built synchronously
    // inside initializePusher(); only connect() is deferred to the background.
    unawaited(pusherManager.initializePusher());
    return;
  }
  final pusherManager = PusherManager();

  // Register before connecting so consumers (e.g. MainScreenController) can
  // resolve sl<PusherManager>() immediately after navigation.
  sl.registerLazySingleton<PusherManager>(() => pusherManager);

  unawaited(pusherManager.initializePusher());
}

/// Injecting a network configs in [GetIt]
///
/// [INetworkInfo]
/// [InternetConnectionChecker]
/// [DioClient]
initNetwork() {
  sl.registerLazySingleton<INetworkInfo>(
      () => NetworkInfoImpl(dataConnectionChecker: sl()));
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton(() => DioClient());
}

/// Injecting repositories (Clean Arch) of api calls in [GetIt]
initRepositories() {
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImp(dataSource: sl()),
  );

  //! Conversation
  sl.registerLazySingleton<IConversationRepository>(
      () => ConversationRepositoryImpl(conversationDataSource: sl()));

  //! Send Message
  sl.registerLazySingleton<ISendMessageRepository>(
    () => SendMessageRepositoryImpl(sendMessageRemoteDataSource: sl()),
  );

  //! Conversation Details
  sl.registerLazySingleton<IConversationDetailsRepository>(
    () => ConversationDetailsRepositoryImpl(
        conversationDetailsRemoteDataSource: sl()),
  );

  //! Clock in  out repository
  sl.registerLazySingleton<IClockInOutRepository>(
    () => ClockInOutRepositoryImp(clockInOutDataSource: sl()),
  );

  //! update profile repository
  sl.registerLazySingleton<IUpdateProfileRepository>(
    () => UpdateProfileRepositoryImp(dataSource: sl()),
  );

  //! Request Loads
  sl.registerLazySingleton<ILoadsRepository>(
    () => LoadsRepositoryImp(loadsRemoteDataSource: sl()),
  );

  //! invoice payments repository
  sl.registerLazySingleton<IInvoicePaymentsRepository>(
    () => InvoicePaymentsRepositoryImp(dataSource: sl()),
  );

  //! leave management
  sl.registerLazySingleton<ILeaveManagementRepository>(
    () => LeaveManagementRepositoryImpl(dataSource: sl()),
  );

  //! inspection management
  sl.registerLazySingleton<IInspectionManagementRepository>(
    () => InspectionManagementRepositoryImpl(dataSource: sl()),
  );

  //! user management
  sl.registerLazySingleton<IUserManagementRepository>(
    () => UserManagementRepositoryImpl(dataSource: sl()),
  );

  //! Form
  sl.registerLazySingleton<IFormRepository>(
    () => FormRepositoryImpl(formDataSource: sl()),
  );

  //! Annoucemenets
  sl.registerLazySingleton<IAnnoucementsRepository>(
    () => AnnoucementsRepositoryImpl(dataSource: sl()),
  );

  //! Shipment
  sl.registerLazySingleton<IShipmentRepository>(
    () => ShipmentRepositoryImp(dataSource: sl()),
  );

  //! task management
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImp(dataSource: sl()),
  );

  //! hr
  sl.registerLazySingleton<HrRepository>(
    () => HrRepositoryImp(dataSource: sl()),
  );

  //! storage / drive
  sl.registerLazySingleton<IStorageRespository>(
    () => StorageRepositoryImp(dataSource: sl()),
  );

  //! shop management
  sl.registerLazySingleton<IShopRepository>(
    () => ShopRepositoryImp(dataSource: sl()),
  );

  //! assets management
  sl.registerLazySingleton<IAssetsRepository>(
    () => AssetsRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(dataSource: sl()),
  );

  //! Firebase
  sl.registerLazySingleton<IFirebaseRepository>(
    () => FirebaseRepositoryImpl(dataSource: sl(), networkInfo: sl()),
  );
}

/// Injecting data source (Clean Arch) of api calls in [GetIt]
initDataSources() {
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(dioClient: sl()),
  );

  //! Conversations
  sl.registerLazySingleton<IConversationRemoteDataSource>(
    () => ConversationRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Send Message
  sl.registerLazySingleton<ISendMessageRemoteDataSource>(
    () => SendMessageRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Chat
  sl.registerLazySingleton<IConversationDetailsRemoteDataSource>(
    () => ConversationDetailsRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Clock in out remote data source
  sl.registerLazySingleton<IClockInOutDataSource>(
    () => ClockInOutRemoteDataSourceImp(dioClient: sl()),
  );

  //! update profile remote data source
  sl.registerLazySingleton<IUpdateProfileDataSource>(
    () => UpdateProfileDataSourceImp(dioClient: sl()),
  );

  //! Request Loads
  sl.registerLazySingleton<ILoadsRemoteDataSource>(
    () => LoadsRemoteDataSourceImp(dioClient: sl()),
  );

  //! invoice payments remote data source
  sl.registerLazySingleton<IInvoicePaymentsRemoteDataSource>(
    () => InvoicePaymentsRemoteDataSourceImp(dioClient: sl()),
  );

  //! leave management
  sl.registerLazySingleton<ILeaveManagementRemoteDataSource>(
    () => LeaveManagementRemoteDataSourceImpl(dioClient: sl()),
  );

  //! inspection management
  sl.registerLazySingleton<IInspectionManagementRemoteDataSource>(
    () => InspectionManagementRemoteDataSourceImpl(dioClient: sl()),
  );

  //! user management
  sl.registerLazySingleton<IUserManagementRemoteDataSource>(
    () => UserManagementRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Form
  sl.registerLazySingleton<IFormRemoteDataSource>(
    () => FormRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Annoucemenets
  sl.registerLazySingleton<IAnnoucementsRemoteDataSource>(
    () => AnnoucementRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Shipment
  sl.registerLazySingleton<IShipmentRemoteDataSource>(
    () => ShipmentRemoteDataSourceImp(dioClient: sl()),
  );

  //! tasks management
  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImp(dioClient: sl()),
  );

  //! hr
  sl.registerLazySingleton<HrRemoteDataSource>(
    () => HrRemoteDataSourceImp(dioClient: sl()),
  );

  //! storage / drive
  sl.registerLazySingleton<IStorageDataSource>(
    () => StorageRemoteDataSource(dioClient: sl()),
  );

  //! shop management
  sl.registerLazySingleton<IShopRemoteDataSource>(
    () => ShopRemoteDataSourceImp(dioClient: sl()),
  );

  //! assets management
  sl.registerLazySingleton<IAssetsRemoteDataSource>(
    () => AssetsRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Settings
  sl.registerLazySingleton<ISettingsDataSource>(
    () => SettingsDataSourceImp(dioClient: sl()),
  );

  //! Firebase
  sl.registerLazySingleton<IFirebaseRemoteDataSource>(
    () => FirebaseRemoteDatasourceImpl(),
  );
}

/// Injecting usecases (Clean Arch) of api calls in [GetIt]
initUsecases() {
  //
  //
  // auth and profile etc
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(authRepository: sl()));
  sl.registerLazySingleton(
      () => GetUserPermissionsUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => UpdateProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdatePasswordUsecase(repository: sl()));

  ///
  ///
  /// chat usecases
  sl.registerLazySingleton(
      () => GetAllGroupConversationsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllConversationsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => GetGroupHeadsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => GetGroupConversationDetailsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllContactsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => GetGroupContactsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => CreateNewConversationUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => SendFileMessageUseCase(sendMessageRepository: sl()));
  sl.registerLazySingleton(
      () => MessageMarkAsReadUseCase(sendMessageRepository: sl()));
  sl.registerLazySingleton(() => GetPreviousMessagesUseCase(sl()));
  sl.registerLazySingleton(
      () => SendTextMessageUseCase(sendMessageRepository: sl()));
  sl.registerLazySingleton(() => EditTextMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => ReactMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetConversationDetailsUseCase(sl()));
  sl.registerLazySingleton(
      () => CreateGroupUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => AddParticipantsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => RemoveParticipantsUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => ArchiveConversationUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateGroupNameUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateGroupLogoUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateParticipantUsecase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => MuteConversationUseCase(conversationRepository: sl()));
  sl.registerLazySingleton(
      () => BuzzMessageUsecase(conversationRepository: sl()));
  sl.registerLazySingleton(() => UpdateVoipTokenUsecase(repository: sl()));
  sl.registerLazySingleton(() => ForwardMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChatInfoTagsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetMessageNotificationsUseCase(conversationRepository: sl()));

  ///
  ///
  /// clock in/ou usecases
  sl.registerLazySingleton(() => CheckClockInUsecase(repository: sl()));
  sl.registerLazySingleton(() => ClockInUsecase(repository: sl()));
  sl.registerLazySingleton(() => ClockOutUsecase(repository: sl()));
  sl.registerLazySingleton(() => ClockInOutHistoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetWeeklyHoursUseCase(repository: sl()));

  //! request loads
  sl.registerLazySingleton(() => RequestLoadsUseCase(loadsRepository: sl()));
  //! call event
  sl.registerLazySingleton(() => CallEventUsecase(repository: sl()));
  //! get invoice payments
  sl.registerLazySingleton(() => InvoicePaymentsUseCase(repository: sl()));

  //! update invoice payment status
  sl.registerLazySingleton(
      () => UpdateInvoicePaymentStatusUseCase(repository: sl()));

  //! logout
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));

  //! leave management
  sl.registerLazySingleton(() => GetAllLeaveTypesUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetRemainingLeavesPerCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllSuperVisorsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAlternativeUsersUsecase(repository: sl()));
  sl.registerLazySingleton(() => CheckEligibilityUsecase(repository: sl()));
  sl.registerLazySingleton(() => SubmitLeaveRequestUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetRequestedLeavesUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetUsersRequestedLeavesUsecase(repository: sl()));
  sl.registerLazySingleton(() => AdminActionUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetRequestedHistoryUsecase(repository: sl()));

  //! inspection management
  sl.registerLazySingleton(() => SubmitInspectionUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetPendingDriverUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetInspectedDriverUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetPendingTrailerTruckUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetInspectedTrailerTruckUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetInspectionFieldsUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteInspectionUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetInspectionDetailsUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetInspectionDropdownUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => CreateInspectionRequestUsecase(repository: sl()),
  );

  //! user management
  sl.registerLazySingleton(() => CreateAdminUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAdminUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateAdminUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserStatusUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateAdminPasswordUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllUsersUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllRulesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllCountriesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllSupervisorsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllDepartmentsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllDesignationsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetUserOffDaysUsecase(repository: sl()));

  //! Forms
  sl.registerLazySingleton(() => GetAllFormsUsecase(formRepository: sl()));
  sl.registerLazySingleton(() => SignFormUsecase(formRepository: sl()));
  sl.registerLazySingleton(() => RejectFormUsecase(formRepository: sl()));

  //! Annoucemenets
  sl.registerLazySingleton(
      () => GetAllAnnouncementsUsecase(annoucementsRepository: sl()));
  sl.registerLazySingleton(
      () => CreateAnnouncementUsecase(annoucementsRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateAnnouncementReadStatusUsecase(annoucementsRepository: sl()));
  sl.registerLazySingleton(
      () => GetAnnouncementUserTypeUsecase(annoucementsRepository: sl()));

  //
  //! shipment
  sl.registerLazySingleton(
      () => GetCSDropdownsUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllShipmentUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => GetShipmentDetailsUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => CreateShipmentTemplateUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => GetShipmentTemplatesUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateShipmentTemplateUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => GetAdditionalPaysUsecase(shipmentRepository: sl()));
  sl.registerLazySingleton(
      () => ResolveAdditionalPayUsecase(shipmentRepository: sl()));

  //
  //! tasks management
  sl.registerLazySingleton(() => GetTasksListingUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTasksUsecase(repository: sl()));
  sl.registerLazySingleton(() => RefreshTasksListingUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetTaskDropdownUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskStatusUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskProgressUsecase(repository: sl()));

  //
  //! hr
  sl.registerLazySingleton(() => GetApplicationsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetApplicationDetailsUsecase(repository: sl()));

  //
  //! storage / drive
  sl.registerLazySingleton(() => GetResourcesUsecase(respository: sl()));
  sl.registerLazySingleton(() => DeleteResourceUsecase(respository: sl()));
  sl.registerLazySingleton(() => DownloadResourceUsecase(respository: sl()));
  sl.registerLazySingleton(() => GetStorageUsersUsecase(respository: sl()));
  sl.registerLazySingleton(
    () => RevokeResourcePermissionUsecase(respository: sl()),
  );
  sl.registerLazySingleton(() => ShareResourceUsecase(respository: sl()));
  sl.registerLazySingleton(
    () => CreateFolderResourceUsecase(respository: sl()),
  );
  sl.registerLazySingleton(() => RenameResourceUsecase(respository: sl()));
  sl.registerLazySingleton(() => UploadFileResourceUsecase(respository: sl()));
  sl.registerLazySingleton(() => SendDriveOtpUsecase(respository: sl()));
  sl.registerLazySingleton(() => VerifyDriveOtpUsecase(respository: sl()));
  sl.registerLazySingleton(
    () => RevokeAllResourcePermissionUsecase(respository: sl()),
  );

  //! Configration
  sl.registerLazySingleton(
      () => GetAppConfigrationUseCase(authRepository: sl()));
  sl.registerLazySingleton(
      () => GetRealtimeConfigurationUseCase(authRepository: sl()));

  //
  //! shop management
  // service order
  sl.registerLazySingleton(() => GetAllServiceOrdersUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetServiceOrderDetailsUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => ChangeServiceOrderStatusUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => CompleteServiceOrderUsecase(repository: sl()));
  sl.registerLazySingleton(() => ResubmitServiceOrderUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetServiceDropdownUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCarrierVehiclesUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => CreateOrEditServiceOrderUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetCustomerDetailsUsecase(repository: sl()));
  // shop inventory
  sl.registerLazySingleton(() => GetAllShopInvetoriesUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteInventoryUsecase(repository: sl()));
  // suppliers
  sl.registerLazySingleton(() => GetAllSuppliersUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateSupplierUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditSupplierUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableSupplierUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteSupplierUsecase(repository: sl()));
  // clients
  sl.registerLazySingleton(() => GetAllClientsUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateOrEditClientUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableClientUsecase(repository: sl()));
  // technicians
  sl.registerLazySingleton(() => GetAllTechniciansUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateTechnicianUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditTechnicianUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableTechnicanUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTechnicianUsecase(repository: sl()));

  // used parts
  // Purchase Order UseCases
  sl.registerLazySingleton(() => GetAllPurchaseOrdersUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetPurchaseDetailsUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreatePurchaseOrderUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditPurchaseOrderUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => ChangePurchaseOrderStatusUsecase(repository: sl()),
  );

  // Used Inventory UseCases
  sl.registerLazySingleton(() => CreateUsedInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditUsedInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteUsedInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableUsedInventoryUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetAllUsedInventoriesUsecase(repository: sl()),
  );

  // Used Client UseCases
  sl.registerLazySingleton(() => GetAllUsedClientsUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableUsedClientUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => CreateOrEditUsedClientUsecase(repository: sl()),
  );

  // Used Supplier UseCases
  sl.registerLazySingleton(() => GetAllUsedSuppliersUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateUsedSupplierUsecase(repository: sl()));
  sl.registerLazySingleton(() => EditUsedSupplierUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteUsedSupplierUsecase(repository: sl()));
  sl.registerLazySingleton(() => DisableUsedSupplierUsecase(repository: sl()));

  //! assets-management
  // trucks
  sl.registerLazySingleton(() => GetAllTrucksUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetSingleTruckUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetTruckDetailsUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTruckDocumentUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTruckCheckListUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateNewDocumentsUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => UploadDocumentPicturesUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => UpdateDocumentUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => UpdateDocumentExpirationUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => UploadPicturesUsecase(repository: sl()));
  sl.registerLazySingleton(() => UninstallDeviceUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddNewNoteUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTeamsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetDeviceTypesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetDeviceTypeSerialsUsecase(repository: sl()));
  sl.registerLazySingleton(() => InstallDeviceUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCreateDropdownUsecase(repository: sl()));

  // traielrs
  sl.registerLazySingleton(() => GetAllTrailersUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetSingleTrailerUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetTrailerDetailsUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => DeleteTrailerDocumentUsecase(repository: sl()),
  );

  sl.registerLazySingleton(() => CreateVehicleUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateVehicleUsecase(repository: sl()));

  // Settings
  sl.registerLazySingleton(() => UpdateOtpUsecase(repository: sl()));

  //! Firebase
  sl.registerLazySingleton(() => SignInToFirebaseUseCase(sl()));
}

/// Firebase entry point for background message handling
///
/// Handling incomming call notifications in order to show incomming call view and cancel incoomming call
/// For showing incomming call [CallingKit.showCalling] is called and passing a required payload.
/// For cancel incomming call [CallingKit.cancelCurrentIncomming] is used and passing a required payload.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await LocalNotification.setupFlutterNotifications();
  // LocalNotification.showFlutterNotification(message);
  debugPrint('Handling a background message ${message.messageId}');
}

/// Inializing [Firebase] and [FirebaseMessaging].
/// VConfiguring [FirebaseMessaging.onMessage] and [FirebaseMessaging.onBackgroundMessage] for fcm messages.
/// Also adding [FirebaseMessaging.onMessageOpenedApp] handler when app open's from notification.
/// Showing notifications when in foreground mode using [LocalNotification] by calling [LocalNotification.showFlutterNotification]
Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await LocalNotification.setupFlutterNotifications();
  }
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// foreground notification listener
  FirebaseMessaging.onMessage.listen(LocalNotification.showFlutterNotification);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint(
        'A new onMessageOpenedApp event was published! ${message.toMap()}');
    LocalNotification.handleMessage(message.data);
  });
}

/// Init a [GetStorage].
Future<void> initLocalDb() async {
  await GetStorage.init();
}
