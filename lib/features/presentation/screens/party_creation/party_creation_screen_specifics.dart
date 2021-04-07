import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps
    show LatLng;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../data/models/lat_long.dart';
import '../../../data/models/party.dart';
import '../../../../core/native/LocationService.dart';
import '../../../../constants.dart';
import '../../widgets/navigation/party/navigation_party_creation_widget.dart';
import '../google_map_screen.dart';

class PartyCreationScreenSpecifics extends StatefulWidget {
  Map<String, dynamic> initialData;

  PartyCreationScreenSpecifics({
    Key key,
    this.onNext,
    this.onPrevious,
    this.initialData = const {
      'address': '',
      'drinks': Drinks.BringYourOwnBooze,
      'music': Music.Techno,
      'date': '',
      'time': null as TimeOfDay,
      'coordinates': null as LatLng, //LatLng(latitude: 20, longitude: 20),
    },
  }) : super(key: key);

  final Function(Map<String, dynamic> speficisData) onNext;
  final Function(Map<String, dynamic> speficisData) onPrevious;

  @override
  _PartyCreationScreenSpecificsState createState() =>
      _PartyCreationScreenSpecificsState();
}

class _PartyCreationScreenSpecificsState
    extends State<PartyCreationScreenSpecifics> {
  Map<String, dynamic> _specificsData = {
    'address': '',
    'drinks': Drinks.BringYourOwnBooze,
    'music': Music.Techno,
    'date': '',
    'time': null,
    'coordinates': {
      'latitude': null,
      'longitude': null,
    },
  };

  int _musicIndex = 1;
  int _drinksIndex = 1;

  @override
  void initState() {
    super.initState();
    _specificsData = widget.initialData;
    _musicIndex = Music.values
            .indexWhere((element) => element == _specificsData['music']) +
        1;
    _drinksIndex = Drinks.values
            .indexWhere((element) => element == _specificsData['drinks']) +
        1;
  }

  void _chooseFromMap() async {
    Location location = new Location();

    LocationData _locationData;

    _locationData = await location.getLocation();

    print(_locationData);

    final maps.LatLng _result =
        await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(
        isSelecting: true,
        initialLocation: _specificsData['coordinates']['latitude'] == null
            ? maps.LatLng(
                _locationData.latitude,
                _locationData.longitude,
              )
            : maps.LatLng(
                _specificsData['coordinates']['latitude'],
                _specificsData['coordinates']['longitude'],
              ),
      ),
    ));

    if (_result == null) return;
    _specificsData['coordinates'] = {
      'latitude': _result.latitude,
      'longitude': _result.longitude
    };

    print('${_result.latitude} :  ${_result.longitude}');

    final String _address = await LocationService.getAddressFromLatLng(
      _result.latitude,
      _result.longitude,
    );
    setState(() {
      _specificsData['address'] =
          _address.split(',').first + ',' + _address.split(',')[2];
      print(_address);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);

    final _theme = Theme.of(context);

    return Stack(
      children: [
        ...Constants.buildBackground(),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 30, 20, 0),
                child: Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icons/beer.png',
                        height: 50,
                      ),
                      Container(
                        width: _media.size.width / 1.5,

                        //TODO: ENFORCE TITLE LENGHT
                        child: Text(
                          'Specifics',
                          textAlign: TextAlign.center,
                          style:
                              _theme.textTheme.headline1.copyWith(fontSize: 26),
                        ),
                      ),
                      Image.asset(
                        'assets/icons/toast.png',
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 1,
                endIndent: 20,
                color: Colors.blueGrey.shade300,
                indent: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 28),
                child: Text(
                  Constants.textPartyCreationSpecifics,
                  style: _theme.textTheme.bodyText1
                      .copyWith(color: Constants.kHelperTextColor, height: 1.5),
                ),
              ),
              SpecificsButonPicker(
                media: _media,
                specificsData: _specificsData,
                theme: _theme,
                assetsPath: 'assets/icons/calendar.png',
                value: (_specificsData['date'] == '')
                    ? ''
                    : (DateFormat.yMMMEd()
                            .format(DateTime.parse(_specificsData['date'])) +
                        '    '),
                iconHeight: _media.size.height * 0.045,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    final DateTime result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 730)),
                    );
                    if (result != null) {
                      setState(() {
                        _specificsData['date'] = result.toIso8601String();
                      });
                    }
                  },
                  child: Text(
                    '  Choose date',
                    style: _theme.textTheme.bodyText1
                        .copyWith(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SpecificsButonPicker(
                media: _media,
                specificsData: _specificsData,
                theme: _theme,
                assetsPath: 'assets/icons/time.png',
                value: (_specificsData['time'] == null)
                    ? ''
                    : '${_specificsData['time'].hour} : ${_specificsData['time'].minute}',
                iconHeight: _media.size.height * 0.045,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    final TimeOfDay _result = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    setState(() {
                      _specificsData['time'] = _result;
                    });
                  },
                  child: Text(
                    '  Choose time',
                    style: _theme.textTheme.bodyText1
                        .copyWith(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              SpecificsButonPicker(
                media: _media,
                specificsData: _specificsData,
                theme: _theme,
                assetsPath: 'assets/icons/location.png',
                value: _specificsData['address'],
                iconHeight: _media.size.height * 0.06,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: _chooseFromMap,
                  child: Text(
                    '  Choose Location',
                    style: _theme.textTheme.bodyText1
                        .copyWith(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                height: _media.size.height * 0.11,
                alignment: Alignment.topCenter,
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: GridView.count(
                    //TODO:  Grid can be scrolled, find a way to remove that feature / or use different approach
                    crossAxisCount: 2,
                    // crossAxisSpacing: 10,
                    mainAxisSpacing: 0,
                    childAspectRatio: 3 / 1,
                    children: [
                      DropButton(
                        iconPath: 'assets/icons/drinks.png',
                        media: _media,
                        // selectedItemBuilder: (ctx) {
                        //   return Drinks.values
                        //       .map((item) => Text(
                        //             'helloooooooo',
                        //             style: TextStyle(
                        //                 fontStyle: FontStyle.italic,
                        //                 fontWeight: FontWeight.w500),
                        //           ))
                        //       .toList();
                        // },
                        value: _drinksIndex,
                        onChanged: (value) {
                          setState(() {
                            _drinksIndex = value;
                            _specificsData['drinks'] =
                                Drinks.values.elementAt(_drinksIndex - 1);
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Bring your own'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Available to buy'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Free drinks'),
                          ),
                        ],
                      ),
                      DropButton(
                        value: _musicIndex,
                        iconPath: 'assets/icons/music.png',
                        media: _media,
                        onChanged: (value) {
                          setState(() {
                            _musicIndex = value;
                            _specificsData['music'] =
                                Music.values.elementAt(_musicIndex - 1);
                            print(_specificsData['music']);
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Turbo folk'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Mix of music'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Techno'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('House'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('Clasic'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 160,
              ),
            ],
          ),
        ),
        NavigationPartyCreationWidget(
          media: _media,
          onNext: () => widget.onNext(_specificsData),
          onPrevious: () => widget.onPrevious(_specificsData),
        )
        //   bottom: 40,
        //   left: _media.size.width / 4.6,
        // ),
      ],
    );
  }
}

class DropButton extends StatelessWidget {
  const DropButton({
    Key key,
    @required MediaQueryData media,
    @required this.iconPath,
    @required this.items,
    @required this.onChanged,
    @required this.value,
    this.selectedItemBuilder,
  })  : _media = media,
        super(key: key);

  final MediaQueryData _media;
  final iconPath;
  final value;
  final Function(dynamic) onChanged;
  final List<DropdownMenuItem<dynamic>> items;
  final List<Widget> Function(BuildContext) selectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton(
          selectedItemBuilder: selectedItemBuilder ?? null,
          value: value,

          // dropdownColor: Colors.blue[100],
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Image.asset(
              iconPath,
              height: _media.size.height * 0.045,
            ),
          ),
          onChanged: this.onChanged,
          items: items,
        ),
      ],
    );
  }
}

class SpecificsButonPicker extends StatelessWidget {
  const SpecificsButonPicker({
    Key key,
    @required MediaQueryData media,
    @required Map<String, dynamic> specificsData,
    @required ThemeData theme,
    @required this.assetsPath,
    @required this.value,
    @required this.iconHeight,
  })  : _media = media,
        _specificsData = specificsData,
        _theme = theme,
        super(key: key);

  final MediaQueryData _media;
  final Map<String, dynamic> _specificsData;
  final ThemeData _theme;
  final String assetsPath;
  final String value;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          assetsPath,
          height: iconHeight,
        ),
        Container(
          //alignment: Alignment.bottomCenter,
          height: _media.size.height * 0.05,
          width: _media.size.width * 0.7, //TODO: text overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // SizedBox(
              //   height: _media.size.height * 0.04,
              // ),
              Expanded(
                child: Text(
                  value,
                  style: _theme.textTheme.headline2,
                  overflow: TextOverflow.clip,
                ),
              ),
              Divider(
                color: Colors.grey[600],
                indent: 8,
                endIndent: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
