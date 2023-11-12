import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';

import '../providers/task_user_provider.dart';
import 'widgets/task_card.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends ConsumerState<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    final selectedTabIndex = _tabController.index;
    final status = selectedTabIndex == 0 ? 'ASIGNADO' : 'FINALIZADO';
    ref.read(taskUSerProvider.notifier).changeTab(status);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Tareas'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              margin: const EdgeInsets.only(top: 50, bottom: 25),
              child: TabBar(
                unselectedLabelColor: Colors.grey[400],
                indicator: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black, width: 2.0)),
                ),
                controller: _tabController,
                tabs: const [
                  Tab(child: Text('ASIGNADO')),
                  Tab(child: Text('FINALIZADO')),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            // Widget para las tareas pendientes
            _ProductsView(),
            // Widget para las tareas finalizadas
            _TaskView()
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Nueva Tarea'),
          icon: const Icon(Icons.add),
          onPressed: () => context.push('/form-task'),
        ),
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
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: tasksState.tasksUser.length,
        itemBuilder: (context, index) {
          final task = tasksState.tasksUser[index];
          return GestureDetector(
              onTap: () => context.push('/product/${task.id}'),
              child: TaskCard(taskUser: task));
        },
      ),
    );
  }
}

class _TaskView extends ConsumerStatefulWidget {
  const _TaskView();

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
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
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: tasksState.tasksUserFin.length,
        itemBuilder: (context, index) {
          final task = tasksState.tasksUserFin[index];
          return GestureDetector(
              onTap: () => context.push('/task/${task.id}'),
              child: TaskCard(taskUser: task));
        },
      ),
    );
  }
}
