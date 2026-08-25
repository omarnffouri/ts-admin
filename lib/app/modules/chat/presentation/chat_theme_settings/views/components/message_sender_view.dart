part of '../chat_theme_preview_view.dart';

class _MessageSenderView extends StatelessWidget {
  const _MessageSenderView();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        //
        // actual message container  view
        Container(
          constraints: BoxConstraints(maxWidth: Get.width * 0.75),
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? AppColorsDark.chatSenderColor
                : AppColorsLight.chatSenderColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //
              //
              // text view
              Container(
                constraints: BoxConstraints(minWidth: Get.width * 0.13),
                child: ReadMoreText(
                  "Yep, just wrapped it up. Took longer than I thought. Finally done though!",
                  trimLines: 10, // Number of lines to initially display
                  colorClickableText: Colors.blue, // Customize link color
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '... Read more',
                  trimExpandedText: ' Read less',
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? AppColorsDark.chatSenderTextColor
                        : AppColorsLight.chatSenderTextColor,
                    fontSize: 17,
                    fontFamily: 'Helvetica',
                  ),
                  mention: null,
                  messageSenderId: 0,
                ),
              ),

              //
              //
              const SizedBox(
                height: 2,
              ),

              //
              //
              // message time and recipt
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //
                  // message time view
                  Text(
                    DateFormat('h:mm a').format(DateTime.now()),
                    style: TextStyle(
                      color: Get.isDarkMode
                          ? AppColorsDark.chatSenderTimeColor
                          : AppColorsLight.chatSenderTimeColor,
                      fontSize: 10,
                    ),
                  ),

                  //
                  //
                  const SizedBox(
                    width: 2,
                  ),

                  //
                  // recipt icon
                  Image.asset(
                    Assets.chatIcons.readIcon.path,
                    width: 15,
                    height: 15,
                  )
                ],
              )
            ],
          ),
        ),

        //
        //
        // user image view
        CircleAvatar(
          radius: 10,
          backgroundImage: AssetImage(Assets.images.person.path),
        ).marginSymmetric(horizontal: 5),
      ],
    );
  }
}
