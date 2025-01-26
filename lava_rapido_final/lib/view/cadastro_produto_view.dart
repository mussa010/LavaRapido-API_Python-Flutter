import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lava_rapido_final/model/produto.dart';
import 'package:lava_rapido_final/service/fornecedorService.dart';
import '../model/fornecedor.dart';
import '../service/produtoService.dart';
import 'package:mask/mask/mask.dart';
import '../view/util.dart';

class CadastroProdutoView extends StatefulWidget {
  const CadastroProdutoView({super.key});

  @override
  State<CadastroProdutoView> createState() => _CadastroProdutoView();
}

class _CadastroProdutoView extends State<CadastroProdutoView> {
  var txtModelo = TextEditingController(),
      txtMarca = TextEditingController(),
      txtDescricao = TextEditingController(),
      txtQuantidade = TextEditingController(),
      txtValorUnitario = TextEditingController(),
      txtIdProduto = TextEditingController(),
      formKey = GlobalKey<FormState>();

  int idFornecedor = 0, idProduto = 0;

  var listaNomeFornecedores = ['Selecione'], listaFornecedores = [];

  String valorPadraoDropDownFornecedor = 'Selecione', auxValorDropDown = "";

  @override
  void initState() {
    super.initState();
    FornecedorService().todosFornecedores().then(
      (value) {
        setState(() {
          for (Fornecedor forn in value!) {
            listaNomeFornecedores.add(forn.nome);
            listaFornecedores.add(forn);
          }
        });
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id != null && id != -1) {
        ProdutoService().retornaProduto(id).then((produto) {
          if (produto != null) {
            setState(() {
              txtModelo.text = utf8.decode(produto.modelo.runes.toList());
              txtMarca.text = utf8.decode(produto.marca.runes.toList());
              txtDescricao.text = utf8.decode(produto.descricao.runes.toList());
              txtQuantidade.text = produto.quantidade.toString();
              txtValorUnitario.text = produto.valorUnitario.toString();
              txtIdProduto.text = produto.id.toString();

              Fornecedor? fornecedor = listaFornecedores.firstWhere(
                (forn) => forn.id == produto.idFornecedor,
                orElse: () => null,
              );
              if (fornecedor != null) {
                valorPadraoDropDownFornecedor = fornecedor.nome;
                listaNomeFornecedores.remove('Selecione');
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    if (id != null) {
      idProduto = id as int;
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, 'inicio');
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(id == null ? 'Cadastrar produto' : 'Editar produto',
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
                        controller: txtIdProduto,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.sentences,
                        enabled: false,
                        decoration: const InputDecoration(
                            labelText: 'ID Produto',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    if (id != null) const SizedBox(height: 20),
                    TextFormField(
                      controller: txtModelo,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          labelText: 'Modelo',
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
                      controller: txtMarca,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          labelText: 'Marca',
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
                      controller: txtDescricao,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          labelText: 'Descrição',
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
                      controller: txtQuantidade,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          labelText: 'Quantidade',
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
                      controller: txtValorUnitario,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [Mask.money()],
                      decoration: const InputDecoration(
                          labelText: 'Valor unitário',
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
                    Row(
                      children: [
                        const Text('Fornecedor:   '),
                        DropdownButton(
                          value: valorPadraoDropDownFornecedor,
                          items: listaNomeFornecedores.map((String fornecedor) {
                            return DropdownMenuItem(
                              value: fornecedor,
                              child: Text(fornecedor),
                            );
                          }).toList(),
                          onChanged: (String? novoValor) {
                            setState(() {
                              valorPadraoDropDownFornecedor = novoValor!;
                              if (listaNomeFornecedores.contains('Selecione') &&
                                  valorPadraoDropDownFornecedor !=
                                      'Selecione') {
                                listaNomeFornecedores.remove('Selecione');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                          child: const Center(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'inicio');
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.05)),
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.green),
                              shadowColor:
                                  WidgetStateProperty.all<Color>(Colors.green)),
                          child: const Center(
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (valorPadraoDropDownFornecedor ==
                                  'Selecione') {
                                dialogBox(
                                    context, 'Erro', 'Selecione o fornecedor');
                              } else {
                                for (Fornecedor forn in listaFornecedores) {
                                  if (forn.nome ==
                                      valorPadraoDropDownFornecedor) {
                                    idFornecedor = forn.id;
                                  }
                                }

                                String valorUnitario = "",
                                    aux = txtValorUnitario.text;
                                aux = aux.replaceAll(' ', '');
                                aux = aux.replaceAll('.', '');
                                for (String caractere in aux.split('')) {
                                  if (caractere != 'R' && caractere != '\$') {
                                    if (caractere == ',') {
                                      valorUnitario += '.';
                                    } else {
                                      valorUnitario += caractere;
                                    }
                                  }
                                }

                                Produto produto = Produto(
                                    idProduto,
                                    txtModelo.text,
                                    txtMarca.text,
                                    txtDescricao.text,
                                    int.parse(txtQuantidade.text),
                                    double.parse(valorUnitario),
                                    idFornecedor);
                                if (id == null) {
                                  ProdutoService().novoProduto(produto).then(
                                    (value) {
                                      if (value == 201) {
                                        sucesso(context,
                                            "Produto cadastrado com sucesso!");
                                        idProduto = 0;
                                        txtModelo.text = "";
                                        txtMarca.text = "";
                                        txtDescricao.text = "";
                                        txtQuantidade.text = "";
                                        txtValorUnitario.text = "";
                                      } else if (value == 400) {
                                        dialogBox(context, 'Cadastrar produto',
                                            'Produto já está cadastrado');
                                      }
                                    },
                                  );
                                } else {
                                  ProdutoService()
                                      .atualizarProduto(produto)
                                      .then(
                                    (value) {
                                      if (value == 200) {
                                        sucesso(context,
                                            'Produto atualizado com sucesso');
                                        Navigator.pushReplacementNamed(
                                            context, 'inicio');
                                      } else if (value == 404) {
                                        dialogBox(context, 'Editar produto',
                                            'Produto não encontrado');
                                      }
                                    },
                                  );
                                }
                              }
                            }
                          },
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
