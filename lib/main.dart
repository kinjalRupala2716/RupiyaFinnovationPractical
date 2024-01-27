import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/firebase_options.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/provider/camera_provider.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/screens/auth_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => CameraProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // final CameraDescription camera;
  const MyApp({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
