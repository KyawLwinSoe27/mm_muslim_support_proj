import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/tasbih_list_model.dart';
import 'package:mm_muslim_support/module/tasbih/presentations/tasbih_page.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class TasbihListPage extends StatelessWidget {
  const TasbihListPage({
    super.key,
    required this.tasbihListModel,
  });

  final List<TasbihListModel> tasbihListModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tasbihListModel.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final model = tasbihListModel[index];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.navigateWithPushNamed(
              TasbihPage.routeName,
              extra: model.tasbihDetailDataList,
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary.withValues(alpha: 0.9),
                  context.colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            child: Row(
              children: [
                /// Leading Icon
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 16),

                /// Text Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (!model.rewards.isNullOrEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          model.rewards,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                /// Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}