import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lava_rapido_final/view/cadastro_fornecedor_view.dart';
import 'package:lava_rapido_final/view/cadastro_produto_view.dart';

import '../view/inicio_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue
    )
  );

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'inicio',
      localizationsDelegates:  const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales:  const [
        Locale('pt', 'BR')
      ],
      routes: {
        'inicio' : (context) => const InicioView(),
        'cadastroFornecedor' : (context) => const CadastroFornecedorView(),
        'cadastroProduto' : (context) => const CadastroProdutoView()
      },
    );
  }
}
