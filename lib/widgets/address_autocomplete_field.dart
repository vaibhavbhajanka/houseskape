import 'dart:async';

import 'package:flutter/material.dart';
import 'package:houseskape/repository/google_places_repository.dart';

class AddressSuggestion {
  AddressSuggestion({required this.title, required this.subtitle, required this.lat, required this.lng, this.placeId});

  final String title;
  final String subtitle;
  final double lat;
  final double lng;
  final String? placeId;
}

class AddressAutocompleteField extends StatefulWidget {
  const AddressAutocompleteField({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.googleApiKey,
  });

  final TextEditingController controller;
  final void Function(AddressSuggestion) onSelected;
  final String googleApiKey;

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<AddressSuggestion> _suggestions = [];
  Timer? _debounce;
  late GooglePlacesRepository _repo;
  late FocusNode _focusNode;
  // When true, the next controller change is ignored to prevent triggering
  // another autosuggest call after a user taps a suggestion.
  bool _ignoreNextChange = false;

  @override
  void initState() {
    super.initState();
    _repo = GooglePlacesRepository(widget.googleApiKey);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _debounce?.cancel();
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }
void _onChanged() {
  if (!_focusNode.hasFocus) return;

  if (_ignoreNextChange) {
    _ignoreNextChange = false;
    return;
  }

  final query = widget.controller.text.trim();

  // If the dropdown is already showing the same suggestions as current input, skip re-trigger
  if (_suggestions.isNotEmpty && _suggestions.first.title == query) {
    return;
  }

  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () async {
    List<AddressSuggestion> list = [];
    try {
      if (query.length < 3) {
        setState(() => _suggestions = []);
        _removeOverlay();
        return;
      }
      final preds = await _repo.autocomplete(query, limit: 5);
      list = preds.map((p) {
        return AddressSuggestion(
          title: p.description,
          subtitle: '',
          lat: 0.0,
          lng: 0.0,
          placeId: p.placeId,
        );
      }).toList();
    } catch (_) {}

    if (!mounted) return;
    setState(() => _suggestions = list);
    _showOverlay();
  });
}

  // void _onChanged() {
  //   // Only trigger autocomplete while the field is actively focused. If we
  //   // programmatically change the text after a user selection (and unfocus the
  //   // field), this prevents a second dropdown that only mirrors the current
  //   // text from re-appearing.
  //   if (!_focusNode.hasFocus) return;

  //   if (_ignoreNextChange) {
  //     _ignoreNextChange = false;
  //     return;
  //   }

  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () async {
  //     List<AddressSuggestion> list = [];
  //     try {
  //       final query = widget.controller.text.trim();
  //       if (query.length < 3) {
  //         setState(() => _suggestions = []);
  //         _removeOverlay();
  //         return;
  //       }
  //       final preds = await _repo.autocomplete(query, limit: 5);
  //       list = preds.map((p) {
  //         return AddressSuggestion(
  //           title: p.description,
  //           subtitle: '',
  //           lat: 0.0,
  //           lng: 0.0,
  //           placeId: p.placeId,
  //         );
  //       }).toList();
  //     } catch (_) {}

  //     if (!mounted) return;
  //     setState(() => _suggestions = list);
  //     _showOverlay();
  //   });
  // }

  void _showOverlay() {
    _removeOverlay();
    if (_suggestions.isEmpty) return;
    final overlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width - 40, // assuming padding 20
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 56),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final s = _suggestions[index];
                  return ListTile(
                    title: Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: s.subtitle.isNotEmpty
                        ? Text(s.subtitle,
                            maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))
                        : null,
                    onTap: () async {
                      // Prevent a previously scheduled debounce from firing
                      _debounce?.cancel();

                      _ignoreNextChange = true;

                      // Compose a full address ("Place, Address")
                      final fullAddress = (s.title.isNotEmpty && s.subtitle.isNotEmpty)
                          ? '${s.title}, ${s.subtitle}'
                          : (s.title.isNotEmpty ? s.title : s.subtitle);

                      widget.controller.text = fullAddress;

                      var selected = s;
                      if (s.lat == 0.0 && s.lng == 0.0 && s.placeId != null) {
                        try {
                          final details = await _repo.getDetails(s.placeId!);
                          selected = AddressSuggestion(
                            title: details.address,
                            subtitle: '',
                            lat: details.lat,
                            lng: details.lng,
                            placeId: s.placeId,
                          );
                        } catch (_) {}
                      }

                      // Unfocus the text field to dismiss the keyboard and ensure the overlay closes
                      _focusNode.unfocus();

                      widget.onSelected(selected);
                      setState(() => _suggestions = []);
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context, debugRequiredFor: widget).insert(overlay);
    _overlayEntry = overlay;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // No longer needed for Google results but kept for future extensions.
  double _parseLatLng(Map<String, dynamic> map, {required bool isLat}) => 0.0;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: 'Street Address',
          hintText: 'Start typing address',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Address cannot be empty';
          return null;
        },
      ),
    );
  }
} 