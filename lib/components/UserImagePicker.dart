import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;
  const UserImagePicker({super.key, required this.onImagePick});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  // 1.  MÉTODO PARA RECUPERAR DADOS PERDIDOS
  Future<void> _retrieveLostData() async {
    final ImagePicker picker = ImagePicker();
    // Faz a verificação se há dados perdidos
    final LostDataResponse response = await picker.retrieveLostData();
    // Se não há nada a recuperar, apenas retorna
    if (response.isEmpty) {
      return;
    }
    // Se há arquivos recuperados
    final List<XFile>? files = response.files;
    if (files != null && files.isEmpty) {
      // Pega o primeiro arquivo (este widget só lida com uma imagem)
      final XFile pickedFile = files.first;
      setState(() {
        _image = File(pickedFile.path);
      });
      // Envia a imagem recuperada para o widget pai
      widget.onImagePick(_image!);
    } else {
      if (kDebugMode) {
        print(response.exception);
      }
    }
  }

  Future<void> _pickerImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      // Cria o arquivo a partir da imagem escolhida
      final newImage = File(pickedImage.path);
      setState(() {
        _image = newImage;
      });
      // Isso evita o erro de nulo caso o usuário cancele a seleção
      widget.onImagePick(newImage);
    }
  }

  @override
  void initState() {
    super.initState();
    // 2. CHAMAMOS A VERIFICAÇÃO QUANDO O WIDGET É INICIADO
    // Isso garante que, se o app foi fechado pelo SO, recuperamos a imagem
    // Usamos um Future.microtask para garantir que seja executado após a primeira build
    Future.microtask(() => _retrieveLostData());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton(
          onPressed: _pickerImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text('Adicionar Imagem'),
            ],
          ),
        ),
      ],
    );
  }
}
