import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';

const apiKey = "AIzaSyDtDCLMq5Kh6YLkATNpUNQa7SJYZG-As0w";

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

//Dartの非同期処理について勉強
class _MapScreenState extends State<MapScreen> {
  GooglePlace googlePlace;
  Position position;
  List<SearchResult> searchResults = [];
  final Map<String, Marker> _markers = {};

  //現在地を取得するメソッド
  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    //ToDo:現在の位置情報を取得できるようにする。
    final result = await googlePlace.search.getNearBySearch(
        // Location(lat: position.latitude, lng: position.longitude), 1500,
        // opennow: true, type: 'restaurant', keyword: '酒');
        Location(lat: position.latitude, lng: position.longitude),
        1500,
        opennow: true,
        type: 'restaurant',
        keyword: '酒');

    if (result != null && result.results != null && mounted) {
      setState(() {
        _markers.clear();
        searchResults = result.results;
        for (final result in searchResults) {
          debugPrint(
              '============================${result.name}:${result.priceLevel}');
          final marker = Marker(
              markerId: MarkerId(result.name),
              position: LatLng(
                  result.geometry.location.lat, result.geometry.location.lng),
              infoWindow: InfoWindow(
                  title: result.name, snippet: result.priceLevel.toString()));
          //markerに追加
          _markers[result.name] = marker;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("========build start");
    return FutureBuilder<Position>(
        future: _getPosition(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          GoogleMap body;
          position = snapshot.data;
          if (snapshot.hasData) {
            body = GoogleMap(
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                // target: LatLng(38.268195, 140.869418),
                target: LatLng(position.latitude, position.longitude),
                zoom: 10.0,
              ),
              markers: _markers.values.toSet(),
            );
          }
          return Scaffold(
            body: body,
          );
        });
  }
}
