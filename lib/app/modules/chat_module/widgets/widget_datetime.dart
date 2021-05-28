part of 'widgets.dart';

class WidgetDateTime extends StatelessWidget {
  final String dateTime;

  WidgetDateTime({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Text('${DateFormat('d/M/yy').parse(dateTime).isToday() ? 'Today'
        : DateFormat('d/M/yy').parse(dateTime).isYesterday() ? 'Yesterday'
        : DateFormat('d/M/yy').format(DateTime.parse(dateTime))}');
  }
}

