import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gawlah/Tour_Items_Page_View/Tour_item_card.dart';
import 'package:flutter_gawlah/Tours_Page_View/Tour_Card.dart';

class Tour_Item_List extends StatefulWidget {

  Tour_Item_List_State createState() => Tour_Item_List_State();

}
class Tour_Item_List_State extends State<Tour_Item_List>{

  final PageController controller = PageController(
      viewportFraction: .85,
      keepPage:true
  );
  final Firestore database = Firestore.instance;
  Color _BackGroundColor;
  Stream Items;
  int currentPage = 0;

  @override
  void initState() {
    _queryDatabase();
    controller.addListener(() {

      int next = controller.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }
  void _queryDatabase({String tag = 'all'}) {

  {
      Query query =
      database.collection('polylines').where('type', isEqualTo: 'item')  ;
      Items = query
          .snapshots()
          .map((list) => list.documents.map((doc) => doc.data));
    }
    // Map the slides to the data payload

    // Update the active tag
    setState(() {
    });
  }
  Container _buildThemesPage() {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Themes',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 10,
              ),
              Text('FILTERS',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
          Container(
            height: 20,
          ),
          _buildButton('Art'),
          _buildButton('War'),
          _buildButton('Qurans'),
          _buildButton('painting'),
        ],
      ),
    );
  }
  FlatButton _buildButton(tag) {
    return FlatButton(
      child: SizedBox(
        width: 80,
        child: Text(
          '#$tag',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () => _queryDatabase(tag: tag),
    );
  }





  Widget _buildStoryPage(Map data, bool active ,BuildContext context ) {
    // Animated properties
    final double blur = active ? 100: 30;
    final double offset = active ? 10 : 0;
    final double top = active ? 200 : 240;

    return AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 100, right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: blur,
              offset: Offset(offset, offset),
            ),
          ],
        ),
        child:new TourItemCard(data)
    );
  }


  Widget _buildbackground() {
    return Container(
      color: _BackGroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images_and_icons/g_transparent.png',
            height: 100,
          ),
          Container(
            height: 575,
          )
        ],
      ),
    );
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        body: Center(
          child: Stack(children: [
            _buildbackground(),
            StreamBuilder(
              stream: Items,
              initialData: [],
              builder: (context, AsyncSnapshot snap) {
                List slideList = snap.data.toList();
                return PageView.builder(
                  controller: controller,

                  itemCount: slideList.length+1 ,
                  itemBuilder: (context, int currentIndex) {
                    if (currentIndex == 0) {
                      return _buildThemesPage();
                    } else if (slideList.length >= currentIndex) {
                      bool active = currentIndex == currentPage;
                      return _buildStoryPage(slideList[currentIndex-1], active,context,);
                    }

                  },
                );
              },
            )
          ]),
        ));
  }




}

