part of 'widgets.dart';

class WidgetInputField extends GetView<ChatController> {
  final TextEditingController textEditingController;
  final Function()? onSubmit;
  final Function()? sendIcon;
  final Function()? sendImage;
  final Function()? sendSticker;
  final Function()? sendLocation;
  final bool isKeyboardVisible;
  final bool isEmojiVisible;

  WidgetInputField({
    Key? key,
    required this.textEditingController,
    this.onSubmit,
    this.sendIcon,
    this.sendImage,
    this.sendSticker,
    this.sendLocation,
    required this.isKeyboardVisible,
    required this.isEmojiVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GetX<ChatController>(
          builder: (_) {
            return Visibility(
                visible: controller.showMore,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: sendImage,
                      icon: Icon(
                        Icons.image,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: sendSticker,
                      icon: Icon(
                        Icons.face,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: sendIcon,
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: sendLocation,
                      icon: Icon(
                        Icons.add_location,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ));
          },
        ),
        GetX<ChatController>(
          builder: (_) {
            return IconButton(
                icon: Icon(
                  controller.showMore
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios,
                  color: Colors.green,
                ),
                onPressed: () {
                  controller.showMore = !controller.showMore;
                });
          },
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding:
                const EdgeInsets.only(top: 5, left: 15, bottom: 5, right: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onSubmit,
                  icon: Icon(
                    Icons.send,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
