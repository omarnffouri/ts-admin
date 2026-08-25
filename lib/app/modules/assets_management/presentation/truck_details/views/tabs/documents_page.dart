import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_admin/app/core/helpers/file_helpers/file_extension_helper.dart';

import '../../../../domain/entities/vehicle_details_entity.dart';
import '../../controllers/truck_details_controller.dart';
import '../../../components/vehicle_details/section_empty_state.dart';
import '../../../components/vehicle_details/vehicle_document_card.dart';
import '../../../components/vehicle_details/vehicle_section.dart';
import '../components/truck_picture_tile.dart';

class DocumentsPage extends GetView<TruckDetailsController> {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final Documents? documents = controller.truckDetails.value?.documents;
        final bool isLoading = controller.isLoading.value;

        //
        // first load — nothing to keep on screen yet
        if (isLoading && documents == null) {
          return const _DocumentsLoadingView();
        }

        return VehicleDetailsTabView(
          isLoading: isLoading,
          refreshLabel: 'Refreshing truck documents',
          refreshController: controller.documentsRefreshCtrl,
          onRefresh: controller.init,
          slidableAutoClose: true,
          sliver: documents == null
              ? VehicleDetailsErrorState(
                  title: 'Truck documents unavailable',
                  message: "We couldn't load this truck's documents.",
                  onRetry: controller.init,
                )
              : DocumentsBody(documents: documents),
        );
      },
    );
  }
}

class DocumentsBody extends GetView<TruckDetailsController> {
  const DocumentsBody({super.key, required this.documents});

  final Documents documents;

  @override
  Widget build(BuildContext context) {
    final FileExtensionHelper fileExtensionHelper = FileExtensionHelper();

    final List<DocumentDto> requestedDocuments =
        documents.requestedDocuments ?? [];
    final List<Folder> globalDocuments = documents.globalDocuments ?? [];
    final List<FileEntity> truckDocuments = documents.otherDocuments ?? [];
    final List<FileEntity> truckPictures = documents.truckPictures ?? [];
    final List<FileEntity> archiveFiles = documents.oldDocuments ?? [];

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 14,
          children: [
            //
            // requested documents
            VehicleSection(
              icon: Icons.folder_copy_outlined,
              title: 'Requested Documents',
              count:
                  requestedDocuments.isEmpty ? null : requestedDocuments.length,
              child: requestedDocuments.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.description_outlined,
                      title: 'No requested documents',
                      message:
                          'Documents requested for this truck will show up here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: requestedDocuments.length,
                      itemBuilder: (context, index) {
                        final DocumentDto document = requestedDocuments[index];

                        return VehicleDocumentCard(
                          key: ValueKey(
                            'requested_${document.id ?? document.collectionType}_$index',
                          ),
                          document: document,
                          fileExtensionHelper: fileExtensionHelper,
                          isDeleteEnabled: true,
                          isUploadEnabled: true,
                          onDelete: (_) {
                            controller.onDeleteDocumentCicked(document, false);
                          },
                          onOpen: () => controller.openFile(document.file),
                          onUpload: () => controller.showUpdateTruckBottemSheet(
                              context, document),
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trucks',
                          ),
                        );
                      },
                    ),
            ),

