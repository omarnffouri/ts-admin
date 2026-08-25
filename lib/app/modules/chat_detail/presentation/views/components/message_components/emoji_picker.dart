import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ts_admin/app/core/resources/themes/light/light_colors.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/controllers/chat_detail_controller.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/tenor/tenor_gif_picker.dart';
import 'package:ts_admin/app/modules/chat_detail/presentation/views/components/tenor/tenor_service.dart';

class EmojiGifPicker extends GetView<ChatDetailController> {
  const EmojiGifPicker({
    super.key,
    required this.textController,
    required this.onPickGif,
    this.height = 250,
    this.isDark = false,
  });

  final TextEditingController textController;
  final Function(TenorGif gif) onPickGif;
  final double height;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cfg = Config(
      emojiViewConfig: const EmojiViewConfig(
        columns: 7,
        emojiSizeMax: 24,
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        recentsLimit: 30,
        replaceEmojiOnLimitExceed: false,
        noRecents: Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        loadingIndicator: SizedBox.shrink(),
        buttonMode: ButtonMode.MATERIAL,
      ),
      categoryViewConfig: CategoryViewConfig(
        initCategory: Category.RECENT,
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        recentTabBehavior: RecentTabBehavior.RECENT,
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
      ),
      skinToneConfig: const SkinToneConfig(
        enabled: true,
        dialogBackgroundColor: Colors.white,
        indicatorColor: Colors.grey,
      ),
      checkPlatformCompatibility: true,
    );

    // Outer EmojiPicker just provides the customWidget hook.
    return EmojiPicker(
      textEditingController: textController,
      onBackspacePressed: () {},

      // ---- THIS is the important part ----
      customWidget:
          (Config _, EmojiViewState __, void Function()? onBackspace) {
        return _EmojiGifTabbedView(
          controller: controller,
          height: height,
          textController: textController,
          onBackspace: onBackspace,
          emojiConfig: cfg,
          onPickGif: onPickGif,
          isDark: isDark,
        );
      },

      // The config here is irrelevant because we override the whole UI above.
      config: cfg,
    );
  }
}

class _EmojiGifTabbedView extends StatefulWidget {
  const _EmojiGifTabbedView({
    required this.height,
    required this.textController,
    required this.onBackspace,
    required this.emojiConfig,
    required this.onPickGif,
    required this.isDark,
    required this.controller,
  });

  final double height;
  final ChatDetailController controller;
  final TextEditingController textController;
  final void Function()? onBackspace;
  final Config emojiConfig;
  final Function(TenorGif gif) onPickGif;
  final bool isDark;

  @override
  State<_EmojiGifTabbedView> createState() => _EmojiGifTabbedViewState();
}

class _EmojiGifTabbedViewState extends State<_EmojiGifTabbedView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isDark ? const Color(0xFF121212) : const Color(0xFFF7F7F7),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TabBar(
              controller: _tabs,
              labelColor: AppColorsLight.mainColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColorsLight.mainColor,
              tabs: const [
                Tab(icon: Icon(Icons.emoji_emotions_outlined)),
                Tab(icon: Icon(Icons.gif_box_outlined)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                EmojiPicker(
                  textEditingController: widget.textController,
                  onBackspacePressed: widget.onBackspace ?? () {},
                  config: widget.emojiConfig,
                ),
                TenorGifPicker(
                  onTap: widget.controller.showGifPicker,
                  onSelected: (gif) {
                    widget.controller.closeKeyboardAndPicker();
                    widget.controller.sendGifMessage(gif);
                  },
                  service: widget.controller.tenorService,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
