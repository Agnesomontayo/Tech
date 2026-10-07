import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopClientsWidget extends StatefulWidget {
  final List<dynamic> topClients;
  final String baseImageUrl;

  TopClientsWidget({required this.topClients, required this.baseImageUrl});

  @override
  _TopClientsWidgetState createState() => _TopClientsWidgetState();
}

class _TopClientsWidgetState extends State<TopClientsWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.topClients.isEmpty) {
      return Text('Aucun client récurrent pour le moment');
    }

    final double containerWidth = 300;
    final double centerX = containerWidth / 2;

    List<Offset> offsets = [
      Offset(0, 30),     // premier - centre
      Offset(85, 10),    // deuxième - droite
      Offset(-85, 10),   // troisième - gauche
    ];

    List<Widget> stackChildren = List.generate(widget.topClients.length, (index) {
      final client = widget.topClients[index];
      final double size = index == 0 ? 120 : 90;
      final String name = client['name'] ?? 'Client';
      final String imageUrl = client['avatar'] != null && client['avatar'].toString().isNotEmpty
          ? '${widget.baseImageUrl}/${client['avatar']}'
          : client['profile_photo_url'];

      final offset = offsets[index];

      return Positioned(
        left: centerX + offset.dx - size / 2,
        top: offset.dy,
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == index ? null : index;
            });
          },
          child: Column(
            children: [
              if (selectedIndex == index)
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Text(name, style: TextStyle(fontSize: 12)),
                ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    // Mettre l'élément principal au-dessus
    if (stackChildren.length > 1) {
      final main = stackChildren.removeAt(0);
      stackChildren.add(main);
    }

    return SizedBox(
      width: containerWidth,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        children: stackChildren,
      ),
    );
  }
}
/*
List<Widget> buildTopProfessionalsCircles(List<dynamic> topPros, String baseImageUrl) {
  if (topPros.isEmpty) {
    return [Text('Aucun professionnel populaire pour le moment')];
  }

  final double containerWidth = 320;
  final double centerX = containerWidth / 2;
  final double size = 70; // taille fixe pour tous

  // Positions centrées par rapport au container
  List<Offset> offsets = [
    Offset(0, 0),
    Offset(60, 20),
    Offset(-60, 20),
    Offset(110, 40),
    Offset(-110, 40),
  ];

  List<Widget> stackChildren = List.generate(topPros.length, (index) {
    final pro = topPros[index];
    final String? avatar = pro['avatar'];
    final String profilePhotoUrl = pro['profile_photo_url'];

    String imageUrl;
    if (avatar != null && avatar.isNotEmpty) {
      imageUrl = '$baseImageUrl/$avatar';
    } else {
      imageUrl = profilePhotoUrl;
    }

    return Positioned(
      left: centerX + offsets[index].dx - size / 2, // centrer sur le point
      //top: offsets[index].dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: index == 0
              ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))]
              : null,
        ),
      ),
    );
  });

  // Le centre doit rester au-dessus
  if (stackChildren.length > 1) {
    final main = stackChildren.removeAt(0);
    stackChildren.add(main);
  }

  return [
    SizedBox(
      width: containerWidth,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: stackChildren,
      ),
    ),
  ];
}
*/

class TopProfessionalsWidget extends StatefulWidget {
  final List<dynamic> topPros;
  final String baseImageUrl;

  TopProfessionalsWidget({required this.topPros, required this.baseImageUrl});

  @override
  _TopProfessionalsWidgetState createState() => _TopProfessionalsWidgetState();
}

class _TopProfessionalsWidgetState extends State<TopProfessionalsWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.topPros.isEmpty) {
      return Text('Aucun professionnel populaire pour le moment');
    }

    final double containerWidth = 320;
    final double centerX = containerWidth / 2;
    final double size = 70;

    List<Offset> offsets = [
      Offset(0, 0),
      Offset(60, 20),
      Offset(-60, 20),
      Offset(110, 40),
      Offset(-110, 40),
    ];

    List<Widget> stackChildren = List.generate(widget.topPros.length, (index) {
      final pro = widget.topPros[index];
      final String name = pro['professional_name'] ?? 'Professionnel';
      final String imageUrl = (pro['avatar'] != null && pro['avatar'].toString().isNotEmpty)
          ? '${widget.baseImageUrl}/${pro['avatar']}'
          : pro['profile_photo_url'];

      final offset = offsets[index];

      return Positioned(
        left: centerX + offset.dx - size / 2,
        //top: offset.dy,
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == index ? null : index;
            });
          },
          child: Column(
            children: [
              if (selectedIndex == index)
                Container(
                  //margin: EdgeInsets.only(bottom: 6),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Text(name, style: TextStyle(fontSize: 12)),
                ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: index == 0
                      ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))]
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    });

    // S'assurer que le premier élément est au-dessus
    if (stackChildren.length > 1) {
      final main = stackChildren.removeAt(0);
      stackChildren.add(main);
    }

    return SizedBox(
      width: containerWidth,
      height: 150,
      child: Stack(
        clipBehavior: Clip.none,
        children: stackChildren,
      ),
    );
  }
}



