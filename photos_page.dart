import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  Future<List<dynamic>> getPhotos() async {
    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=2&limit=10'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil foto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Foto", style: TextStyle(color: Colors.white)),

        backgroundColor: Colors.cyan,
      ),

      body: FutureBuilder<List<dynamic>>(
        future: getPhotos(),

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final photos = snapshot.data!;

            return ListView.builder(
              itemCount: photos.length,

              itemBuilder: (context, index) {
                final photo = photos[index];

                return Card(
                  margin: EdgeInsets.all(10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Image.network(
                        photo['download_url'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      Padding(
                        padding: EdgeInsets.all(10),

                        child: Text(
                          photo['author'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            IconButton(
              icon: Icon(Icons.home),

              onPressed: () {
                Navigator.pop(context);
              },
            ),

            IconButton(icon: Icon(Icons.photo), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
