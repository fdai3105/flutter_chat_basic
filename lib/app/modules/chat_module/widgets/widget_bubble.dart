part of 'widgets.dart';

class WidgetBubble extends StatelessWidget {
  final bool isMe;
  final String? avatar;
  final String message;
  final String dateTime;

  WidgetBubble({
    required this.message,
    required this.isMe,
    required this.dateTime,
    required this.avatar,
  });

  Widget build(BuildContext context) {
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
                        Container(
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
                          child: Text(
                            message,
                            textAlign: isMe ? TextAlign.end : TextAlign.start,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WidgetAvatar(
                          url: avatar,
                          isActive: false,
                          size: 40,
                        ),
                        SizedBox(width: 5),
                        Container(
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
                          child: Text(
                            message,
                            textAlign: isMe ? TextAlign.end : TextAlign.start,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
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
