import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

const apiKey = 'AIzaSyAQgErYcaWFgxhjkqyx9xRVRQBORTZ743I';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

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
    debugPrint('========build start');
    return FutureBuilder<Position>(
        future: _getPosition(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          GoogleMap map;
          position = snapshot.data;
          if (snapshot.hasData) {
            map = GoogleMap(
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 17.0,
              ),
              markers: _markers.values.toSet(),
            );
          } else {
            return Center(
              child: Text('ちょっと待ってね'),
            );
          }
          return Scaffold(
              body: Stack(
            children: <Widget>[
              map,
              Positioned(
                left: -70,
                top: 525.0,
                width: 550,
                height: 300,
                child: ShopCardWidget(),
              ),
            ],
          ));
        });
  }
}

//TODO　cardをMapScreen下部に表示する。
class ShopCardWidget extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 280,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              //ToDo cardの中身の実装
              child: Card(
                elevation: 5.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                        child: ClipRRect(
                            //角丸にするやつ
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                                'https://activephotostyle.biz/wp-content/uploads/2019/01/4799_IMGP2561-2-1024x681.jpg',
                                height: 400,
                                width: 600,
                                fit: BoxFit.fitWidth))), //ここまでは妥協点
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, right: 0, left: 0),
                                child: ListTile(
                                  title: Text(
                                    'ふらっと酒場',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      //ToDO: Use Google Font
                                    ),
                                  ),
                                  subtitle: Text(
                                    '平均予算3000円',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      //ToDO: Use Google Font
                                    ),
                                  ),
                                )),
                          ],
                        )),
                        Icon(Icons.local_drink_rounded,
                            size: 36, color: Colors.orangeAccent),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.local_drink_rounded,
                          size: 36,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.local_drink_rounded,
                          size: 36,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    // Text("フラッと酒場"),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.car_rental,
                            size: 40,
                          ),
                          Text(
                            '今から行く',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              //ToDO: Use Google Font
                            ),
                          ),
                        ],
                      ),
                      color: Colors.orange[200],
                      shape: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
