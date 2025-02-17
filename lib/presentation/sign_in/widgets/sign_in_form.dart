import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_firebase_ddd/application/auth/auth_bloc.dart';
import 'package:todo_firebase_ddd/presentation/routes/router.gr.dart';

import '../../../application/auth/sign_in_form/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      builder: (context, state) {
        final signInbloc = context.bloc<SignInFormBloc>();
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              const Text(
                '📝',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 130),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (value) => signInbloc.add(SignInFormEvent.emailChanged(value)),
                //#         Using [context.bloc<SignInFormBloc>().state] instead of state, as state contains previous value
                validator: (_) => signInbloc.state.emailAddress.value.fold(
                  (f) => f.maybeMap(
                    invalidEmail: (_) => 'Invalid Email',
                    orElse: () => null,
                  ),
                  (_) => null,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => signInbloc.add(SignInFormEvent.passwordChanged(value)),
                validator: (_) => signInbloc.state.password.value.fold(
                  (f) => f.maybeMap(
                    shortPassword: (_) => 'Short Password',
                    orElse: () => null,
                  ),
                  (_) => null,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () =>
                          signInbloc.add(const SignInFormEvent.signInWithEmailAndPasswordPressed()),
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () => signInbloc
                          .add(const SignInFormEvent.registerWithEmailAndPasswordPressed()),
                      child: const Text('REGISTER'),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () => signInbloc.add(const SignInFormEvent.signInWithGooglePressed()),
                color: Colors.lightBlue,
                child: const Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (state.isSubmitting) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ]
            ],
          ),
        );
      },
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => 'Cancelled',
                  serverError: (_) => 'Server Error',
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPassword: (_) => 'Invalid email and/or password',
                ),
              ).show(context);
            },
            (_) {
              ExtendedNavigator.of(context).replace(Routes.notesOverviewPage);
              context.bloc<AuthBloc>().add(const AuthEvent.authCheckRequested());
            },
          ),
        );
      },
    );
  }
}
