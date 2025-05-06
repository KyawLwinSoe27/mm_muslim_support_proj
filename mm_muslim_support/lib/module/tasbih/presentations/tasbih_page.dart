import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/tasbih_model.dart';
import 'package:mm_muslim_support/module/home/cubit/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key, required this.tasbih});
  static String routeName = 'tasbih';
  final List<TasbihModel> tasbih;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TasbihCounterCubit, TasbihCounterState>(
        listener: (context, state) {
          context.read<TasbihCounterCubit>().total = tasbih[state.tasbihIndex].count;
          context.read<TasbihCounterCubit>().tasbihListLength = tasbih.length;
          if (state.finished) {
            DialogUtils.showSuccessDialog(context, 'Tasbih Finished');
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(color: const Color(0xFF3C6950), borderRadius: BorderRadius.circular(10)),
                  child: Text(tasbih[state.tasbihIndex].arabic, style: const TextStyle(fontSize: 26, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Text(tasbih[state.tasbihIndex].translation, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => context.read<TasbihCounterCubit>().increment(state.tasbihIndex),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(color: context.colorScheme.tertiary, shape: BoxShape.circle, border: Border.all(color: context.colorScheme.tertiaryContainer, width: 15)),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${state.count}',
                              style: TextStyle(fontSize: 48, color: context.colorScheme.onTertiary),
                            ),
                            TextSpan(
                              text: '/',
                              style: TextStyle(fontSize: 38, color: context.colorScheme.onTertiary), // smaller font for `/`
                            ),
                            TextSpan(
                              text: '${tasbih[state.tasbihIndex].count}',
                              style: TextStyle(fontSize: 38, color: context.colorScheme.onTertiary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(Icons.refresh, () => context.read<TasbihCounterCubit>().reset()),

                    _buildIconButton(Icons.add, () => context.read<TasbihCounterCubit>().increment(state.tasbihIndex), radius: 38),
                    // _buildIconButton(
                    //   _soundOn ? Icons.volume_up : Icons.volume_off,
                    //   _toggleSound,
                    // ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed, {double radius = 28}) {
    return CircleAvatar(radius: radius, backgroundColor: const Color(0xFF3C6950), child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed));
  }
}
