part of 'widgets.dart';

class WidgetAvatarChat extends StatelessWidget {
  final List<MyUser> members;

  const WidgetAvatarChat({
    Key? key,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (members.length <= 2) {
      return Container(
        width: 46,
        height: 46,
        child: Stack(
          fit: StackFit.loose,
          children: [
            _buildImage(members[0].avatar!, Alignment.topRight),
            _buildImage(members[1].avatar!, Alignment.bottomLeft),
          ],
        ),
      );
    } else {
      return Container(
        width: 46,
        height: 46,
        child: Stack(
          fit: StackFit.loose,
          children: [
            _buildCount(),
            _buildImage(members[1].avatar!, Alignment.topCenter),
            _buildImage(members[0].avatar!, Alignment.bottomLeft),
          ],
        ),
      );
    }
  }

  Widget _buildImage(String url, AlignmentGeometry alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url,
            height: members.length <= 2 ? 30 : 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCount() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: SizedBox(
          height: 26,
          width: 26,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '+${(members.length - 2)}',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
