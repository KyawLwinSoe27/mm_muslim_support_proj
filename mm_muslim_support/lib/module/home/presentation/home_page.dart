import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/dashboard_page.dart';
import 'package:mm_muslim_support/module/home/widgets/drawer_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/today_date_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = <Widget>[DashboardPage(), Center(child: Text('Tracker Page')), Center(child: Text('Tasbir Page')), Center(child: Text('Discover Page'))];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: TodayDateWidget(),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: BlocBuilder<BottomNavigationBarCubit, int>(
        builder: (context, state) {
          return IndexedStack(
            index: state, // <-- use the current state directly
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavigationBarCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state,
            onTap: (index) {
              context.read<BottomNavigationBarCubit>().changePage(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tracker'),
              BottomNavigationBarItem(icon: Icon(Icons.incomplete_circle_rounded), label: 'Tasbir'),
              BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Discover'),
            ],
          );
        },
      ),
    );
  }
}
