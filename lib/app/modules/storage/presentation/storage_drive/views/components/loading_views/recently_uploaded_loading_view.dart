part of 'storage_drive_loading_view.dart';

class RecentlyUploadedLoadingView extends StatelessWidget {
  const RecentlyUploadedLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white30,
      child: Column(
        children: [
          //
          //
          // recently uploaded
          Row(
            children: [
              //
              // title
              Text(
                "Recently Uploaded",
                style: textTheme.headlineSmall,
              ),

              const Spacer(),
            ],
          ).marginOnly(left: 14, right: 8, top: 14),

          //
          //
          // items list
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return _RecentlyUploadedItemLoadingView(
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentlyUploadedItemLoadingView extends StatelessWidget {
  final int index;
  const _RecentlyUploadedItemLoadingView({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final isFile = (index % 2) == 0;
    return Container(
      width: 200,
      margin: EdgeInsets.only(left: index == 0 ? 14 : 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.applyOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          //
          // file folder icon
          Row(
            children: [
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
          // number of resources
          Text(
            isFile ? "0.0 KB" : "0 Resources",
            style: textTheme.labelSmall,
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

          //
          //
          // modified at time
          if (index > 1)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last modified",
                  style: textTheme.bodySmall,
                ),

                //
                //
                // modified date time
                Expanded(
                  child: Text(
                    "MMM/dd/YYYY \n00:00 AM",
                    style: textTheme.labelSmall,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
