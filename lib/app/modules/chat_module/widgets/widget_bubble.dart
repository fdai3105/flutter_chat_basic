part of 'widgets.dart';

class WidgetBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String dateTime;
  final int type;
  final String? avatar;

  WidgetBubble({
    required this.message,
    required this.isMe,
    required this.dateTime,
    required this.type,
    this.avatar,
  });

  Widget build(BuildContext context) {
    final uri = Uri.tryParse(message);
    if (uri != null && type != 1 && type != 2) {
      if (uri.isAbsolute) {
        return _WidgetUrlPreview(
          url: message,
          avatar: avatar,
          dateTime: dateTime,
          isMe: isMe,
        );
      }
    }

    if (type == 0) {
      return _buildTextBubble();
    } else if (type == 1) {
      return _buildImageBubble(context);
    } else if (type == 2) {
      return _buildStickerBubble(context);
    } else if (type == 3) {
      List<String> dataList = message.split(' ');
      double lat = double.parse(dataList[0]);
      double long = double.parse(dataList[1]);
      return _buildMapviewBubble(context, lat, long);
    } else {
      return SizedBox();
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
                              onTap: () {
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
                        WidgetAvatar(
                          url: avatar,
                          isActive: false,
                          size: 45,
                        ),
                        SizedBox(width: 5),
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
                              onTap: () {
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
                        WidgetAvatar(
                          url: avatar,
                          isActive: false,
                          size: 45,
                        ),
                        SizedBox(width: 5),
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

  Widget _buildStickerBubble(BuildContext context) {
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
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
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
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WidgetAvatar(
                          url: avatar,
                          isActive: false,
                          size: 45,
                        ),
                        SizedBox(width: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: message,
                            width: 200,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
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

  Widget _buildMapviewBubble(BuildContext context, double latitude, double longitude) {
    MarkerId markerId1 = MarkerId("1");
    return Container(
      margin: EdgeInsets.all(10),
      child: isMe
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
                SizedBox(width: 5),
                SizedBox(
                  height: 150,
                  width: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(isMe ? 0 : 15),
                      bottomLeft: Radius.circular(isMe ? 0 : 15),
                    ),
                    child: Stack(
                      children: [
                        GoogleMap(
                          markers: {
                            Marker(
                              markerId: markerId1,
                              position: LatLng(latitude, longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueAzure),
                            )
                          },
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude, longitude),
                            zoom: 11,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () =>
                                _showMap(context, latitude, longitude),
                            child: Text('View'),
                          ),
                        )
                      ],
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
                  size: 45,
                ),
                SizedBox(width: 5),
                SizedBox(
                  height: 150,
                  width: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(isMe ? 0 : 15),
                      bottomLeft: Radius.circular(isMe ? 0 : 15),
                    ),
                    child: Stack(
                      children: [
                        GoogleMap(
                          markers: {
                            Marker(
                              markerId: markerId1,
                              position: LatLng(latitude, longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueAzure),
                            )
                          },
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude, longitude),
                            zoom: 11,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () =>
                                _showMap(context, latitude, longitude),
                            child: Text('View'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    dateTime,
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
              ],
            ),
    );
  }

  _showMap(BuildContext context, double latitude, double longitude) {
    MarkerId markerId1 = MarkerId("1");
    showModalBottomSheet(
        context: context,
        builder: (context) => Scaffold(
              body: Container(
                padding: EdgeInsets.all(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude), zoom: 11),
                  markers: {
                    Marker(
                      markerId: markerId1,
                      position: LatLng(latitude, longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure),
                    )
                  },
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () => Get.back(),
                child: Icon(Icons.arrow_back),
              ),
            ));
  }
}

class _WidgetUrlPreview extends StatefulWidget {
  final String url;
  final bool isMe;
  final String dateTime;
  final String? avatar;

  const _WidgetUrlPreview({
    Key? key,
    required this.isMe,
    required this.url,
    required this.dateTime,
    required this.avatar,
  }) : super(key: key);

  @override
  _WidgetUrlPreviewState createState() => _WidgetUrlPreviewState();
}

class _WidgetUrlPreviewState extends State<_WidgetUrlPreview> {
  PreviewData? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.only(
        left: widget.isMe ? 40 : 0,
        right: widget.isMe ? 0 : 40,
      ),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [widget.isMe ? _buildIsMe() : _buildNotMe()],
      ),
    );
  }

  Widget _buildIsMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            widget.dateTime,
            style: TextStyle(color: Colors.black26),
          ),
        ),
        _buildContent()
      ],
    );
  }

  Widget _buildNotMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WidgetAvatar(
          url: widget.avatar,
          isActive: false,
          size: 45,
        ),
        SizedBox(width: 5),
        _buildContent(),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            widget.dateTime,
            style: TextStyle(color: Colors.black26),
          ),
        ),
      ],
    );
  }

  Flexible _buildContent() {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
          bottomRight: Radius.circular(widget.isMe ? 0 : 15),
          bottomLeft: Radius.circular(!widget.isMe ? 0 : 15),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isMe ? Colors.green : Colors.grey.shade200,
          ),
          child: LinkPreview(
            enableAnimation: true,
            width: double.infinity,
            text: widget.url,
            linkStyle: TextStyle(
              color: widget.isMe ? Colors.white : Colors.black87,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            onPreviewDataFetched: (data) {
              setState(() {
                this.data = data;
              });
            },
            previewData: data,
          ),
        ),
      ),
    );
  }

}

//hu
