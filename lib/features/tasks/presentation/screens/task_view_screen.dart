import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/widgets/no_data_widget.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/widgets/task_card.dart';

import '../providers/task_user_finish_provider.dart';

class TaskViewFinish extends ConsumerStatefulWidget {
  const TaskViewFinish({super.key});

  @override
  TaskViewFinishState createState() => TaskViewFinishState();
}

class TaskViewFinishState extends ConsumerState {
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
    final tasksState = ref.watch(taskUSerFinishProvider);
    if (tasksState.tasksUserFin.isEmpty) {
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
        itemCount: tasksState.tasksUserFin.length,
        itemBuilder: (context, index) {
          final task = tasksState.tasksUserFin[index];
          return GestureDetector(
              onTap: () => context.push('/taskFinish/${task.id}'),
              child: TaskCard(taskUser: task));
        },
      ),
    );
  }
}
