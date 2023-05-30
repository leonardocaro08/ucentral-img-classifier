import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:img_classifier/pages/pages.dart';
import 'package:img_classifier/providers/register_form_provider.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../themes/app_theme.dart';
import '../ui/input_decorations.dart';
import '../ui/card_contanier.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterFormProvider(),
      child: _FormularioRegisterPageBody(),
    );
  }
}

class _FormularioRegisterPageBody extends StatelessWidget {
  const _FormularioRegisterPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardContainer(
                // ignore: sort_child_properties_last
                child: Column(
                  children: [
                    Text(
                      'Crear cuenta',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _Form(),
                  ],
                ),
                external_padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                internal_padding: EdgeInsets.all(20),
                borderRadius: BorderRadius.circular(25),
                blurRadius: 15,
                dx: 5,
                dy: 5,
              ),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        AppTheme.primary.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(StadiumBorder()),
                  ),
                  onPressed: () => Navigator.popAndPushNamed(context, 'login'),
                  child: Text(
                    '¿Ya tienes cuenta?',
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    final usuario = registerForm.usuario;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
        key: registerForm.formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Nombre', hintText: 'Shamir Alfonso'),
              onChanged: (value) => usuario!.name = value,
              validator: (value) {
                RegExp regExp = RegExp(
                    r'^[A-ZÁÉÍÓÚÑ][a-záéíóú]+(\s[A-ZÁÉÍÓÚÑ][a-záéíóú]+)?$');
                if (!regExp.hasMatch(value ?? '')) {
                  return 'El valor introducido no es válido';
                }
              },
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Apellido', hintText: 'Lumier Rodriguez'),
              onChanged: (value) => usuario!.last_name = value,
              validator: (value) {
                RegExp regExp = RegExp(
                    r'^[A-ZÁÉÍÓÚÑ][a-záéíóú]+(\s[A-ZÁÉÍÓÚÑ][a-záéíóú]+)?$');
                if (!regExp.hasMatch(value ?? '')) {
                  return 'El valor introducido no es válido';
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Celular',
                  prefix: Icons.phone_outlined,
                  hintText: ''),
              validator: (value) {
                RegExp regExp = RegExp(r'^[3]\d{9}$');
                if (!regExp.hasMatch(value ?? '')) {
                  return 'El valor introducido no es un celular';
                }
                usuario!.phone = value!;
              },
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Correo electrónico',
                  prefix: Icons.alternate_email,
                  hintText: 'email@gmail.com'),
              onChanged: (value) => usuario!.email = value,
              validator: (value) {
                RegExp regExp = RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                if (!regExp.hasMatch(value ?? '')) {
                  return 'El valor introducido no es un email válido';
                }
              },
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  labelText: 'Contraseña',
                  prefix: Icons.lock_outline,
                  hintText: '****'),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                RegExp regExp = RegExp(r'^[\S]{8,}$');
                if (!regExp.hasMatch(value ?? '')) {
                  return 'Mínimo 8 caracteres y sin espacios';
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: AppTheme.primary,
              // ignore: sort_child_properties_last
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                child: Text(
                  registerForm.estaCargando ? 'Espere ' : 'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: registerForm.estaCargando
                  ? null
                  : () async {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      final usuarioService =
                          Provider.of<UserService>(context, listen: false);
                      FocusScope.of(context).unfocus();
                      if (!registerForm.isValidForm()) return;
                      registerForm.estaCargando = true;
                      usuario!.password = authService
                          .generarHashPassword(registerForm.password!);
                      final String? errorMessage = await authService.createUser(
                          usuario.email, usuario.password);
                      if (errorMessage == null) {
                        await usuarioService.salvarOCrearUsuario(usuario);
                        registerForm.estaCargando = false;
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        NotificationsService.showSnackBar(errorMessage);
                        registerForm.estaCargando = false;
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
