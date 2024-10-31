import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingtitle;
  final String headingsubtitle;
  final VoidCallback onTap;
  final String buttontext;
  const HeadingWidget(
      {super.key,
      required this.headingtitle,
      required this.headingsubtitle,
      required this.onTap,
      required this.buttontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  headingsubtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.amber,
                      width: 1.5,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttontext,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
