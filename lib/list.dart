import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late final PageController _pageController;
  int _selectedIndex = 0;
  int _currentPage = 0;
  DateTime? _lastTapTime;

  final List<dynamic> items = [
    'https://picsum.photos/id/1014/400/300',
    'https://picsum.photos/id/1014/400/300',
    'https://picsum.photos/id/1014/400/300',
    'https://picsum.photos/id/1014/400/300',
    'https://picsum.photos/id/1015/400/300',
  ];

  final int _initialPage = 10000 ~/ 2;

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage;
    _selectedIndex = _initialPage % items.length;
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.5,
    );
  }

  void _onTap(int realIndex) {
    final now = DateTime.now();
    if (_selectedIndex == realIndex &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(milliseconds: 300)) {
      final item = items[realIndex];
      if (item is Widget) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => item));
      } else if (item is String) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(imageUrl: item)),
        );
      }
    } else {
      setState(() {
        _selectedIndex = realIndex;
        _lastTapTime = now;
      });
    }
  }

  void _goToPrevious() {
    _currentPage--;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() {
      _selectedIndex = _currentPage % items.length;
    });
  }

  void _goToNext() {
    _currentPage++;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() {
      _selectedIndex = _currentPage % items.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 196, 174, 173),
              Color.fromARGB(255, 144, 144, 201),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 60,
              child: Text(
                'Choose Login UI',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Color.fromARGB(136, 130, 94, 137),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            PageView.builder(
              controller: _pageController,
              itemCount: 10000,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _selectedIndex = index % items.length;
                });
              },
              itemBuilder: (context, index) {
                final realIndex = index % items.length;
                final bool isSelected = _selectedIndex == realIndex;
                final radius = BorderRadius.circular(isSelected ? 40 : 60);

                final double pageOffset =
                    (_pageController.page ?? _currentPage.toDouble());
                final double delta = index - pageOffset;

                EdgeInsets cardMargin;
                if (isSelected) {
                  cardMargin = const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 160,
                  );
                } else if (delta < 0) {
                  cardMargin = const EdgeInsets.only(
                    left: 5,
                    right: 0,
                    top: 150,
                    bottom: 150,
                  );
                } else {
                  cardMargin = const EdgeInsets.only(
                    left: 20,
                    right: 0,
                    top: 150,
                    bottom: 150,
                  );
                }

                return GestureDetector(
                  onTap: () => _onTap(realIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: cardMargin,
                    transform: Matrix4.identity()
                      ..translate(0.0, isSelected ? 0.0 : 200.0)
                      ..scale(isSelected ? 1.0 : 0.4, isSelected ? 1.0 : 0.6),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF9090C9), Color(0xFFD38C9D)],
                            )
                          : null,
                      borderRadius: radius,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: radius,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: radius,
                        child: items[realIndex] is Widget
                            ? items[realIndex] as Widget
                            : Hero(
                                tag: items[realIndex],
                                child: Image.network(
                                  items[realIndex] as String,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),

            Positioned(
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                iconSize: 36,
                onPressed: _goToPrevious,
              ),
            ),
            Positioned(
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                iconSize: 36,
                onPressed: _goToNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String imageUrl;

  const DetailPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 118, 113),
      appBar: AppBar(
        title: const Text('Detail Page'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Hero(tag: imageUrl, child: Image.network(imageUrl)),
      ),
    );
  }
}
