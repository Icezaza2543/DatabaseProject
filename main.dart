import 'package:datatable_sortable_example/page/page_two.dart';
import 'package:datatable_sortable_example/page/sortable_page.dart';
import 'package:datatable_sortable_example/widget/tabbar_widget.dart';
import 'package:datatable_sortable_example/page/page_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title =
      'What impact is Coronavirus having on the United States?';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: SortablePage(),
      );
}
