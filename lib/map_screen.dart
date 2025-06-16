import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _annotationManager;
  Uint8List? _pinImage;
  final Map<String, Property> _propertyByAnnotationId = {};
  Property? _focusProperty;
  bool _clickListenerAttached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Property) {
      _focusProperty = arg;
    }
  }

  @override
  void dispose() {
    _annotationManager?.deleteAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff25262b)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: mapbox.MapWidget(
        key: const ValueKey('mapWidget'),
        cameraOptions: mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(-98.0, 39.5)),
          zoom: 3.0,
        ),
        onMapCreated: _onMapCreated,
      ),
    );
  }

  void _onMapCreated(mapbox.MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted && _mapboxMap != null) {
      await _mapboxMap!.location.updateSettings(mapbox.LocationComponentSettings(
        enabled: true,
      ));
    }

    // create annotation manager
    _annotationManager = await _mapboxMap!.annotations.createPointAnnotationManager();

    // Load pin image once
    if (_pinImage == null) {
      final bytes = await rootBundle.load('assets/images/pin.png');
      _pinImage = bytes.buffer.asUint8List();
    }

    // listen to properties stream and add pins
    FirebaseFirestore.instance.collection('properties').snapshots().listen((snapshot) async {
      _annotationManager?.deleteAll();
      final coords = <mapbox.Point>[];
      for (final doc in snapshot.docs) {
        final property = Property.fromMap(doc.data(), id: doc.id);

        // Skip properties without valid coordinates. Some older records may
        // have nulls or 0/0 which would throw the camera way off.
        if (property.lat == null ||
            property.lng == null ||
            (property.lat!.abs() < 0.0001 && property.lng!.abs() < 0.0001)) {
          continue;
        }

        final annotation = await _annotationManager!.create(
          mapbox.PointAnnotationOptions(
            geometry: mapbox.Point(
                coordinates: mapbox.Position(property.lng!, property.lat!)),
            image: _pinImage!,
            iconSize: 2.0,
          ),
        );
        _propertyByAnnotationId[annotation.id] = property;
        coords.add(mapbox.Point(
            coordinates: mapbox.Position(property.lng!, property.lat!)));
      }

      // Fit camera to markers if we have at least one and no specific focus.
      if (_focusProperty == null && coords.isNotEmpty) {
        if (coords.length == 1) {
          // Single marker – zoom in closely.
          await _mapboxMap!.flyTo(
            mapbox.CameraOptions(
              center: coords.first,
              zoom: 15,
            ),
            mapbox.MapAnimationOptions(duration: 1200),
          );
        } else {
          // Multiple markers – compute bounds and center between them.
          final minLng = coords.map((p) => p.coordinates.lng).reduce((a, b) => a < b ? a : b);
          final minLat = coords.map((p) => p.coordinates.lat).reduce((a, b) => a < b ? a : b);
          final maxLng = coords.map((p) => p.coordinates.lng).reduce((a, b) => a > b ? a : b);
          final maxLat = coords.map((p) => p.coordinates.lat).reduce((a, b) => a > b ? a : b);

          final centerLng = (minLng + maxLng) / 2;
          final centerLat = (minLat + maxLat) / 2;

          // Heuristic zoom based on span – keeps all markers in view for typical city-level spreads.
          final span = math.max((maxLat - minLat).abs(), (maxLng - minLng).abs());
          double zoom;
          if (span < 0.01) {
            zoom = 13;
          } else if (span < 0.1) {
            zoom = 11;
          } else if (span < 1) {
            zoom = 8;
          } else if (span < 5) {
            zoom = 6;
          } else {
            zoom = 4;
          }

          await _mapboxMap!.flyTo(
            mapbox.CameraOptions(
              center: mapbox.Point(coordinates: mapbox.Position(centerLng, centerLat)),
              zoom: zoom,
            ),
            mapbox.MapAnimationOptions(duration: 1200),
          );
        }
      }

      // If a particular property was requested, fly directly to it
      if (_focusProperty != null && _focusProperty!.lat != null && _focusProperty!.lng != null) {
        await _mapboxMap!.flyTo(
          mapbox.CameraOptions(
            center: mapbox.Point(coordinates: mapbox.Position(_focusProperty!.lng!, _focusProperty!.lat!)),
            zoom: 15,
          ),
          mapbox.MapAnimationOptions(duration: 1200),
        );
        _focusProperty = null; // ensure this runs only once
      }

      // Avoid adding the click listener multiple times.
      if (!_clickListenerAttached && _annotationManager != null) {
        _annotationManager?.addOnPointAnnotationClickListener(
          _AnnotationClickListener(onClick: (annotation) {
            final prop = _propertyByAnnotationId[annotation.id];
            if (prop != null) {
              _showPropertySheet(prop);
            }
          }),
        );
        _clickListenerAttached = true;
      }
    });
  }

  void _showPropertySheet(Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: _PropertyCard(property: property),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFFFFFFFF),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/property-details', arguments: property);
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: property.image != null && property.image!.startsWith('http')
                    ? Image.network(property.image!, width: 140, height: 140, fit: BoxFit.cover)
                    : Container(width: 140, height: 140, color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property.adTitle ?? 'Property',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.address ?? '',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.bed_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${property.bedrooms ?? '-'} Bedroom', style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 12),
                          const Icon(Icons.bathtub_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${property.bathrooms ?? '-'} Bathroom', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Text('₹${property.monthlyRent ?? '-'} /month', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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

class _AnnotationClickListener extends mapbox.OnPointAnnotationClickListener {
  _AnnotationClickListener({required this.onClick});

  final void Function(mapbox.PointAnnotation annotation) onClick;

  @override
  void onPointAnnotationClick(mapbox.PointAnnotation annotation) {
    onClick(annotation);
  }
}
