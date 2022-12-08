import 'package:flutter/widgets.dart';
import 'package:todos_bloc/bootstrap.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}
