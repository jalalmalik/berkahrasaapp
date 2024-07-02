import 'package:flutter/material.dart';
import 'package:uas/pages/HomePage.dart';
import 'package:uas/pages/SalesPage.dart';
import 'package:uas/pages/StockPage.dart';
import 'package:uas/pages/productPage.dart';
import 'package:uas/pages/tambah/TambahProduct.dart';
import 'package:uas/pages/tambah/TambahStock.dart';
import 'package:uas/pages/tambah/TambahSales.dart'; // Impor halaman tambah lainnya

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController(initialPage: 0);
  int selectedIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah yang sesuai berdasarkan selectedIndex
          if (selectedIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahProduct()),
            );
          } else if (selectedIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahStock()),
            );
          } else if (selectedIndex == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahSales()),
            );
          }
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipPath(
        clipper: TopAppBarClipper(),
        child: BottomAppBar(
          notchMargin: 5.0,
          shape: const CircularNotchedRectangle(),
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => onItemTapped(0),
                  icon: Icon(Icons.home,
                      color: selectedIndex == 0 ? Colors.purple : Colors.grey),
                ),
                IconButton(
                  onPressed: () => onItemTapped(1),
                  icon: Icon(Icons.shopping_basket,
                      color: selectedIndex == 1 ? Colors.purple : Colors.grey),
                ),
                const SizedBox(
                    width: 40), // The space for the floating action button
                IconButton(
                  onPressed: () => onItemTapped(2),
                  icon: Icon(Icons.storage,
                      color: selectedIndex == 2 ? Colors.purple : Colors.grey),
                ),
                IconButton(
                  onPressed: () => onItemTapped(3),
                  icon: Icon(Icons.attach_money,
                      color: selectedIndex == 3 ? Colors.purple : Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomePage(),
          ProductPage(),
          StockPage(),
          SalesPage(),
        ],
      ),
    );
  }
}

class TopAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const notchRadius = 35.0;

    path.lineTo(size.width / 2 - notchRadius, 0);
    path.arcToPoint(
      Offset(size.width / 2 + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
