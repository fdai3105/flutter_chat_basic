part of 'widgets.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      body: Hero(
        tag: url,
        child: Container(
          child: PhotoView(
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            imageProvider: CachedNetworkImageProvider(url),
          ),
        ),
      ),
    );
  }
}
