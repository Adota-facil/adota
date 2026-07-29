import 'package:flutter/material.dart';

class Avatar_buton extends StatelessWidget {

  const Avatar_buton({super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications, color: const Color(0xFFEF9737),)),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(
              'assets/image/7433277_yuri_alberto_20240512172139.png',
            ),
          ),
        ),
      ],
    );
  }
}
