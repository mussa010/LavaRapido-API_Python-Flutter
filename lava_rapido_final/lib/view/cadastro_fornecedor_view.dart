import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lava_rapido_final/view/util.dart';
import '../model/fornecedor.dart';
import '../service/fornecedorService.dart';
import 'package:mask/mask/mask.dart';
import '../model/endereco.dart';
import '../service/cepService.dart';

class CadastroFornecedorView extends StatefulWidget {
  const CadastroFornecedorView({super.key});

  @override
  State<CadastroFornecedorView> createState() => _CadastroFornecedorView();
}

class _CadastroFornecedorView extends State<CadastroFornecedorView> {
  var txtNome = TextEditingController(),
      txtCNPJ = TextEditingController(),
      txtTelefone = TextEditingController(),
      txtEmail = TextEditingController(),
      txtCEP = TextEditingController(),
      txtLogradouro = TextEditingController(),
      txtBairro = TextEditingController(),
      txtNumero = TextEditingController(),
      txtComplemento = TextEditingController(),
      txtCidade = TextEditingController(),
      txtEstado = TextEditingController(),
      txtIdFornecedor = TextEditingController(),
      formKey = GlobalKey<FormState>();

  int idFornecedor = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final id = ModalRoute.of(context)!.settings.arguments as int;

        FornecedorService().retornaFornecedor(id).then(
          (value) {
            txtNome.text = utf8.decode(value!.nome.runes.toList());
            txtCNPJ.text = value.cnpj;
            txtTelefone.text = value.telefone;
            txtEmail.text = utf8.decode(value.email.runes.toList());
            txtCEP.text = value.cep;
            txtLogradouro.text = utf8.decode(value.logradouro.runes.toList());
            txtBairro.text = utf8.decode(value.bairro.runes.toList());
            txtNumero.text = value.numero.toString();
            txtComplemento.text = utf8.decode(value.complemento.runes.toList());
            txtCidade.text = utf8.decode(value.cidade.runes.toList());
            txtEstado.text = utf8.decode(value.estado.runes.toList());
            txtIdFornecedor.text = value.id.toString();

            if (int.parse(value.toJson().toString()) == -1) {
              idFornecedor = 0;
            } else {
              idFornecedor = value.id;
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;

    if (id != null) {
      idFornecedor = id as int;
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'inicio');
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                id == null ? 'Cadastrar fornecedor' : 'Editar fornecedor',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'inicio');
              },
              color: Colors.white,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (id != null)
                      TextFormField(
                        controller: txtIdFornecedor,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.sentences,
                        enabled: false,
                        decoration: const InputDecoration(
                            labelText: 'ID Fornecedor',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    if (id != null) const SizedBox(height: 20),
                    TextFormField(
                      controller: txtNome,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtCNPJ,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [Mask.cnpj()],
                      decoration: const InputDecoration(
                          labelText: 'CNPJ',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtTelefone,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [
                        Mask.generic(masks: [
                          '+## (##) ####-####',
                          '+## (##) #####-####'
                        ])
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Telefone',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtEmail,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtCEP,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [
                        Mask.generic(masks: ['#####-###'])
                      ],
                      decoration: const InputDecoration(
                          labelText: 'CEP',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == 9) {
                          String cepNotFormatted = '';

                          for (int i = 0; i < value.length; i++) {
                            if (value[i] != '-') {
                              cepNotFormatted += value[i];
                            }
                          }

                          Future<Endereco?> end = EnderecoService()
                              .listarInformacoesEnderecoPorCep(cepNotFormatted);
                          end.then(
                            (value) {
                              if (value != null) {
                                setState(() {
                                  txtLogradouro.text = value.getLogradouro();
                                  txtBairro.text = value.getBairro();
                                  txtCidade.text = value.getCidade();
                                  txtEstado.text = value.getEstado();
                                });
                              } else {
                                dialogBox(
                                    context, 'Erro', 'CEP não encontrado!');
                              }
                            },
                          );
                        } else {
                          setState(() {
                            txtLogradouro.text = '';
                            txtBairro.text = '';
                            txtCidade.text = '';
                            txtEstado.text = '';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtLogradouro,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
                      decoration: const InputDecoration(
                          labelText: 'Logradouro',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtBairro,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
                      decoration: const InputDecoration(
                          labelText: 'Bairro',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtNumero,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          labelText: 'Numero',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtComplemento,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          labelText: 'Complemento',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtCidade,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
                      decoration: const InputDecoration(
                          labelText: 'Cidade',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: txtEstado,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
                      decoration: const InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      validator: (value) {
                        if (value == null) {
                          return 'Campo vazio';
                        } else if (value.isEmpty) {
                          return 'Campo vazio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.05)),
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.red),
                              shadowColor:
                                  WidgetStateProperty.all<Color>(Colors.red)),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'inicio');
                          },
                          child: const Text('Cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.05)),
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.green),
                              shadowColor:
                                  WidgetStateProperty.all<Color>(Colors.green)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Fornecedor fornecedor = Fornecedor(
                                  idFornecedor,
                                  txtNome.text,
                                  txtCNPJ.text,
                                  txtTelefone.text,
                                  txtEmail.text,
                                  txtCEP.text,
                                  txtLogradouro.text,
                                  txtBairro.text,
                                  int.parse(txtNumero.text),
                                  txtComplemento.text,
                                  txtCidade.text,
                                  txtEstado.text);
                              if (id == null) {
                                FornecedorService()
                                    .novoFornecedor(fornecedor)
                                    .then(
                                  (value) {
                                    if (value == 201) {
                                      sucesso(context,
                                          'Fornecedor cadastrado com sucesso');
                                      idFornecedor = 0;
                                      txtNome.text = "";
                                      txtCNPJ.text = "";
                                      txtTelefone.text = "";
                                      txtEmail.text = "";
                                      txtCEP.text = "";
                                      txtLogradouro.text = "";
                                      txtBairro.text = "";
                                      txtNumero.text = "";
                                      txtComplemento.text = "";
                                      txtCidade.text = "";
                                      txtEstado.text = "";
                                    } else if (value == 400) {
                                      dialogBox(context, 'Cadastrar fornecedor',
                                          'Fornecedor já está cadastrado');
                                    }
                                  },
                                );
                              } else {
                                FornecedorService()
                                    .atualizarFornecedor(fornecedor)
                                    .then(
                                  (value) {
                                    if (value == 200) {
                                      sucesso(context,
                                          'Fornecedor atualizado com sucesso');
                                      Navigator.pushReplacementNamed(
                                          context, 'inicio');
                                    } else if (value == 404) {
                                      dialogBox(context, 'Editar fornecedor',
                                          'Fornecedor não encontrado');
                                    } else if (value == 400) {
                                      dialogBox(context, 'Editar fornecedor',
                                          'CNPJ utilizado por outro fornecedor');
                                    }
                                  },
                                );
                              }
                            }
                          },
                          child: const Text('Salvar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

dialogBox(context, titulo, mensagem) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
          style: const ButtonStyle(
            elevation: WidgetStatePropertyAll(30),
            backgroundColor: WidgetStatePropertyAll(Colors.green),
          ),
          onPressed: () => Navigator.pop(context, 'Ok'),
          child: const Text('Ok', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
