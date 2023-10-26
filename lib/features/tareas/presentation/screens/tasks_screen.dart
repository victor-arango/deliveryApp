import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../providers/task_user_provider.dart';

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

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    ref.read(taskUSerProvider.notifier).loadTask();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(taskUSerProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: tasksState.tasksUser.length,
            itemBuilder: (context, index) {
              final task = tasksState.tasksUser[index];
              return Text(task.descripcion);
            }));
  }
}
