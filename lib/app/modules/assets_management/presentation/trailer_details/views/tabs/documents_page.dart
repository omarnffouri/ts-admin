import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../../components/vehicle_details/section_empty_state.dart';
import '../../../components/vehicle_details/vehicle_document_card.dart';
import '../../../components/vehicle_details/vehicle_section.dart';
import '../../controllers/trailer_details_controller.dart';

class DocumentsPage extends GetView<TrailerDetailsController> {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final Documents? documents = controller.trailerDetails.value?.documents;
        final bool isLoading = controller.isLoading.value;

        if (isLoading && documents == null) {
          return const _DocumentsLoadingView();
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing trailer documents',
          refreshController: controller.documentsRefreshCtrl,
          onRefresh: controller.init,
          slidableAutoClose: true,
          sliver: documents == null
              ? VehicleDetailsErrorState(
                  title: 'Trailer documents unavailable',
                  message: "We couldn't load this trailer's documents.",
                  onRetry: controller.init,
                )
              : DocumentsBody(documents: documents),
        );
      },
    );
  }
}

class DocumentsBody extends GetView<TrailerDetailsController> {
  const DocumentsBody({super.key, required this.documents});

  final Documents documents;

  @override
  Widget build(BuildContext context) {
    final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();
    final List<DocumentDto> requested = documents.requestedDocuments ?? [];
    final List<FileEntity> trailerDocuments = documents.otherDocuments ?? [];
    final List<FileEntity> archive = documents.oldDocuments ?? [];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      sliver: SliverToBoxAdapter(
        child: Column(
          spacing: 14,
          children: [
            VehicleSection(
              icon: Icons.folder_copy_outlined,
              title: 'Requested Documents',
              count: requested.isEmpty ? null : requested.length,
              child: requested.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.description_outlined,
                      title: 'No requested documents',
                      message:
                          'Documents requested for this trailer will show up here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: requested.length,
                      itemBuilder: (context, index) {
                        final DocumentDto document = requested[index];

                        return VehicleDocumentCard(
                          key: ValueKey(
                            'requested_${document.id ?? document.collectionType}_$index',
                          ),
                          document: document,
                          fileExtensionHelper: fileExtensionHelper,
                          isDeleteEnabled: true,
                          isUploadEnabled: true,
                          onDelete: (_) => controller.onDeleteDocumentCicked(
                            document,
                            false,
                          ),
                          onOpen: () => controller.openFile(document.file),
                          onUpload: () => controller
                              .showUpdateTrailerBottemSheet(context, document),
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trailers',
                          ),
                        );
                      },
                    ),
            ),
            VehicleSection(
              icon: Icons.description_outlined,
              title: 'Trailer Documents',
              count: trailerDocuments.isEmpty ? null : trailerDocuments.length,
              action: VehicleSectionAction(
                label: 'New Document',
                icon: Icons.upload_file_outlined,
                onPressed: () => controller.showNewTrailerBottemSheet(context),
              ),
              child: trailerDocuments.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.folder_off_outlined,
                      title: 'No trailer documents',
                      message:
                          'Documents you upload for this trailer will be listed here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: trailerDocuments.length,
                      itemBuilder: (context, index) {
                        final FileEntity file = trailerDocuments[index];
                        final DocumentDto document = DocumentDto(
                          id: file.id,
                          file: file,
                          collectionName: file.fileName,
                          isUploaded: true,
                          updatedAt: file.updatedAt.toString(),
                        );

                        return VehicleDocumentCard(
                          key: ValueKey('trailer_doc_${file.id ?? index}'),
                          document: document,
                          fileExtensionHelper: fileExtensionHelper,
                          isDeleteEnabled: true,
                          isUploadEnabled: false,
                          onDelete: (_) => controller.onDeleteDocumentCicked(
                            document,
                            true,
                          ),
                          onOpen: () => controller.openFile(document.file),
                          onUpload: null,
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trailers',
                          ),
                        );
                      },
                    ),
            ),
            VehicleSection(
              icon: Icons.inventory_2_outlined,
              title: 'Archive Files',
              count: archive.isEmpty ? null : archive.length,
              child: archive.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No archived files',
                      message: 'Replaced or removed files are kept here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: archive.length,
                      itemBuilder: (context, index) {
                        final FileEntity file = archive[index];
                        final DocumentDto document = DocumentDto(
                          collectionName: file.fileName,
                          file: file,
                          isUploaded: true,
                          updatedAt: file.updatedAt.toString(),
                        );

                        return VehicleDocumentCard(
                          key: ValueKey('archive_${file.id ?? index}'),
                          document: document,
                          fileExtensionHelper: fileExtensionHelper,
                          isDeleteEnabled: false,
                          isUploadEnabled: false,
                          onDelete: (_) => controller.onDeleteDocumentCicked(
                            document,
                            false,
                          ),
                          onOpen: () => controller.openFile(document.file),
                          onUpload: null,
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trailers',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentList extends StatelessWidget {
  const _DocumentList({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          itemBuilder(context, index) ?? const SizedBox.shrink(),
    );
  }
}

class _DocumentsLoadingView extends StatelessWidget {
  const _DocumentsLoadingView();

  @override
  Widget build(BuildContext context) {
    return const VehicleDetailsLoadingView(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 30),
          child: Column(
            spacing: 14,
            children: [
              VehicleSectionSkeleton(
                icon: Icons.folder_copy_outlined,
                title: 'Requested Documents',
                itemHeight: 96,
              ),
              VehicleSectionSkeleton(
                icon: Icons.description_outlined,
                title: 'Trailer Documents',
                itemHeight: 96,
              ),
              VehicleSectionSkeleton(
                icon: Icons.inventory_2_outlined,
                title: 'Archive Files',
                itemHeight: 96,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
