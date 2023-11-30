// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/task_view_screen.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/widgets/no_data_widget.dart';

import '../providers/task_user_provider.dart';
import 'widgets/task_card.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends ConsumerState<TasksScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void refresh() {
    setState(() {});
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    const _ProductsView(),
    const TaskViewFinish()
  ];

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
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.center,
              haptic: true,
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Colors.black, width: 1),
              tabBorder: Border.all(color: Colors.grey, width: 1),
              tabMargin:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              curve: Curves.easeInOutCirc,
              duration: const Duration(milliseconds: 300),
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              tabBackgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              tabs: const [
                GButton(
                  icon: Icons.warning,
                  text: 'Asignado',
                ),
                GButton(
                  icon: Icons.check,
                  text: 'Finalizado',
                )
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Nueva Tarea'),
          icon: const Icon(Icons.add),
          onPressed: () {
            context.push('/task/new');
          },
          // onPressed: () => context.push('/form-task'),
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

    if (tasksState.tasksUser.isEmpty) {
      return Center(
        child: NoDataWidget(),
      );
    }

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
              onTap: () => context.push('/task/${task.id}'),
              child: TaskCard(taskUser: task));
        },
      ),
    );
  }
}
