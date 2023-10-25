import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late IO.Socket socket;

  @override
  void initState() {
    // socket = IO.io(
    //     'http://192.168.1.7:3000',
    //     IO.OptionBuilder()
    //         .setTransports(['websocket'])
    //         .disableAutoConnect()
    //         .build());

    // socket.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Tareas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nueva Tarea'),
        icon: const Icon(Icons.add),
        onPressed: () => context.push('/form-task'),
      ),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Tareas!'));
  }
}
