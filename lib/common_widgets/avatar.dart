import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String photoUrl;
  final double radius;

  const Avatar({Key key, @required this.photoUrl, @required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black54,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null ? Icon(Icons.camera_alt) : null,
      ),
    );
  }
}
