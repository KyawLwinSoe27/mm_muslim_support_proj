import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/tasbih_list_model.dart';
import 'package:mm_muslim_support/module/tasbih/presentations/tasbih_page.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class TasbihListPage extends StatelessWidget {
  const TasbihListPage({super.key, required this.tasbihListModel});

  final List<TasbihListModel> tasbihListModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children:
          tasbihListModel.map((model) {
            return Card(
              child: ListTile(
                title: Text(model.title),
                subtitle:
                    model.rewards.isNullOrEmpty ? null : Text(model.rewards),
                onTap: () {
                  context.navigateWithPushNamed(
                    TasbihPage.routeName,
                    extra: model.tasbihDetailDataList,
                  );
                },
              ),
            );
          }).toList(),
    );
  }
}
