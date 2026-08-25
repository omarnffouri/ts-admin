part of 'storage_drive_loading_view.dart';

class RootResourcesLoadingView extends GetView<StorageDriveController> {
  const RootResourcesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: Column(
        children: [
          //
          //
          // files, folder header uploaded
          Row(
            children: [
              //
              // resources heading
              Text(
                "Resources",
                style: theme.textTheme.headlineSmall,
              ),

              const Spacer(),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.grid_view_rounded,
                  size: 25,
                ),
              ),

              //
              //
              // view all button
              TextButton(
                onPressed: () {
                  //
                },
                child: const Text("See all"),
              )
            ],
          ).marginOnly(left: 14, right: 8, top: 14),

          //
          //
          // files and folders view
          Expanded(
            child: controller.isGridView
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      mainAxisExtent: 100,
                    ),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return _FileFolderGridItemLoadingView(
                        index: index,
                      );
                    },
                  )
                : ListView.separated(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return _FileFolderListItemLoadingView(
                        index: index,
                      ).marginOnly(bottom: index == 14 ? 50 : 0);
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                        color: Colors.grey.applyOpacity(0.2),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FileFolderGridItemLoadingView extends StatelessWidget {
  final int index;
  const _FileFolderGridItemLoadingView({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final isFile = index % 2 == 0;

    return Container(
      margin: EdgeInsets.only(
        left: index % 2 == 0 ? 14 : 0,
        right: index % 2 != 0 ? 14 : 0,
      ),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.applyOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //
          //
          // file details
          Row(
            children: [
              //
              //
              // file icon
              Icon(
                isFile ? Icons.insert_drive_file_rounded : Icons.folder_rounded,
                size: 30,
              ).marginOnly(right: 5),

              //
              //
              // file name
              Expanded(
                child: Text(
                  isFile ? "My File" : "My Folder",
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          //
          //
          // file size
          Text(
            isFile ? "0.0 KB" : "0 Resources",
            style: textTheme.labelSmall,
          ),

          //
          //
          // modified at time
          Text(
            "MMM/dd/YYYY at 00:00 AM",
            style: textTheme.labelSmall,
            maxLines: 1,
            textAlign: TextAlign.end,
          ),

          //
          //
          // owner name or shared with count
          if (index == 0 || index == 1)
            Row(
              children: [
                //
                //
                Text(
                  index == 0 ? "Shared with" : "Shared by",
                  style: textTheme.bodySmall,
                ),

                //
                //
                Expanded(
                  child: Text(
                    index == 0 ? " 0 peoples" : " XYZ",
                    style: textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                //
                //
                // share icon
                if (index == 0 || index == 1)
                  RotatedBox(
                    quarterTurns: index == 0 ? 3 : 1,
                    child: const Icon(
                      Icons.share_rounded,
                      size: 20,
                    ).marginOnly(left: 5),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FileFolderListItemLoadingView extends StatelessWidget {
  final int index;
  const _FileFolderListItemLoadingView({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final isFile = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(
      //     color: Colors.grey.applyOpacity(0.5),
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          //  folder details
          Row(
            children: [
              //
              //
              //  folder icon
              Icon(
                isFile ? Icons.insert_drive_file_rounded : Icons.folder_rounded,
                size: 30,
              ).marginOnly(right: 5),

              //
              //
              // folder name
              Expanded(
                child: Text(
                  isFile ? "My File" : "My Folder",
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              //
              //
              // share icon
              if (index == 0 || index == 1)
                RotatedBox(
                  quarterTurns: index == 0 ? 3 : 1,
                  child: const Icon(
                    Icons.share_rounded,
                    size: 20,
                  ).marginOnly(left: 5),
                ),
            ],
          ),

          //
          //
          // number of resources and modified date
          Row(
            children: [
              //
              //
              // number of resources
              Expanded(
                child: Text(
                  isFile ? "0.0 KB" : "0 Resources",
                  style: textTheme.labelSmall,
                ),
              ),

              //
              //
              //
              // last modified date time
              if (index != 0 && index != 1)
                Expanded(
                  child: Text(
                    "MMM/dd/YYYY at 00:00 AM",
                    style: textTheme.labelSmall,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                  ),
                )
            ],
          ),

          //
          //
          // share and time view
          if (index == 0 || index == 1)
            Row(
              children: [
                //
                //
                // owner name or shared with count
                if (index == 0 || index == 1)
                  Expanded(
                    child: Row(
                      children: [
                        //
                        //
                        Text(
                          index == 0 ? "Shared with" : "Shared by",
                          style: textTheme.bodySmall,
                        ),

                        //
                        //
                        Expanded(
                          child: Text(
                            index == 0 ? " 0 peoples" : " XYZ",
                            style: textTheme.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                //
                //
                //
                // last modified date time
                Expanded(
                  child: Text(
                    "MMM/dd/YYYY at 00:00 AM",
                    style: textTheme.labelSmall,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
