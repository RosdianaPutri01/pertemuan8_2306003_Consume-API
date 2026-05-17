import 'package:flutter/material.dart';
import 'models/post_model.dart';
import 'services/post_service.dart';
import 'photos_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      title: "Pertemuan 8",
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Postingan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
      ),

      body: PostPage(),

      // tombol navigasi bawah
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),

            IconButton(
              icon: Icon(Icons.photo),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotosPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<List<PostModel>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = PostService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: futurePosts,

      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,

            itemBuilder: (context, index) {
              final post = posts[index];

              return Card(
                margin: EdgeInsets.all(10),

                child: Padding(
                  padding: EdgeInsets.all(10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        post.title,

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(post.body),
                    ],
                  ),
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
    );
  }
}
