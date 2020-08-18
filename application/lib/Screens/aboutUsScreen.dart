import 'package:agri_shopping/constants.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to our app, let's shop!",
      "image": "assets/media/images/fruits.jpg"
    },
    {
      "text": "We help marketers connect!",
      "image": "assets/media/images/fruits.jpg"
    },
    {
      "text": "We show the easy way to shop!",
      "image": "assets/media/images/fruits.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: blackColor)),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: splashData.length,
                        itemBuilder: (context, index) => SplashContent(
                            text: splashData[index]["text"],
                            image: splashData[index]["image"]))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          (20 / 375.0) * MediaQuery.of(context).size.width,
                    ),
                    child: Column(
                      children: [
                        Spacer(flex: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                            (index) => buildDot(index: index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
          color: currentPage == index ? Colors.green : Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(5)),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({Key key, this.text, this.image}) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text("FARMER's",
            style: TextStyle(
                fontSize: (36 / 375.0) * MediaQuery.of(context).size.width,
                color: Colors.green,
                fontWeight: FontWeight.bold)),
        Text(text),
        Spacer(flex: 2),
        Image.asset(
          image,
          height: (265 / 812.0) * MediaQuery.of(context).size.height,
          width: (263 / 375.0) * MediaQuery.of(context).size.width,
        )
      ],
    );
  }
}
