import 'package:ey_hackathon/Colors.dart';
import 'package:flutter/material.dart';
import 'ocr_page.dart';
import 'schemes_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> image = [
    'assets/images/image1.png',
    'assets/images/image2.jpeg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpeg',
    'assets/images/image5.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text("Home", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification button click
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screen_width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screen_height * 0.01),
            Text(
              "Whats new? ",
              style: TextStyle(
                fontSize: screen_height * 0.03,
                color: Colors.brown,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: screen_height * 0.02),
            CarouselSlider(
              options: CarouselOptions(
                height: screen_height * 0.25,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
              ),
              items: image.map((path) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Image.asset(path, fit: BoxFit.cover),
                );
              }).toList(),
            ),
            SizedBox(height: screen_height * 0.02),
            Text(
              "My Schemes",
              style: TextStyle(
                fontSize: screen_height * 0.03,
                color: Colors.brown,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: screen_height * 0.02),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: screen_width * 0.04,
                mainAxisSpacing: screen_width * 0.04,
                childAspectRatio: 1,
                children: [
                  FeatureTile(
                    title: "Document Verification",
                    imagePath: 'assets/images/verification.png',
                    description: "AI-powered OCR and fraud detection.",
                    destinationPage: OcrPage(),
                  ),
                  FeatureTile(
                    title: "Scheme Matching",
                    imagePath: 'assets/images/scheme.png',
                    description: "Smart recommendations for schemes.",
                    destinationPage: SchemesPage(),
                  ),
                  FeatureTile(
                    title: "My Dashboard",
                    imagePath: 'assets/images/dashboard.png',
                    description: "Track status and view insights.",
                    destinationPage: OcrPage(),
                  ),
                  FeatureTile(
                    title: "Multilingual Chatbot",
                    imagePath: 'assets/images/chatbot.png',
                    description: "Interactive AI-driven support.",
                    destinationPage: OcrPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final Widget destinationPage;

  const FeatureTile({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.destinationPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
