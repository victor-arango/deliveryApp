import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/delivery/presentation/providers/tasks_delivery_provider.dart';
import 'package:mensaeria_alv/features/delivery/presentation/screens/widgets/task_delivery_card.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/widgets/no_data_widget.dart';

import 'package:mensaeria_alv/features/shared/shared.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

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
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final ScrollController scrollcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final taskDeliveryState = ref.watch(taskDeliverysProvider);

    if (taskDeliveryState.tasks.isEmpty) {
      return Center(
        child: NoDataWidget(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: MasonryGridView.count(
        controller: scrollcontroller,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: taskDeliveryState.tasks.length,
        itemBuilder: (context, index) {
          final task = taskDeliveryState.tasks[index];
          return GestureDetector(
              onTap: () => context.push('/taskFinishDelivery/${task.id}'),
              child: TaskDeliveryCard(
                taskDelivery: task,
              ));
        },
      ),
    );
  }
}
