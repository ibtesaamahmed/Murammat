import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WorkerDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: ListView(
            children: [
              CarouselSlider(
                items: [
                  //1st Image of Slider
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://rental.ua/content/documents/6/567/thumb-article-700x333-0e04.jpg"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),

                  //2nd Image of Slider
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://www.insurancecentermo.com/wp-content/uploads/2021/09/roadside-assistance1.webp"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],

                //Slider Container properties
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 80,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text('Show Requests'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                fixedSize: Size(100, 100),
                elevation: 10,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Add Services'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                fixedSize: Size(100, 100),
                elevation: 10,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'My Shop',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                fixedSize: Size(260, 100),
                elevation: 10,
              ),
            ),
          ],
        )
      ],
    );
  }
}
