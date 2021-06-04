part of 'widgets.dart';

class WidgetBubble extends GetView<ChatController> {
  final bool isMe;
  final String message;
  final String dateTime;
  final int type;

  WidgetBubble({
    required this.message,
    required this.isMe,
    required this.dateTime,
    required this.type,
  });

  Widget build(BuildContext context) {
    if (type == 0) {
      return _buildTextBubble();
    } else {
      return _buildImageBubble(context);
    }
  }

  Widget _buildTextBubble() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isMe
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            dateTime,
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.green : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(isMe ? 0 : 15),
                                bottomLeft: Radius.circular(!isMe ? 0 : 15),
                              ),
                            ),
                            child: SelectableText(
                              message,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                              ),
                              onTap: (){
                                Clipboard.setData(ClipboardData(text: message));
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.green : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(isMe ? 0 : 15),
                                bottomLeft: Radius.circular(!isMe ? 0 : 15),
                              ),
                            ),
                            child: SelectableText(
                              message,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                              ),
                              onTap: (){
                                Clipboard.setData(ClipboardData(text: message));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            dateTime,
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildImageBubble(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isMe
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            dateTime,
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                        Hero(
                          tag: message,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => FullPhoto(url: message));
                              },
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                  width: 200,
                                  height: 200,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'assets/images/img_not_available.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: message,
                                width: 200,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Hero(
                          tag: message,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => FullPhoto(url: message));
                              },
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                  width: 200,
                                  height: 200,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'assets/images/img_not_available.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: message,
                                width: 200,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            dateTime,
                            style: TextStyle(color: Colors.black26),
                          ),
                        ),
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }
}
