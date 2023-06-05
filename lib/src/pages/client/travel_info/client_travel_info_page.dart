import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../widgets/button_app.dart';
import 'client_travel_info_controller.dart';

class ClientTravelInfoPage extends StatefulWidget {
  const ClientTravelInfoPage({super.key});

  @override
  ClientTravelInfoPageState createState() => ClientTravelInfoPageState();
}

class ClientTravelInfoPageState extends State<ClientTravelInfoPage> {
  final ClientTravelInfoController _con = ClientTravelInfoController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _con.key,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _googleMapsWidget(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _cardTravelInfo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: _buttonBack(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _cardKmInfo('0 Km'),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _cardMinInfo('0 Min'),
          )
        ],
      ),
    );
  }

  Widget _cardTravelInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Desde',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                'Cr falsa con calle falsa',
                style: TextStyle(fontSize: 13),
              ),
              leading: Icon(Icons.location_on),
            ),
            const ListTile(
              title: Text(
                'Hasta',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                'Cr falsa con calle falsa',
                style: TextStyle(fontSize: 13),
              ),
              leading: Icon(Icons.my_location),
            ),
            const ListTile(
              title: Text(
                'Precio',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                '0.0\$',
                style: TextStyle(fontSize: 13),
              ),
              leading: Icon(Icons.attach_money),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonApp(
                onPressed: () {},
                text: 'CONFIRMAR',
                textColor: Colors.black,
                color: Colors.amber,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardKmInfo(String? km) {
    return SafeArea(
        child: Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(right: 10, top: 10),
      decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(km ?? '0 Km'),
    ));
  }

  Widget _cardMinInfo(String? min) {
    return SafeArea(
        child: Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(right: 10, top: 35),
      decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(min ?? '0 Min'),
    ));
  }

  Widget _buttonBack() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh() {
    setState(() {});
  }
}
