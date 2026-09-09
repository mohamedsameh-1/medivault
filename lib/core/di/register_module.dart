import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}
