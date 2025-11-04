import 'package:flutter/material.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Congratulations Card at the center
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 60), // Adjust top margin to match Figma
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEFEFE),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFE6EAEB),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Award Badge
                Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Image.asset('assets/images/award_badge.png'), // Award badge image
                ),
                SizedBox(height: 24),
                Text(
                  'Congratulations!!',
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'You saved \$6.23 with GrocerAI today!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your Walmart order totals \$243',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your order will arrive by 6 PM on January 6, 2025',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons Row (with spacing adjustment)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF33595B),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x1915224F),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Review',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF33595B),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF33595B),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x1915224F),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Refer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF33595B),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF33595B),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x1915224F),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Start over',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF33595B),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Return to Home Button
          Container(
            width: 382,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
              color: const Color(0xFF33595B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x1915224F),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Center(
              child: Text(
                'Return to the Home',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFEFEFE),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
