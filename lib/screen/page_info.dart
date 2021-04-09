


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageInfo extends StatelessWidget {
  var item;
  PageInfo(item){
   this.item=item;}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child:SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: item['name'],
                                    style: GoogleFonts.knewave()
                                        .copyWith(fontSize: 40),
                                    children: [

                                    ],
                                  ),
                                ),

                                Text(
                                  "\nBarcode : ${item['barcode']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          //  SizedBox(width: 20 / 2),
                          Text("\$ ${item['price']}", style: TextStyle(fontSize: 25,)),
                        ],
                      ),
                      SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) => SizedBox(
                          width: constraints.maxWidth > 840
                              ? 800
                              : constraints.maxWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: constraints.maxWidth > 840
                                    ? 600
                                    : constraints.maxWidth - 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    "assets/e2.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Divider(thickness: 3,),
                              SizedBox(height: 20 / 2),
                              Text(
                                "The most loved chicken burger in the univers. \n"
                                    " \nBacon ipsum dolor amet ham sausage pork chop andouille tail, ball tip meatloaf. "
                                    "Tongue pork belly venison jerky spare "
                                    "ribs chicken. Shank tail rump sausage, "
                                    "swine biltong pancetta. Ball tip jowl "
                                    "kielbasa pork loin, meatball turducken"
                                    " chislic pork belly ham bresaola meatloaf alcatra. ",
                                style: TextStyle(),
                              ),
                              SizedBox(height: 80),
                              Row(
                                children: [
                                  Spacer(),
                                  Text("Reviews (33) ",
                                      style: TextStyle(fontSize: 15)),
                                  Icon(Icons.favorite,
                                      color:
                                      Theme.of(context).primaryColor),
                                  Icon(Icons.favorite,
                                      color:
                                      Theme.of(context).primaryColor),
                                  Icon(Icons.favorite,
                                      color:
                                      Theme.of(context).primaryColor),
                                  Icon(Icons.favorite,
                                      color:
                                      Theme.of(context).primaryColor),
                                  Icon(Icons.favorite_border,
                                      color:
                                      Theme.of(context).primaryColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
