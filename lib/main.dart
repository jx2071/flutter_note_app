import 'package:first_app/constants/routes.dart';
import 'package:first_app/helpers/loading/loading_screen.dart';
import 'package:first_app/services/auth/bloc/auth_bloc.dart';
import 'package:first_app/services/auth/bloc/auth_event.dart';
import 'package:first_app/services/auth/bloc/auth_state.dart';
import 'package:first_app/services/auth/firebase_auth_provider.dart';
import 'package:first_app/views/notes/notes_view.dart';
import 'package:first_app/views/verify_email_view.dart';
import 'package:first_app/views/register_view.dart';
import 'package:first_app/views/login_view.dart';
import 'package:first_app/views/notes/create_update_note_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
          useMaterial3: true,
        ),
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
        routes: {
          createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please waite a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStatePendingVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
