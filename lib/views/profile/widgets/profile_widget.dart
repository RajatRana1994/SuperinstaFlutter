import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';

class ProfileWidget extends StatelessWidget {
  final String image;

  final String title;

  final Function onTap;

  const ProfileWidget({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            image.isNotEmpty
                ? Image(image: AssetImage(image), height: 24, width: 24)
                : Container(height: 24, width: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppStyles.font700_18().copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
