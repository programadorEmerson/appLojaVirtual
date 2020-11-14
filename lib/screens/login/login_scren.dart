import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:loja/helpers/validators.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, child){
                if(userManager.loadingFace){
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                          padding: EdgeInsets.only(left: 32, right: 32,bottom: 10),
                          child: Image.asset("imagens/logoSplash.png"),
                        ),
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email){
                        if(!emailValid(email))
                          return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass){
                        if(pass.isEmpty || pass.length < 6)
                          return 'Senha inválida';
                        return null;
                      },
                    ),
                    child,
                    Align(
                          alignment: Alignment.center,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/signup');
                              },                              
                              child: Text(
                                ' Não tem uma conta? Cadastre-se ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                        ),
                    const SizedBox(height: 0,),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading ? null : (){
                        if(formKey.currentState.validate()){
                          userManager.signIn(
                            user: User(
                                email: emailController.text,
                                password: passController.text
                            ),
                            onFail: (e){
                              scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Falha ao entrar: $e'),
                                    backgroundColor: Colors.red,
                                  )
                              );
                            },
                            onSuccess: (){
                              Navigator.of(context).pop();
                              Navigator.pushNamedAndRemoveUntil(context, "/principal", (_) => false);
                            }
                          );
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor
                          .withAlpha(100),
                      textColor: Colors.white,
                      child: userManager.loading ?
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ) :
                      const Text(
                        'Entrar',
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                    ),
                    const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                          child: RaisedButton(
                              onPressed: userManager.loading
                                  ? null
                                  : () {
                                      Navigator.pushNamedAndRemoveUntil(context, "/principal", (_) => false);
                                    },
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                                  Theme.of(context).primaryColor.withAlpha(100),
                              textColor: Colors.white,
                              child: Text('Entrar sem login',
                                  style: TextStyle(
                                  fontSize: 15))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                    SizedBox(
                          height: 40,
                          child: SignInButton(
                      Buttons.Facebook,
                      text: 'Entrar com Facebook',
                      onPressed: (){
                        userManager.facebookLogin(
                          onFail: (e){
                            scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Falha ao entrar: $e'),
                                  backgroundColor: Colors.red,
                                )
                            );
                          },
                          onSuccess: (){
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(context, "/principal", (_) => false);
                          }
                        );
                      },
                    ),
                        ),
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: (){

                  },
                  padding: EdgeInsets.zero,
                  child: const Text(
                      'Esqueci minha senha'
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
