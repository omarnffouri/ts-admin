part of '../chat_theme_preview_view.dart';

class _MessageReceiverView extends StatelessWidget {
  const _MessageReceiverView();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        //
        // user image view
        CircleAvatar(
          radius: 10,
          backgroundImage: AssetImage(Assets.images.person.path),
        ).marginSymmetric(horizontal: 5),

        //
        //
        // actual message container  view
        Container(
          constraints: BoxConstraints(maxWidth: Get.width * 0.75),
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? AppColorsDark.chatReciverColor
                : AppColorsLight.chatReciverColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //
                  // building message text
                  Container(
                    constraints: BoxConstraints(minWidth: Get.width * 0.10),
                    child: ReadMoreText(
                      "Hey! How’s it going? Did you finish that task?",
                      trimLines: 10, // Number of lines to initially display
                      colorClickableText: Colors.blue, // Customize link color
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '... Read more',
                      trimExpandedText: ' Read less',
                      style: const TextStyle(
                        color: AppColorsLight.chatReciverTextColor,
                        fontSize: 17,
                      ),
                      mention: null,
                      messageSenderId: 0,
                    ),
                  )
                ],
              ),

              //
              //
              // message time view
              Text(
                DateFormat('h:mm a').format(DateTime.now()),
                style: const TextStyle(
                  color: AppColorsLight.chatReciverTimeColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
