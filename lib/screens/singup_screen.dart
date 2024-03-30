// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtal_store/models/result_cep_model.dart';
import 'package:virtal_store/models/user_model.dart';
import 'package:virtal_store/widgets/circular_indicator.dart';
import 'package:virtal_store/widgets/text_field.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _cepController = TextEditingController();
  final _nameStreetController = TextEditingController();
  final _numberAddressController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  late var teste = {};
  bool verifica = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 214, 21, 125),
        title: const Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return const CircularIndicator();
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome Comleto",
                ),
                validator: (text) {
                  if (text!.isEmpty) {
                    return "Nome Invalido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text!.isEmpty || !text.contains("@")) {
                    return "E-mail Invalido";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Senha",
                  hintText: "Sua senha deve conter no minimo 7 caracteres.",
                ),
                obscureText: true,
                validator: (text) {
                  if (text!.isEmpty || text.length < 6) {
                    return "Senha invalida";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    // Campo de texo da barra de pesquisa.
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _cepController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "CEP",
                        hintText: "Exp: 80800-800",
                      ),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "CEP Invalido";
                        }
                        return null;
                      },
                    ),
                  ),
                  //Botão de pesquisa.
                  TextButton(
                    onPressed: () async {
                      final result =
                          await ViaCepService.requestAPI(_cepController.text);
                      teste = jsonDecode(result);
                      setState(() {
                        verifica = true;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              verifica == true
                  ? Column(
                      children: [
                        TextFieldAux(
                          label: teste['logradouro'],
                          enable: false,
                          controller: _nameStreetController,
                          hint: "",
                          keyType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextFieldAux(
                          label: "Nº da residência.",
                          enable: true,
                          controller: _numberAddressController,
                          hint: "",
                          keyType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextFieldAux(
                          label: "Bairro: ${teste['bairro']}",
                          enable: false,
                          controller: _districtController,
                          hint: "",
                          keyType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextFieldAux(
                          label: "Cidade: ${teste['localidade']}",
                          enable: false,
                          controller: _cityController,
                          hint: "",
                          keyType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextFieldAux(
                          label: "Estado: ${teste['uf']}",
                          enable: false,
                          controller: _stateController,
                          hint: "",
                          keyType: TextInputType.number,
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cepController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _nameController.text.isNotEmpty &&
                        _passController.text.isNotEmpty
                    ? () {
                        if (_formKey.currentState!.validate() &&
                            _cepController.text.isNotEmpty) {
                          Map<String, dynamic> userdata = {
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "address": teste['logradouro'],
                            "district": teste['bairro'],
                            "state": teste['uf'],
                            "numberAddress": _numberAddressController.text,
                            "cep": teste['cep'],
                          };

                          model.singUp(userdata, _passController.text,
                              _onSuccess, _onFail);
                        }
                        setState(() {
                          verifica = true;
                        });
                      }
                    : null,
                child: const Text(
                  "CRIAR CONTA",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Usuario criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 2),
    ));
    Future.delayed(const Duration(seconds: 2)).then((__) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Falha ao cria usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
