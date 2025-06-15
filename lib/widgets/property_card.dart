import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/property_model.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;
  final double? width;
  final double borderRadius;
  final double elevation;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.width,
    this.borderRadius = 12.0,
    this.elevation = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xfffcf9f4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        elevation: elevation,
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          width: width,
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: property.image != null && property.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: property.image!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/images/house1.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    right: 12.0,
                    bottom: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        property.adTitle ?? 'No Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1B3359),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (property.location != null &&
                          property.location!.isNotEmpty)
                        Text(
                          property.location!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff949494),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      if (property.address != null &&
                          property.address!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xff949494),
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                property.address!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff949494),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            size: 16,
                            color: Color(0xFF1B3359),
                          ),
                          Text(
                            '${property.monthlyRent?.toString() ?? '-'} / month',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B3359),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
