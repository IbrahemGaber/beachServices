import 'package:flutter/material.dart';

class RPSFormCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint_0 = new Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.0006529,size.height*0.9418217);
    path_0.cubicTo(size.width*0.0046625,size.height*0.9838200,size.width*0.0198125,size.height*1.0012800,size.width*0.0631529,size.height*1.0018217);
    path_0.cubicTo(size.width*0.2644750,size.height*1.0027200,size.width*0.7397250,size.height*1.0016600,size.width*0.9489957,size.height*1.0035895);
    path_0.cubicTo(size.width*0.9826250,size.height*1.0013400,size.width*1.0026125,size.height*1.0018000,size.width*1.0006529,size.height*0.9418217);
    path_0.cubicTo(size.width*1.0011000,size.height*0.7588400,size.width*0.9970875,size.height*0.1582600,size.width*0.9940332,size.height*0.1014895);
    path_0.cubicTo(size.width*0.9926500,size.height*0.0298200,size.width*0.9332000,size.height*-0.0114400,size.width*0.8702564,size.height*0.0059357);
    path_0.cubicTo(size.width*0.8226625,size.height*0.0164400,size.width*0.0534750,size.height*0.1884000,size.width*0.0375000,size.height*0.2000000);
    path_0.cubicTo(size.width*0.0189500,size.height*0.2073800,size.width*-0.0039625,size.height*0.2198000,0,size.height*0.2600000);
    path_0.cubicTo(size.width*-0.0038625,size.height*0.4368600,size.width*0.0030750,size.height*0.4684200,size.width*0.0006529,size.height*0.9418217);
    path_0.close();

    canvas.drawPath(path_0, paint_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
