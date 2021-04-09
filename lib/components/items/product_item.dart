import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/models/product_item.dart';
import 'package:scanner/screen/page_info.dart';


class Item extends StatelessWidget {
  final  item;
  final Function onPressed;
  final bool selected;
  const Item({
    //required   Key key,
    required this.item,
    required  this.onPressed,
    this.selected = false,
  }) ;

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap:onPressed(),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Colors.teal
              : isLight
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10,left: 10),
              child: Text(
                item['name'].toString().toUpperCase(),
                textAlign: TextAlign.justify,maxLines: 1,overflow: TextOverflow.ellipsis,
                style: GoogleFonts.varelaRound(
                    fontSize: 20,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold)
                    .copyWith(fontSize: 20),
              ),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,size: 100,
                  color:
                  selected ? Colors.white : Theme.of(context).accentColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "\$ ${item['price']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 18,
                      color: selected
                          ? Colors.white
                          : isLight
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_box_sharp,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PageInfo(item)));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
