import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:raftlabs_flutter/screens/home_screen.dart';
import 'package:raftlabs_flutter/screens/login_screen.dart';

void main() async {
  // await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink link = HttpLink(
      'https://absolute-krill-56.hasura.app/v1/graphql',
      defaultHeaders: {
        'content-type': 'application/json',
        'x-hasura-admin-secret':
            'gapW3HHwOMTM9LXmZEMiP8suxbjFH3FFSZXrrt8aafI8gKzuCk8BjEZnxYYXr5OV',
      },
    );
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );

    final FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      auth.signOut();
    }

    return GraphQLProvider(
      client: client,
      child: ScreenUtilInit(
          designSize: const Size(390, 830),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: auth.currentUser == null
                  ? const LoginScreen()
                  : const HomeScreen(),
            );
          }),
    );
  }
}
