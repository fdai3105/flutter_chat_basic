part of 'utils.dart';

String formatDate(int millisecond) {
  final now = DateTime.now();
  final time = DateTime.fromMillisecondsSinceEpoch(millisecond);
  var sendTime;
  if (time.year < now.year) {
    sendTime = DateFormat.yMMMMd().format(time);
  } else {
    if (time.day == now.day) {
      sendTime = 'Today ' + DateFormat('jm').format(time);
    } else {
      sendTime = DateFormat('MMMMd').add_jm().format(time);
    }
  }
  return sendTime;
}
