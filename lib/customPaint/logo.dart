import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter{

@override
void paint(Canvas canvas, Size size) {



  Paint paint_0 = new Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill
    ..strokeWidth = 1;


  Path path_0 = Path();
  path_0.moveTo(size.width*0.1420500,size.height*0.0001800);
  path_0.lineTo(size.width,0);
  path_0.quadraticBezierTo(size.width*1.0055625,size.height*0.6962200,size.width,size.height*0.8957200);
  path_0.cubicTo(size.width*0.9565000,size.height*0.8869800,size.width*0.7529500,size.height*0.6347400,size.width*0.6298875,size.height*0.6214200);
  path_0.cubicTo(size.width*0.4912375,size.height*0.5934600,size.width*0.2782625,size.height*0.8083000,size.width*0.1672500,size.height*0.6141600);
  path_0.quadraticBezierTo(size.width*0.0978000,size.height*0.4714200,size.width*0.1420500,size.height*0.0001800);
  path_0.close();

  canvas.drawPath(path_0, paint_0);


}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
  return true;
}

}
