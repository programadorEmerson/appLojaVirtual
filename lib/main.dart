import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/order.dart';
import 'package:loja/models/orders_manager.dart';
import 'package:loja/models/product.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/stores_manager.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/Util/Medidas.dart';
import 'package:loja/screens/adrress/address_screen.dart';
import 'package:loja/screens/base_screen/base_scren.dart';
import 'package:loja/screens/cart/cart_screen.dart';
import 'package:loja/models/admin_orders_manager.dart';
import 'package:loja/screens/checkout/checkout_screen.dart';
import 'package:loja/screens/confirmation/confirmation_screen.dart';
import 'package:loja/screens/edit_product/edit_product_screen.dart';
import 'package:loja/screens/login/login_scren.dart';
import 'package:loja/screens/product/product_screen.dart';
import 'package:loja/screens/select_product/select_product_screen.dart';
import 'package:loja/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/admin_users_manager.dart';

void main() => runApp(MyApp());  

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => StoresManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
          cartManager..updateUser(userManager),
          ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
            adminOrdersManager..updateAdmin(
              adminEnabled: userManager.adminEnabled
            ),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
            adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
            ordersManager..updateUser(userManager.user),
        ),
      ],
      child: MaterialApp(
          title: 'Loja Programando Soluções',
          theme: ThemeData(
            primaryColor: const Color(0xff075E54),
            scaffoldBackgroundColor: const Color(0xff075E54),
            appBarTheme: const AppBarTheme(elevation: 0),
            accentColor: Color.fromRGBO(31, 103, 92, 1),
          ),
          home: MyHomePage(title: 'Loja Programando Soluções'),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen()
              );
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                  settings.arguments as Product
                  )
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
                settings: settings
              );
            case '/address':
              return MaterialPageRoute(
                  builder: (_) => AddressScreen()
              );
            case '/checkout':
              return MaterialPageRoute(
                  builder: (_) => CheckoutScreen()
              );
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                    settings.arguments as Product
                  )
              );
            case '/select_product':
              return MaterialPageRoute(
                  builder: (_) => SelectProductScreen()
              );
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) => ConfirmationScreen(
                    settings.arguments as Order)
              );
            case '/base':
              default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings
              );              
          }
        },      
        ),
      );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _introScreen(context);
  }
}

Widget _introScreen(BuildContext context) {
  return LayoutBuilder(builder: (context, constraint) {
    Medidas.larguraTotal = constraint.maxWidth;
    Medidas.alturaTotal = constraint.maxHeight;
    Medidas.fonteTextoBotao = constraint.maxWidth * 0.05;
    Medidas.fonteTexto = constraint.maxWidth * 0.04;
    Medidas.fonteTitulo = constraint.maxWidth * 0.06;
    return Stack(
      children: [
        SplashScreen(
          seconds: 5,
          gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xffF8F8FF), Color(0xffF5FFFA)],
          ),
          navigateAfterSeconds: BaseScreen(),
          loaderColor: Colors.transparent,
        ),
        Container(
          width: constraint.maxWidth,
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "imagens/logoSplash.png",
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        )
      ],
    );
  });
}
