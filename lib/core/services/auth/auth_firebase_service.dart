import 'dart:async';
import 'dart:io';

import 'package:chat_flutter/core/models/chat_user.dart';
import 'package:chat_flutter/core/services/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  final auth = FirebaseAuth.instance;

  static ChatUser? _currentUser;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();

    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser => _currentUser;

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  @override
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('(Error) AuthFirebaseService:login = $e');
    }
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    try {
      // Cria user com email e senha
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) return;

      // 1. Upload da foto do usário
      final imageName = '${credential.user!.uid}.jpg';
      final imageURL = await _uploadUserImage(image, imageName);

      // 2. Atualiza nome atributos do usuarios
      credential.user?.updateDisplayName(name);
      credential.user?.updatePhotoURL(imageURL);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'weak-passwordemail-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('(Error) AuthFirebaseService:signup = $e');
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static ChatUser _toChatUser(User userFirebase) {
    return ChatUser(
      id: userFirebase.uid,
      name: userFirebase.displayName ?? userFirebase.email!.split('@')[0],
      email: userFirebase.email!,
      imageUrl: userFirebase.photoURL ?? 'assets/images/avatar.png',
    );
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;

    /// [ref()] usando o bucket padrao. [child] podem ser aninhados. ex: user_images/avatar.png
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }
}
