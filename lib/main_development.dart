import 'package:flutter/widgets.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_bloc/bootstrap.dart';

Future<void> main() async {
  ///Flutter needs to call native code before calling runApp. So it makes SURE that you have an instance of the WidgetsBinding, which is required to use platform channels to call the native code.
  WidgetsFlutterBinding.ensureInitialized();

  final todosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}
