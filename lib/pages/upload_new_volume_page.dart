import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/manga_item.dart';
import '../services/api_service.dart';

// Константы для цветов и размеров
const Color primaryColor = Color(0xFFC84B31);
const Color secondaryColor = Color(0xFFECDBBA);
const Color textColor = Color(0xFF56423D);
const Color backgroundColor = Color(0xFF191919);
const Color accentColor = Color(0xFFC84B31);

const double defaultPadding = 16.0;
const double defaultRadius = 10.0;
const double defaultTextSize = 14.0;

class UploadNewVolumePage extends StatefulWidget {
  final ValueChanged<MangaItem?> onItemCreated;

  const UploadNewVolumePage({Key? key, required this.onItemCreated}) : super(key: key);

  @override
  _UploadNewVolumePageState createState() => _UploadNewVolumePageState();
}

class _UploadNewVolumePageState extends State<UploadNewVolumePage> {
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _chaptersController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _shortDescriptionController = TextEditingController();
  final TextEditingController _fullDescriptionController = TextEditingController();
  final TextEditingController _formatController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final List<String> _imageLinks = [];

  final List<String> formatTexts = [
    'Твердый переплет\nФормат издания 19.6 x 12.5 см\nкол-во стр от 380 до 400',
    'Мягкий переплет\nФормат издания 18.0 x 11.0 см\nкол-во стр от 350 до 370',
    'Электронная версия\nФормат издания 19.6 x 12.5 см\nкол-во стр от 380 до 400',
  ];

  final List<String> publisherTexts = [
    'Издательство Терлецки Комикс',
    'Издательство Другое Комикс',
    'Издательство Еще Комикс',
    'Alt Graph',
  ];

  final List<String> chapterTexts = [
    '№ глав: 1-36  + дополнительные истории',
    '№ глав: 37-74',
    '№ глав: 75-112',
    '№ глав: 113-150',
    '№ глав: 151-188',
    '№ глав: 189-226',
    '№ глав: 227-264',
    '№ глав: 265-300',
  ];

  void _addImage() {
    if (_imageLinks.length < 3) {
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController _urlController = TextEditingController();
          return AlertDialog(
            title: const Text("Добавить изображение"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: "Введите ссылку на изображение"),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Пример ссылки: https://example.com/image.jpg",
                  style: TextStyle(color: primaryColor, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String url = _urlController.text.trim();
                  if (url.isNotEmpty && url.startsWith("http")) {
                    setState(() {
                      _imageLinks.add(url);
                      Navigator.of(context).pop();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Пожалуйста, введите корректную ссылку на изображение")),
                    );
                  }
                },
                child: const Text("Добавить"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Отмена"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Максимум 3 изображения")),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageLinks.removeAt(index);
    });
  }

  bool _validateInputs() {
    return _volumeController.text.isNotEmpty &&
           _chaptersController.text.isNotEmpty &&
           _priceController.text.isNotEmpty &&
           _shortDescriptionController.text.isNotEmpty &&
           _fullDescriptionController.text.isNotEmpty &&
           _formatController.text.isNotEmpty &&
           _publisherController.text.isNotEmpty &&
           _imageLinks.isNotEmpty;
  }

  void _submit() async {
    if (_validateInputs()) {
      final newMangaItem = MangaItem(
        id: 0, // Пустой id, так как сервер его сгенерирует
        imagePath: _imageLinks.isNotEmpty ? _imageLinks[0] : '',
        title: _volumeController.text,
        description: _fullDescriptionController.text,
        price: _priceController.text,
        additionalImages: _imageLinks.sublist(1), 
        format: _formatController.text,
        publisher: _publisherController.text,
        shortDescription: _shortDescriptionController.text, 
        chapters: _chaptersController.text, 
      );

      try {
        final createdItem = await ApiService().createProduct(newMangaItem);
        widget.onItemCreated(createdItem);
        Navigator.pop(context, createdItem); // Возвращаем созданный товар
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при создании товара: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пожалуйста, заполните все поля и добавьте хотя бы одно изображение")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Добавить новый том"),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "MANgo100+",
                style: TextStyle(color: primaryColor, fontSize: 36, fontFamily: 'Russo One'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildInputField('Какой том', _volumeController, hintText: 'Например, Том 1'),
                  const SizedBox(height: 15),
                  _buildInputField('Главы', _chaptersController, hintText: 'Например, № глав: 1-36 + дополнительные истории'),
                  const SizedBox(height: 15),
                  _buildInputField('Цена', _priceController, hintText: 'Например, 100 рублей'),
                  const SizedBox(height: 15),
                  _buildDropdownField('Формат издания', _formatController, formatTexts),
                  const SizedBox(height: 15),
                  _buildDropdownField('Издательство', _publisherController, publisherTexts),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Expanded(
                        child: Text("Добавить изображения", style: TextStyle(color: primaryColor)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: secondaryColor),
                        onPressed: _addImage,
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _imageLinks.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text("Image", style: const TextStyle(color: textColor)),
                          if (index == 0) const Text(" (Обложка)", style: TextStyle(color: primaryColor)),
                          if (index > 0) const Text(" (Доп. изображение)", style: TextStyle(color: textColor)),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeImage(index),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextArea('Краткое описание', _shortDescriptionController, height: 88, hintText: 'Например, Знакомство с Кагэямой Сигэо...'),
                  const SizedBox(height: 15),
                  _buildTextArea('Полное описание', _fullDescriptionController, height: 118, hintText: 'Например, Моб сталкивается с новыми врагами...'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  "Опубликовать",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: isMobile ? 16.0 : 20.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textColor,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(defaultRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: const TextStyle(
            color: textColor,
            fontSize: defaultTextSize,
            fontFamily: 'Tektur',
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: secondaryColor,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          onChanged: (String? newValue) {
            setState(() {
              if (newValue == 'Другое') {
                controller.clear(); 
              } else {
                controller.text = newValue!;
              }
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: secondaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(defaultRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: const TextStyle(
            color: textColor,
            fontSize: defaultTextSize,
            fontFamily: 'Tektur',
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea(String label, TextEditingController controller, {required double height, String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: secondaryColor,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(
              color: textColor,
              fontSize: defaultTextSize,
              fontFamily: 'Tektur',
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }
}