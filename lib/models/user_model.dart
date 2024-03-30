import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario = null;
  Map<String, dynamic> userdata = {};
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _getUser();
    _loadCurrentuser();
  }

  void singOut() async {
    await _auth.signOut();
    userdata = {};
    usuario = null;
    notifyListeners();
  }

  void singUp(Map<String, dynamic> userdata, String pass,
      VoidCallback onSuccess, Function onFail) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: userdata["email"], password: pass);

      _getUser();
      _loadCurrentuser();
      usuario = await _saveUserData(userdata);

      onSuccess();
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      if (error.code == "weak-password") {
        isLoading = false;
        onFail("Senha muito fraca!");
        notifyListeners();
      } else if (error.code == "email-already-exists") {
        isLoading = false;
        onFail("O email informado já está em uso!");
        notifyListeners();
      } else if (error.code == "internal-error") {
        isLoading = false;
        notifyListeners();
        onFail("Falha ao cria usuário, confira seus dados de login.");
      }
    }
  }

  void singIn(String email, String pass, VoidCallback onSuccess,
      Function onFail) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      await _loadCurrentuser();

      _getUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      if (error.code == "user-not-found") {
        isLoading = false;
        onFail("Usuário não cadastrado!");
        notifyListeners();
      } else if (error.code == "wrong-password") {
        isLoading = false;
        onFail("Senha incorreta!");
        notifyListeners();
      } else if (error.code == "internal-error") {
        isLoading = false;
        notifyListeners();
        onFail("Falha ao logar, confira seus dados de login.");
      }
    }
  }

  void recoverPass(String email, Function onFail) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      onFail("Falhar ao enviar, confira se o email infomar está correto.");
    }
  }

  Future getDoc() async {
    return await FirebaseFirestore.instance.collection('users').doc().get();
  }

  bool isLoadingIn() {
    return usuario != null;
  }

  Future _getUser() async {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  Future _saveUserData(Map<String, dynamic> userData) async {
    userdata = userData;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(usuario!.uid)
        .set(userData);
  }

  Future _loadCurrentuser() async {
    if (usuario == null) _getUser();
    if (usuario != null) {
      if (userdata["name"] == null) {
        var docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(usuario!.uid)
            .get();

        userdata = docUser.data()!;
      }
    }
    notifyListeners();
  }
}
