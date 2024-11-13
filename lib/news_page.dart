import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'news_model.dart';
import 'login_page.dart';  // Pastikan mengimpor LoginPage

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ApiService apiService = ApiService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image; // Untuk menyimpan gambar yang dipilih
  final picker = ImagePicker();
  bool _isFormVisible = false; // Menyimpan status apakah form terlihat atau tidak
  String? _currentNewsId; // To store the current news ID while editing

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _refreshPage() {
    setState(() {});
  }

  Future<void> _addOrUpdateNews(String? id) async {
    String imageUrl = _image != null ? _image!.path : ''; // hanya untuk ditampilkan sementara

    final news = News(
      id: id ?? '',
      title: titleController.text,
      description: descriptionController.text,
      imageUrl: imageUrl,
    );

    if (id == null) {
      await apiService.createNews(news); // Add new news
    } else {
      await apiService.updateNews(news); // Update existing news
    }
    _refreshPage();
    _clearFields();
  }

  void _clearFields() {
    titleController.clear();
    descriptionController.clear();
    _image = null;
    _currentNewsId = null; // Reset current news ID
  }

  Future<void> _deleteNews(String id) async {
    await apiService.deleteNews(id);
    _refreshPage();
  }

  // To populate the form with existing data when editing
  void _editNews(News news) {
    setState(() {
      titleController.text = news.title;
      descriptionController.text = news.description;
      _image = File(news.imageUrl); // Set image if available
      _currentNewsId = news.id; // Store the current news ID
      _isFormVisible = true; // Show the form for editing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Berita'),
        actions: [
          // Tombol Logout
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Kembali ke halaman login setelah logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1F74EB), Color(0xFF3EC1FF)], // Linear gradient colors
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Form untuk menambah berita (menyembunyikan form jika belum menekan tombol +)
          if (_isFormVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Judul'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                  ),
                  SizedBox(height: 10),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!, height: 100, width: 100),
                  TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("Pilih Gambar"),
                    onPressed: _pickImage,
                  ),
                  ElevatedButton(
                    onPressed: () => _addOrUpdateNews(_currentNewsId),
                    child: Text(_currentNewsId == null ? 'Tambahkan Berita' : 'Perbarui Berita'),
                  ),
                ],
              ),
            ),
          // Tampilan daftar berita
          if (!_isFormVisible) // Hanya menampilkan daftar berita jika form tidak ditampilkan
            Expanded(
              child: FutureBuilder<List<News>>(
                future: apiService.getNews(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final newsList = snapshot.data!;
                  return ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: news.imageUrl.isNotEmpty
                            ? Image.file(
                                File(news.imageUrl),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: 50), // Default icon if no image
                        title: Text(news.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(news.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editNews(news); // Show form with existing news data for editing
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteNews(news.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positioning at bottom-right
      floatingActionButton: Stack(
        children: [
          // Tombol untuk menambah berita
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F74EB), Color(0xFF3EC1FF)], // Linear gradient colors
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isFormVisible = !_isFormVisible; // Toggle status form
                    if (!_isFormVisible) _clearFields(); // Clear fields when closing the form
                  });
                },
                backgroundColor: Colors.transparent, // Set transparent background for gradient
                child: _isFormVisible ? Icon(Icons.arrow_back) : Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
