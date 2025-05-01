import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/tasbih_model.dart';
import 'package:mm_muslim_support/module/home/cubit/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key, required this.tasbih});

  final List<TasbihModel> tasbih;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<TasbihCounterCubit, TasbihCounterState>(
          listener: (context,state) {
            context.read<TasbihCounterCubit>().total = tasbih[state.tasbihIndex].count;
            context.read<TasbihCounterCubit>().tasbihListLength = tasbih.length;
            if(state.finished) {
              DialogUtils.showSuccessDialog(context, 'Tasbih Finished');
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF3C6950),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tasbih[state.tasbihIndex].arabic,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Text(tasbih[state.tasbihIndex].translation, style: TextStyle(fontSize: 16)),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () => context.read<TasbihCounterCubit>().increment(state.tasbihIndex),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF3C6950), width: 15),
                    ),
                    child: Center(
                      child: Text(
                        '${state.count}/${tasbih[state.tasbihIndex].count}',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(Icons.add, () => context.read<TasbihCounterCubit>().increment(state.tasbihIndex)),
                    _buildIconButton(Icons.refresh, () => context.read<TasbihCounterCubit>().reset()),
                    // _buildIconButton(
                    //   _soundOn ? Icons.volume_up : Icons.volume_off,
                    //   _toggleSound,
                    // ),
                  ],
                ),
              ],
            );
          },
        )
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Color(0xFF3C6950),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}