            //
            // global documents
            VehicleSection(
              icon: Icons.public_outlined,
              title: 'Global Documents',
              count: globalDocuments.isEmpty ? null : globalDocuments.length,
              child: globalDocuments.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.public_off_outlined,
                      title: 'No global documents',
                      message:
                          'Company-wide documents shared with this truck appear here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: globalDocuments.length,
                      itemBuilder: (context, index) {
                        final Folder folder = globalDocuments[index];
                        final DocumentDto document = DocumentDto(
                          collectionName: folder.name,
                          collectionType: folder.collectionType,
                          file: folder.file,
                          isUploaded: true,
                          updatedAt: folder.updatedAt,
                        );

                        return VehicleDocumentCard(
                          key: ValueKey('global_${folder.id ?? index}'),
                          document: document,
                          fileExtensionHelper: fileExtensionHelper,
                          isDeleteEnabled: false,
                          isUploadEnabled: false,
                          onDelete: (_) {
                            controller.onDeleteDocumentCicked(document, false);
                          },
                          onOpen: () => controller.openFile(document.file),
                          onUpload: null,
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trucks',
                          ),
                        );
                      },
                    ),
            ),

            //
            // truck documents
            VehicleSection(
              icon: Icons.description_outlined,
              title: 'Truck Documents',
              count: truckDocuments.isEmpty ? null : truckDocuments.length,
              action: VehicleSectionAction(
                label: 'New Document',
                icon: Icons.upload_file_outlined,
                onPressed: () => controller.showNewTruckBottemSheet(context),
              ),
              child: truckDocuments.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.folder_off_outlined,
                      title: 'No truck documents',
                      message:
                          'Documents you upload for this truck will be listed here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: truckDocuments.length,
                      itemBuilder: (context, index) {
                        final FileEntity file = truckDocuments[index];
                        final DocumentDto document = DocumentDto(
                          id: file.id,
                          file: file,
                          collectionName: file.fileName,
                          isUploaded: true,
                          updatedAt: file.updatedAt.toString(),
                        );

                        return VehicleDocumentCard(
                          key: ValueKey('truck_doc_${file.id ?? index}'),
                          document: document,
                          fileExtensionHelper: fileExtensionHelper,
                          isDeleteEnabled: true,
                          isUploadEnabled: false,
                          onDelete: (_) {
                            controller.onDeleteDocumentCicked(document, true);
                          },
                          onOpen: () => controller.openFile(document.file),
                          onUpload: null,
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trucks',
                          ),
                        );
                      },
                    ),
            ),

            //
            // truck pictures
            VehicleSection(
              icon: Icons.photo_library_outlined,
              title: 'Truck Pictures',
              count: truckPictures.isEmpty ? null : truckPictures.length,
              action: VehicleSectionAction(
                label: 'Upload Pictures',
                icon: Icons.add_photo_alternate_outlined,
                onPressed: () =>
                    controller.showUploadPicturesBottemSheet(context),
              ),
              child: truckPictures.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.image_outlined,
                      title: 'No truck pictures',
                      message:
                          'Pictures you upload for this truck will be shown here.',
                      dense: true,
                    )
                  : _TruckPicturesGrid(
                      pictures: truckPictures,
                      onDelete: (FileEntity file) {
                        controller.onDeleteDocumentCicked(
                          DocumentDto(
                            id: file.id,
                            file: file,
                            collectionName: file.fileName,
                            isUploaded: true,
                            updatedAt: file.updatedAt.toString(),
                          ),
                          true,
                        );
                      },
                    ),
            ),

            //
            // archive files
            VehicleSection(
              icon: Icons.inventory_2_outlined,
              title: 'Archive Files',
              count: archiveFiles.isEmpty ? null : archiveFiles.length,
              child: archiveFiles.isEmpty
                  ? const SectionEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No archived files',
                      message: 'Replaced or removed files are kept here.',
                      dense: true,
                    )
                  : _DocumentList(
                      itemCount: archiveFiles.length,
                      itemBuilder: (context, index) {
                        final FileEntity file = archiveFiles[index];
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
                          onDelete: (_) {
                            controller.onDeleteDocumentCicked(document, false);
                          },
                          onOpen: () => controller.openFile(document.file),
                          onUpload: null,
                          onExpirationDate: (date) =>
                              controller.updateDocumentExpiration(
                            id: document.id.toString(),
                            collectionType: document.collectionType ?? '',
                            date: date,
                            modelType: 'trucks',
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

/// Vertical list of document cards inside a section.
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

/// Responsive thumbnail grid of truck pictures.
class _TruckPicturesGrid extends StatelessWidget {
  const _TruckPicturesGrid({required this.pictures, required this.onDelete});

  final List<FileEntity> pictures;
  final void Function(FileEntity) onDelete;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pictures.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final FileEntity picture = pictures[index];

        return TruckPictureTile(
          key: ValueKey('truck_picture_${picture.id ?? index}'),
          picture: picture,
          isDeleteEnabled: true,
          onDelete: () => onDelete(picture),
        );
      },
    );
  }
}

/// Shimmering skeleton mirroring the sections while the first load is in
/// flight.
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 14,
            children: [
              VehicleSectionSkeleton(
                icon: Icons.folder_copy_outlined,
                title: 'Requested Documents',
                itemHeight: 96,
              ),
              VehicleSectionSkeleton(
                icon: Icons.public_outlined,
                title: 'Global Documents',
                itemHeight: 96,
              ),
              VehicleSectionSkeleton(
                icon: Icons.description_outlined,
                title: 'Truck Documents',
                itemHeight: 96,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
