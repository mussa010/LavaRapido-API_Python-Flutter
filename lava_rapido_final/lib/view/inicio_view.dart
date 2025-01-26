import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/produto.dart';
import '../model/fornecedor.dart';
import '../service/fornecedorService.dart';
import '../service/produtoService.dart';
import 'package:intl/intl.dart';

final formatacaoModeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

dynamic fornecedorDataSource;
dynamic produtoDataSource;

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioView();
}

class _InicioView extends State<InicioView> {
  final StreamController<List<Fornecedor>> _fornecedorStreamController =
      StreamController<List<Fornecedor>>();
  final StreamController<List<Produto>> _produtoStreamController =
      StreamController<List<Produto>>();

  bool fornecedorExiste = false;
  bool produtoExiste = false;

  @override
  void initState() {
    super.initState();
    _consultaAPI();
  }

  @override
  void dispose() {
    _fornecedorStreamController.close();
    _produtoStreamController.close();
    super.dispose();
  }

  void _consultaAPI() {
    Timer.periodic(const Duration(seconds: 2), (_) async {
      List<Fornecedor>? fornecedores =
          await FornecedorService().todosFornecedores();
      List<Produto>? produtos = await ProdutoService().todosProdutos();

      fornecedorDataSource = FornecedorDataSource(
        fornecedores: fornecedores ?? [],
        onDelete: _deletarFornecedor,
        onEdit: _editarFornecedor,
      );

      produtoDataSource = ProdutoDataSource(
        produtos: produtos ?? [],
        fornecedores: fornecedores ?? [],
        onDelete: _deletarProduto,
        onEdit: _editarProduto,
      );

      _fornecedorStreamController.add(fornecedores ?? []);
      _produtoStreamController.add(produtos ?? []);
    });
  }

  void _editarFornecedor(int id) {
    Navigator.pushNamed(context, 'cadastroFornecedor', arguments: id)
        .then((value) {
      _consultaAPI();
    });
  }

  void _deletarFornecedor(Fornecedor fornecedor) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: Text(
            "Tem certeza de que deseja excluir o fornecedor ${fornecedor.nome}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Excluir")),
        ],
      ),
    );

    if (confirm) {
      await FornecedorService().deletarFornecedor(fornecedor.id);
      _consultaAPI();
    }
  }

  void _editarProduto(int id) {
    Navigator.pushNamed(context, 'cadastroProduto', arguments: id)
        .then((value) {
      _consultaAPI();
    });
  }

  void _deletarProduto(Produto produto) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: Text(
            "Tem certeza de que deseja excluir o produto ${produto.modelo}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Excluir")),
        ],
      ),
    );

    if (confirm) {
      await ProdutoService().deletarProduto(produto.id);
      _consultaAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Tela inicial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: PopScope(
        canPop: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'cadastroFornecedor',
                              arguments: null);
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 40),
                            backgroundColor: Colors.blue),
                        child: const Text(
                          'Adicionar fornecedor',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: () {
                          FornecedorService().quantidadeFornecedor().then(
                            (value) {
                              if (value == 0) {
                                dialogBox(context, "Cadastro produto",
                                    "Não há fornecedores cadastrados.");
                              } else {
                                Navigator.pushNamed(context, 'cadastroProduto',
                                    arguments: null);
                              }
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 40),
                            backgroundColor: Colors.blue),
                        child: const Text(
                          'Adicionar produto',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  StreamBuilder<List<Fornecedor>>(
                    stream: _fornecedorStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text(
                          'Não há fornecedores cadastrados',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ));
                      }

                      return _tabelaFornecedores();
                    },
                  ),
                  const SizedBox(height: 40),
                  StreamBuilder(
                      stream: _produtoStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'Não há produtos cadastrados',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }

                        return _tabelaProdutos();
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _tabelaFornecedores() {
  return Column(
    children: [
      const Text(
        "Tabela fornecedor",
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 30),
      SfDataGrid(
          groupCaptionTitleFormat: 'Fornecedores',
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          source: fornecedorDataSource,
          allowSorting: true,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridColumn(
              columnName: 'ID',
              label: Container(
                  alignment: Alignment.center, child: const Text('ID')),
            ),
            GridColumn(
              columnName: 'Nome',
              label: Container(
                  alignment: Alignment.center, child: const Text('Nome')),
            ),
            GridColumn(
              columnName: 'CNPJ',
              label: Container(
                  alignment: Alignment.center, child: const Text('CNPJ')),
            ),
            GridColumn(
              columnName: 'Telefone',
              label: Container(
                  alignment: Alignment.center, child: const Text('Telefone')),
            ),
            GridColumn(
              columnName: 'E-mail',
              label: Container(
                  alignment: Alignment.center, child: const Text('E-mail')),
            ),
            GridColumn(
              columnName: 'CEP',
              label: Container(
                  alignment: Alignment.center, child: const Text('CEP')),
            ),
            GridColumn(
              columnName: 'Logradouro',
              label: Container(
                  alignment: Alignment.center, child: const Text('Logradouro')),
            ),
            GridColumn(
              columnName: 'Bairro',
              label: Container(
                  alignment: Alignment.center, child: const Text('Bairro')),
            ),
            GridColumn(
              columnName: 'Número',
              label: Container(
                  alignment: Alignment.center, child: const Text('Número')),
            ),
            GridColumn(
              columnName: 'Complemento',
              label: Container(
                  alignment: Alignment.center,
                  child: const Text('Complemento')),
            ),
            GridColumn(
              columnName: 'Cidade',
              label: Container(
                  alignment: Alignment.center, child: const Text('Cidade')),
            ),
            GridColumn(
              columnName: 'Estado',
              label: Container(
                  alignment: Alignment.center, child: const Text('Estado')),
            ),
            GridColumn(
                columnName: 'acoes',
                label: Container(
                    alignment: Alignment.center, child: const Text('Ações')),
                allowSorting: false),
          ]),
    ],
  );
}

