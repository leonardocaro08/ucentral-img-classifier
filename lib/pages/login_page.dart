import 'package:flutter/material.dart';
import '../providers/login_form_provider.dart';
import '../ui/card_contanier.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../themes/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20, // Gives some spacing between the image and the card.
        ),
        ClipOval(
          child: Image.asset(
            'assets/icons/dog_classifier_icon.png',
            width: 100, // You can adjust the size as needed.
            height: 100, // You can adjust the size as needed.
          ),
        ),
        SizedBox(
          height: 20, // Gives some spacing between the image and the card.
        ),
        CardContainer(
          // ignore: sort_child_properties_last
          child: Column(
            children: [
              Text(
                'Inicio de sesión',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                height: 20,
              ),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: _LoginForm(),
              ),
            ],
          ),
          external_padding: EdgeInsets.symmetric(horizontal: 30),
          internal_padding: EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(25),
          blurRadius: 15,
          dx: 5,
          dy: 5,
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
            shape: MaterialStateProperty.all(StadiumBorder()),
          ),
          onPressed: () => Navigator.popAndPushNamed(context, 'registro'),
          child: Text(
            'Registrarse',
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final userService = Provider.of<UserService>(context);
    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                labelText: 'Correo electrónico',
                prefix: Icons.alternate_email,
                hintText: 'correo@gmail.com'),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'No es un correo';
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
                labelText: 'Contraseña',
                prefix: Icons.lock_outline,
                hintText: '***'),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              if (value != null && value.length >= 8) {
                return null;
              }
              return 'La contraseña debe contener mínimo 8 caracteres';
            },
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: AppTheme.primary,
            // ignore: sort_child_properties_last
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.estaCargando ? 'Espere ' : 'Ingresar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: loginForm.estaCargando
                ? null
                : () async {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;
                    loginForm.estaCargando = true;
                    final String? errorMessage = await authService.login(
                        loginForm.email,
                        authService.generarHashPassword(loginForm.password,
                            sal: await authService
                                .obtenerSalUsuario(loginForm.email)));
                    if (errorMessage == null) {
                      userService.usuario_logueado.email = loginForm.email;
                      await userService.loadUsuario();
                      Navigator.pushReplacementNamed(context, "inicio");
                    } else {
                      NotificationsService.showSnackBar(
                          'Correo y/o contraseña incorrectos');
                      loginForm.estaCargando = false;
                    }
                  },
          ),
        ],
      ),
    );
  }
}
