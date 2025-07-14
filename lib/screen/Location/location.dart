import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../resources/my_assets.dart';
import '../../resources/my_font.dart';
import '../../resources/my_font_weight.dart';
import '../../resources/my_string.dart';
import '../artist/search_screen.dart';

class EventLocation extends StatefulWidget {
  const EventLocation({super.key});

  @override
  State<EventLocation> createState() => _EventLocationState();
}

class _EventLocationState extends State<EventLocation> {
  late GoogleMapController mapController;

  ///
  final LatLng _center =
      const LatLng(26.8467, 80.9462); // Coordinates for Lucknow
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("start"),
      position: LatLng(26.8467, 80.9462), // Starting point
      infoWindow: InfoWindow(title: "UP Culture Radio"),
    ),
    Marker(
      markerId: MarkerId("destination"),
      position: LatLng(26.8395, 80.9231), // Destination
      infoWindow: InfoWindow(title: "Softgen Technologies Pvt Ltd"),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        title: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                /*Image(
                        image: backArrow,
                        height: 24.0,
                        width: 24.0,
                        color: Colors.white,
                      ),
*/

                // const SizedBox(width: 10,),
                Image(
                  image: upGovLogo,
                  height: 30.0,
                  width: 30.0,
                  color: Colors.white,
                ),

                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    // MyString.drawerTitle
                    'drawerTitle'.tr,
                    maxLines: 1,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontFamily: MyFont.roboto,
                        fontWeight: MyFontWeight.regular,
                        fontSize: 20),
                  ),
                ),
              ],
            )),
            InkWell(
                onTap: () {
                  Get.to(const SearchScreen());
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 15,
            ),
            Image.asset(
              'assets/images/Vector.png',
              height: 12,
              width: 16,
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            markers: _markers,
          ),

          // Floating UI Over Map
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Search Bars
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4.0),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Start Location
                      Row(
                        children: [
                          Icon(Icons.radio, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "UP Culture Radio",
                              ),
                            ),
                          ),
                          Icon(Icons.more_vert, color: Colors.black54),
                        ],
                      ),
                      Divider(),
                      // Destination
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Softgen Technologies Pvt Ltd",
                              ),
                            ),
                          ),
                          Icon(Icons.more_vert, color: Colors.black54),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Transport Modes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _transportModeWidget(
                        Icons.directions_car, "25 min", Colors.blue),
                    _transportModeWidget(
                        Icons.two_wheeler, "23 min", Colors.grey),
                    _transportModeWidget(
                        Icons.directions_bus, "1 hr 13 min", Colors.grey),
                    _transportModeWidget(
                        Icons.directions_walk, "2 hr 44 min", Colors.grey),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Navigation Details
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4.0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "25 min (12 km)",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "Fastest route, despite the usual traffic",
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Preview"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _transportModeWidget(IconData icon, String time, Color color) {
  return Column(
    children: [
      Icon(icon, color: color),
      SizedBox(height: 4),
      Text(
        time,
        style: TextStyle(color: color),
      ),
    ],
  );
}
