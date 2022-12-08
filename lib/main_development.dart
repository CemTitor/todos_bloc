import 'package:flutter/widgets.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_bloc/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}
