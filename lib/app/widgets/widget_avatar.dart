part of 'widgets.dart';

class WidgetAvatar extends StatelessWidget {
  final String? url;
  final bool showDot;
  final bool? isActive;
  final double? size;

  const WidgetAvatar({
    Key? key,
    required this.url,
    this.showDot = false,
    this.isActive,
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
          showDot ? _buildDot() : SizedBox(),
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
          color: isActive! ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: SizedBox(
        height: 48,
        width: 48,
        child: ClipOval(
          child: url == null
              ? Image.asset('assets/images/place_avatar.png')
              : CachedNetworkImage(
                  imageUrl: url!,
                  placeholder: (_, url) {
                    return Image.asset('assets/images/place_avatar.png');
                  },
                  errorWidget: (_, url, widget) {
                    return Image.asset('assets/images/place_avatar.png');
                  },
                ),
        ),
      ),
    );
  }
}
