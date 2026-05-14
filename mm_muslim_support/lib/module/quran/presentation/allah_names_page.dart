import 'package:flutter/material.dart';
import 'package:mm_muslim_support/model/allah_name.dart';

class AllahNamesPage extends StatefulWidget {
  const AllahNamesPage({super.key});
  static const String routeName = '/allah_names';

  @override
  State<AllahNamesPage> createState() => _AllahNamesPageState();
}

class _AllahNamesPageState extends State<AllahNamesPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final names = _query.isEmpty ? allahNames : allahNames.where((n) =>
        n.transliteration.toLowerCase().contains(_query.toLowerCase()) ||
        n.meaning.toLowerCase().contains(_query.toLowerCase()) ||
        n.arabic.contains(_query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('99 Names of Allah'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by name or meaning...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty ? null : IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${names.length} names', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const Spacer(),
                if (_query.isNotEmpty)
                  TextButton(
                    onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: names.length,
              itemBuilder: (context, index) {
                final name = names.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _showDetail(context, name),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text('${name.number}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name.transliteration, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                  Text(name.meaning, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            Text(name.arabic, style: TextStyle(fontSize: 18, color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, AllahName name) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle),
              child: Center(
                child: Text('${name.number}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer)),
              ),
            ),
            const SizedBox(height: 20),
            Text(name.arabic, style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            const SizedBox(height: 8),
            Text(name.transliteration, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(name.meaning, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