Widget _tabelaProdutos() {
  return Column(
    children: [
      const Text(
        "Tabela produto",
        style: TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 30),
      SfDataGrid(
          groupCaptionTitleFormat: 'Produtos',
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          source: produtoDataSource,
          allowSorting: true,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridColumn(
              columnName: 'ID',
              label: Container(
                  alignment: Alignment.center, child: const Text('ID')),
            ),
            GridColumn(
              columnName: 'Modelo',
              label: Container(
                  alignment: Alignment.center, child: const Text('Modelo')),
            ),
            GridColumn(
              columnName: 'Marca',
              label: Container(
                  alignment: Alignment.center, child: const Text('Marca')),
            ),
            GridColumn(
              columnName: 'Descrição',
              label: Container(
                  alignment: Alignment.center, child: const Text('Descrição')),
            ),
            GridColumn(
              columnName: 'Quantidade',
              label: Container(
                  alignment: Alignment.center, child: const Text('Quantidade')),
            ),
            GridColumn(
              columnName: 'Valor unitário',
              label: Container(
                  alignment: Alignment.center,
                  child: const Text('Valor unitário')),
            ),
            GridColumn(
              columnName: 'Valor total',
              label: Container(
                  alignment: Alignment.center,
                  child: const Text('Valor total')),
            ),
            GridColumn(
              columnName: 'Fornecedor',
              label: Container(
                  alignment: Alignment.center, child: const Text('Fornecedor')),
            ),
            GridColumn(
                columnName: 'acoes',
                label: Container(
                    alignment: Alignment.center, child: const Text('Ações')),
                allowSorting: false),
          ]),
    ],
  );
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

class FornecedorDataSource extends DataGridSource {
  final List<Fornecedor>? fornecedores;
  final Function(int) onEdit;
  final Function(Fornecedor) onDelete;

  FornecedorDataSource({
    required this.fornecedores,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  List<DataGridRow> get rows => fornecedores!.map((fornecedor) {
        return DataGridRow(cells: [
          DataGridCell(columnName: 'ID', value: fornecedor.id),
          DataGridCell(
              columnName: 'Nome',
              value: utf8.decode(fornecedor.nome.runes.toList())),
          DataGridCell(columnName: 'CNPJ', value: fornecedor.cnpj),
          DataGridCell(columnName: 'Telefone', value: fornecedor.telefone),
          DataGridCell(
              columnName: 'E-mail',
              value: utf8.decode(fornecedor.email.runes.toList())),
          DataGridCell(columnName: 'CEP', value: fornecedor.cep),
          DataGridCell(
              columnName: 'Logradouro',
              value: utf8.decode(fornecedor.logradouro.runes.toList())),
          DataGridCell(
              columnName: 'Bairro',
              value: utf8.decode(fornecedor.bairro.runes.toList())),
          DataGridCell(columnName: 'Número', value: fornecedor.numero),
          DataGridCell(
              columnName: 'Complemento',
              value: utf8.decode(fornecedor.complemento.runes.toList())),
          DataGridCell(
              columnName: 'Cidade',
              value: utf8.decode(fornecedor.cidade.runes.toList())),
          DataGridCell(
              columnName: 'Estado',
              value: utf8.decode(fornecedor.estado.runes.toList())),
          DataGridCell(columnName: 'acoes', value: fornecedor),
        ]);
      }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Constrói as células da linha
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'acoes') {
          // Renderiza os botões de ações (editar e excluir)
          final fornecedor = cell.value as Fornecedor;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(fornecedor.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(fornecedor),
              ),
            ],
          );
        }

        // Renderiza texto para as outras colunas
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.visible,
          ),
        );
      }).toList(),
    );
  }
}

class ProdutoDataSource extends DataGridSource {
  final List<Produto>? produtos;
  final List<Fornecedor>? fornecedores;
  final Function(int) onEdit;
  final Function(Produto) onDelete;

  ProdutoDataSource({
    required this.produtos,
    required this.fornecedores,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  List<DataGridRow> get rows => produtos!.map((produto) {
        String nomeFornecedor = "";
        for (Fornecedor forn in fornecedores!) {
          if (produto.idFornecedor == forn.id) {
            nomeFornecedor = forn.nome;
          }
        }
        return DataGridRow(cells: [
          DataGridCell(columnName: 'ID', value: produto.id),
          DataGridCell(
              columnName: 'Modelo',
              value: utf8.decode(produto.modelo.runes.toList())),
          DataGridCell(
              columnName: 'Marca',
              value: utf8.decode(produto.marca.runes.toList())),
          DataGridCell(
              columnName: 'Descrição',
              value: utf8.decode(produto.descricao.runes.toList())),
          DataGridCell(columnName: 'Quantidade', value: produto.quantidade),
          DataGridCell(
              columnName: 'Valor unitário', value: formatacaoModeda.format(produto.valorUnitario)),
          DataGridCell(
              columnName: 'Valor total',
              value: formatacaoModeda
                  .format(produto.valorUnitario * produto.quantidade)),
          DataGridCell(
              columnName: 'Fornecedor',
              value: utf8.decode(nomeFornecedor.runes.toList())),
          DataGridCell(columnName: 'acoes', value: produto),
        ]);
      }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Constrói as células da linha
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'acoes') {
          // Renderiza os botões de ações (editar e excluir)
          final produto = cell.value as Produto;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(produto.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(produto),
              ),
            ],
          );
        }

        // Renderiza texto para as outras colunas
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.visible,
          ),
        );
      }).toList(),
    );
  }
}
