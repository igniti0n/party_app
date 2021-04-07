import 'package:flutter/material.dart';

class PartyNavigationBar extends StatefulWidget {
  final List<Widget> screens;
  final bool Function(int) onIndexChanged;
  PartyNavigationBar({Key key, @required this.screens, this.onIndexChanged})
      : super(key: key);

  @override
  _PartyNavigationBarState createState() => _PartyNavigationBarState();
}

class _PartyNavigationBarState extends State<PartyNavigationBar> {
  int _currentIndex = 0;

  void _changeCurrentIndex(int index) async {
    if (_currentIndex != index && mounted) {
      //if (!await widget.onIndexChanged(_currentIndex)) return;
      setState(() {
        _currentIndex = index;
      });
      if (widget.onIndexChanged(_currentIndex)) _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _size = _media.size;
    final Size _individualItemSize = Size(_size.width / 4, _size.height / 14);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              color: Color.fromRGBO(111, 99, 165, 0.05),
              child: widget.screens.elementAt(_currentIndex),
            ),
          ),
          Row(
            children: [
              PartyBarItem(
                selected: _currentIndex == 0,
                onTap: () => _changeCurrentIndex(0),
                size: _individualItemSize,
                correctionSize: Size(10, 20),
                iconName: 'wall',
              ),
              PartyBarItem(
                selected: _currentIndex == 1,
                onTap: () => _changeCurrentIndex(1),
                size: _individualItemSize,
                iconName: 'party',
              ),
              PartyBarItem(
                selected: _currentIndex == 2,
                onTap: () => _changeCurrentIndex(2),
                size: _individualItemSize,
                iconName: 'profile',
              ),
              PartyBarItem(
                selected: _currentIndex == 3,
                onTap: () => _changeCurrentIndex(3),
                size: _individualItemSize,
                iconName: 'addUser',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PartyBarItem extends StatelessWidget {
  final Size size;
  final Size correctionSize;
  final String iconName;
  final bool selected;
  final void Function() onTap;
  const PartyBarItem({
    Key key,
    this.size,
    this.iconName,
    this.correctionSize = const Size(0, 0),
    this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        child: Image.asset(
          'assets/icons/$iconName' +
              (selected == true ? '-filled.png' : '-empty.png'),
          width: size.width / 2 + correctionSize?.width,
          height: size.height * 0.55 + correctionSize?.height,
        ),
      ),
    );
  }
}
