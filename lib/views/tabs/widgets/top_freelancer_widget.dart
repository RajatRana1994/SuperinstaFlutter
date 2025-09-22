import 'package:flutter/material.dart';

class TopFreelancerWidget extends StatelessWidget {
  final String name;

  final String profilePic;

  final String price;

  final String currency;

  final String rating;

  final bool isFav;
  final Function onTap;

  const TopFreelancerWidget({
    super.key,
    required this.name,
    required this.profilePic,
    required this.price,
    required this.currency,
    required this.rating,
    required this.isFav,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 140,
        margin: EdgeInsets.only(right: 12),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Green background section (halfway up avatar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 80,
              // adjust this to match avatar overlap
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 36,
                  left: 8,
                  right: 8,
                  bottom: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.orange,
                          child: Text(
                            '₦',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$price/hr',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Black circle avatar (overlapping green section)
            Positioned(
              top: 52, // so half is over white, half over green
              left: 40,
              child:
              profilePic.isEmpty
                  ? Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image(
                  image: NetworkImage(profilePic),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Icons
            Positioned(
              top: 8,
              left: 8,
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 18,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  Text(rating.toString(), style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 2),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
