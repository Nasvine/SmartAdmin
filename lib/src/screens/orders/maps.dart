import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_admin/src/models/order_model.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

/* class MapsScreen extends StatefulWidget {
  const MapsScreen({
    super.key,
    required this.location,
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Pick your Location' : 'Your Location',
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting ? null : (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers:
            (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                  Marker(
                    markerId: MarkerId('M1'),
                    position:
                        _pickedLocation ??
                        LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                  ),
                },
      ),
    );
  }
}
 */

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    super.key,
    required this.location,
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  void _moveCamera(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
    );
    setState(() {
      _pickedLocation = LatLng(lat, lng);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Pick your Location' : 'Your Location',
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: !widget.isSelecting
                ? null
                : (position) {
                    setState(() {
                      _pickedLocation = position;
                    });
                  },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.location.latitude,
                widget.location.longitude,
              ),
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('M1'),
                      position:
                          _pickedLocation ??
                          LatLng(
                            widget.location.latitude,
                            widget.location.longitude,
                          ),
                    ),
                  },
          ),

          /// Barre de recherche améliorée
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _searchController,
                focusNode: _searchFocus,
                googleAPIKey: "AIzaSyA1Y_y0JkVgT9OKiBo7G_GXcIeCGHOMii8",
                debounceTime: 800,
                countries: ["bj"], // Limite au Bénin
                inputDecoration: const InputDecoration(
                  hintText: "Rechercher une adresse...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
                textStyle: const TextStyle(
                  color: Colors.black, // ✅ Maintenant on voit ce qu’on écrit
                  fontSize: 16,
                ),
                getPlaceDetailWithLatLng: (prediction) {
                  // ✅ Déplacement caméra depuis détails
                  double lat = double.parse(prediction.lat!);
                  double lng = double.parse(prediction.lng!);
                  _moveCamera(lat, lng);
                },
                itemClick: (prediction) {
                  // ✅ On ferme le clavier et les suggestions
                  _searchFocus.unfocus();
                  _searchController.text = prediction.description ?? "";

                  // Par sécurité on reprend les coordonnées
                  if (prediction.lat != null && prediction.lng != null) {
                    _moveCamera(
                      double.parse(prediction.lat!),
                      double.parse(prediction.lng!),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
