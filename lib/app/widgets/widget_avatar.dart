part of 'widgets.dart';

class WidgetAvatar extends StatelessWidget {
  final String? url;
  final bool isActive;
  final double? size;

  const WidgetAvatar({
    Key? key,
    required this.url,
    required this.isActive,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          _buildAvatar(),
          _buildDot(),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Positioned(
      bottom: 2,
      right: 2,
      child: Container(
        height: 14,
        width: 14,
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: ClipOval(
        child: url == null ? Image.asset('') : Image.network(url!),
      ),
    );
  }
}
