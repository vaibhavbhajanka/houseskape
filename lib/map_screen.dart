import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:permission_handler/permission_handler.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:houseskape/model/search_query.dart';
import 'package:houseskape/repository/property_search_repository.dart';
import 'package:houseskape/constants/property_types.dart';

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
  final Map<String, int> _annotationIndexById = {}; // maps annotation to carousel index
  List<Property> _properties = [];
  Property? _focusProperty;
  bool _clickListenerAttached = false;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _visibleCount = 0;
  Timer? _debounce;
  final _searchRepo = PropertySearchRepository();
  SearchQuery _query = const SearchQuery();
  StreamSubscription<List<Property>>? _propertySub;
  static const List<String> _cities = ["Sikkim", "Gangtok", "Majitar", "Rangpo", "Singtam"];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Property) {
      _focusProperty = arg;
    }
  }

  @override
  void initState() {
    super.initState();
    // nothing to init for dropdown
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map fills the background.
          mapbox.MapWidget(
            key: const ValueKey('mapWidget'),
            cameraOptions: mapbox.CameraOptions(
              center: mapbox.Point(coordinates: mapbox.Position(-98.0, 39.5)),
              zoom: 3.0,
            ),
            onMapCreated: _onMapCreated,
            onCameraChangeListener: _onCameraChanged,
          ),
          // Search bar overlay (M1 – UI only)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _CityDropdownBar(
                      cities: _cities,
                      value: _query.location ?? 'Sikkim',
                      onChanged: (city) {
                        if (city == null) return;
                        setState(() {
                          _query = _query.copyWith(location: city == 'Sikkim' ? null : city);
                        });
                        _subscribeToProperties();
                      },
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _openFilterSheet,
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.tune, color: Color(0xFF25262B)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Carousel
          Positioned(
            left: 0,
            right: 0,
            bottom: 96,
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _properties.length,
                onPageChanged: _onCarouselPageChanged,
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _CarouselCard(property: property),
                  );
                },
              ),
            ),
          ),
          // Availability bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _visibleCount > 0 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -1))],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Spacer(),
                    Text('$_visibleCount places available for rent', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
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

    // Start listening to filtered property stream
    _subscribeToProperties();
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

  void _onCarouselPageChanged(int index) {
    if (index < 0 || index >= _properties.length) return;
    final prop = _properties[index];
    if (prop.lat != null && prop.lng != null) {
      _mapboxMap?.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(coordinates: mapbox.Position(prop.lng!, prop.lat!)),
          zoom: 15,
        ),
        mapbox.MapAnimationOptions(duration: 800),
      );
    }
  }

  void _onCameraChanged(mapbox.CameraChangedEventData data) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _updateVisibleProperties);
  }

  Future<void> _updateVisibleProperties() async {
    if (_mapboxMap == null) return;
    try {
      final cam = await _mapboxMap!.getCameraState();
      final bounds = await _mapboxMap!.coordinateBoundsForCamera(
        mapbox.CameraOptions(center: cam.center, zoom: cam.zoom, bearing: cam.bearing, pitch: cam.pitch),
      );
      final sw = bounds.southwest.coordinates;
      final ne = bounds.northeast.coordinates;
      int cnt = 0;
      for (final p in _properties) {
        if (p.lat == null || p.lng == null) continue;
        if (p.lat! >= sw.lat && p.lat! <= ne.lat && p.lng! >= sw.lng && p.lng! <= ne.lng) {
          cnt++;
        }
      }
      if (mounted) {
        setState(() {
          _visibleCount = cnt;
        });
      }
    } catch (_) {
      // ignore errors (e.g., bounds computation before style loaded)
    }
  }

  void _subscribeToProperties() {
    if (_annotationManager == null) return;
    _propertySub?.cancel();
    _propertySub = _searchRepo.watchProperties(_query).listen((props) async {
      await _refreshPins(props);
    });
  }

  Future<void> _refreshPins(List<Property> props) async {
    _annotationManager?.deleteAll();
    _propertyByAnnotationId.clear();
    _annotationIndexById.clear();

    final coords = <mapbox.Point>[];
    int idx = 0;
    for (final property in props) {
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
      _annotationIndexById[annotation.id] = idx;
      coords.add(mapbox.Point(
          coordinates: mapbox.Position(property.lng!, property.lat!)));
      idx++;
    }

    // Fit camera if needed
    if (_focusProperty == null && coords.isNotEmpty) {
      if (coords.length == 1) {
        await _mapboxMap!.flyTo(
          mapbox.CameraOptions(center: coords.first, zoom: 15),
          mapbox.MapAnimationOptions(duration: 1200),
        );
      } else {
        final minLng = coords.map((p) => p.coordinates.lng).reduce((a, b) => a < b ? a : b);
        final minLat = coords.map((p) => p.coordinates.lat).reduce((a, b) => a < b ? a : b);
        final maxLng = coords.map((p) => p.coordinates.lng).reduce((a, b) => a > b ? a : b);
        final maxLat = coords.map((p) => p.coordinates.lat).reduce((a, b) => a > b ? a : b);
        final centerLng = (minLng + maxLng) / 2;
        final centerLat = (minLat + maxLat) / 2;
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
              center: mapbox.Point(
                  coordinates: mapbox.Position(centerLng, centerLat)),
              zoom: zoom),
          mapbox.MapAnimationOptions(duration: 1200),
        );
      }
    }

    // focus property if provided
    if (_focusProperty != null && _focusProperty!.lat != null && _focusProperty!.lng != null) {
      await _mapboxMap!.flyTo(
        mapbox.CameraOptions(
            center: mapbox.Point(
                coordinates:
                    mapbox.Position(_focusProperty!.lng!, _focusProperty!.lat!)),
            zoom: 15),
        mapbox.MapAnimationOptions(duration: 1200),
      );
      _focusProperty = null;
    }

    // Attach click listener once.
    if (!_clickListenerAttached && _annotationManager != null) {
      _annotationManager!.addOnPointAnnotationClickListener(
        _AnnotationClickListener(onClick: (annotation) {
          final idx = _annotationIndexById[annotation.id];
          if (idx != null) {
            _pageController.animateToPage(idx,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          }
        }),
      );
      _clickListenerAttached = true;
    }

    if (mounted) {
      setState(() {
        _properties = props;
        _updateVisibleProperties();
      });
    }
  }

  void _openFilterSheet() async {
    // Location filter removed per requirement
    int bedrooms = _query.minBedrooms ?? 1; // 1 means Any (>=1)
    int bathrooms = _query.minBathrooms ?? 1;
    String? propertyType = _query.propertyType;
    const List<String> types = kPropertyTypes;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: bedrooms,
                decoration: const InputDecoration(labelText: 'Min Bedrooms'),
                items: [1, 2, 3, 4, 5]
                    .map((b) => DropdownMenuItem(
                          value: b,
                          child: Text(b == 1 ? 'Any' : b.toString()),
                        ))
                    .toList(),
                onChanged: (v) => bedrooms = v ?? 1,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: bathrooms,
                decoration: const InputDecoration(labelText: 'Min Bathrooms'),
                items: [1, 2, 3, 4, 5]
                    .map((b) => DropdownMenuItem(
                          value: b,
                          child: Text(b == 1 ? 'Any' : b.toString()),
                        ))
                    .toList(),
                onChanged: (v) => bathrooms = v ?? 1,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                value: propertyType,
                decoration: const InputDecoration(labelText: 'Property Type'),
                items: [null, ...types]
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t ?? 'Any'),
                        ))
                    .toList(),
                onChanged: (v) => propertyType = v,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, {
                  'bedrooms': bedrooms,
                  'bathrooms': bathrooms,
                  'type': propertyType,
                }),
                child: const Text('Apply'),
              )
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _query = _query.copyWith(
          minBedrooms: result['bedrooms'] as int?,
          minBathrooms: result['bathrooms'] as int?,
          propertyType: result['type'] as String?,
        );
      });
      _subscribeToProperties();
    }
  }

  @override
  void dispose() {
    _propertySub?.cancel();
    _annotationManager?.deleteAll();
    _debounce?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/property-details', arguments: property),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: property.image != null && property.image!.startsWith('http')
                  ? Image.network(property.image!, width: 120, height: double.infinity, fit: BoxFit.cover)
                  : Container(width: 120, color: Colors.grey[300]),
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
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.address ?? '',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.bed_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Flexible(child: Text('${property.bedrooms ?? '-'} Bedroom', style: const TextStyle(fontSize: 11))),
                        const SizedBox(width: 12),
                        const Icon(Icons.bathtub_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Flexible(child: Text('${property.bathrooms ?? '-'} Bathroom', style: const TextStyle(fontSize: 11))),
                      ],
                    ),
                    Text('₹${property.monthlyRent ?? '-'} /month', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
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

class _CityDropdownBar extends StatelessWidget {
  const _CityDropdownBar({required this.cities, required this.value, required this.onChanged, required this.onBack});

  final List<String> cities;
  final String value;
  final ValueChanged<String?> onChanged;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              splashRadius: 20,
              onPressed: onBack,
            ),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  onChanged: onChanged,
                  items: cities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card widget displayed inside bottom carousel PageView.
class _CarouselCard extends StatelessWidget {
  const _CarouselCard({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/property-details', arguments: property),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: property.image != null && property.image!.startsWith('http')
                  ? Image.network(property.image!, width: 120, height: double.infinity, fit: BoxFit.cover)
                  : Container(width: 120, color: Colors.grey[300]),
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
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 2,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.bed_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Flexible(child: Text('${property.bedrooms ?? '-'} Bedroom', style: const TextStyle(fontSize: 11))),
                        const SizedBox(width: 12),
                        const Icon(Icons.bathtub_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Flexible(child: Text('${property.bathrooms ?? '-'} Bathroom', style: const TextStyle(fontSize: 11))),
                      ],
                    ),
                    Text('₹${property.monthlyRent ?? '-'} /month', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
