import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/trip_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final prefsAsync = ref.watch(preferencesServiceProvider);
    final tripsAsync = ref.watch(tripsStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                ),
                child: prefsAsync.when(
                  data: (prefs) => SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white24,
                          child: Text(
                            prefs.userName.isNotEmpty
                                ? prefs.userName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          prefs.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${prefs.userId.length > 12 ? prefs.userId.substring(0, 12) : prefs.userId}…',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                  error: (_, __) => const SizedBox(),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.pagePadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Trip Statistics ───────────────────────────────────────
                tripsAsync.when(
                  data: (trips) {
                    final shared = trips.where((t) => t.isShared).length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(title: 'Statistics'),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.map,
                                label: 'Total Trips',
                                value: '${trips.length}',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.cloud_done,
                                label: 'Shared',
                                value: '$shared',
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.event_note,
                                label: 'Local',
                                value: '${trips.length - shared}',
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

                // ── Appearance ───────────────────────────────────────────
                _SectionHeader(title: 'Appearance'),
                Card(
                  child: SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Switch between light and dark theme'),
                    secondary: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    value: isDark,
                    onChanged: (v) async {
                      final prefs =
                          await ref.read(preferencesServiceProvider.future);
                      await prefs.setDarkMode(v);
                      ref.read(themeProvider.notifier).setDark(v);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Profile ──────────────────────────────────────────────
                _SectionHeader(title: 'Profile'),
                prefsAsync.when(
                  data: (prefs) => Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Your Name'),
                          subtitle: Text(prefs.userName),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showEditNameDialog(
                              context, ref, prefs.userName),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.fingerprint),
                          title: const Text('User ID'),
                          subtitle: Text(
                            prefs.userId,
                            style: const TextStyle(
                                fontSize: 11, fontFamily: 'monospace'),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('User ID copied'),
                                    duration: Duration(seconds: 1)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () =>
                      const Card(child: ListTile(title: Text('Loading...'))),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 16),

                // ── About ────────────────────────────────────────────────
                _SectionHeader(title: 'About'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.travel_explore),
                        title: const Text('Travel Planner'),
                        trailing: const Text('v1.0.0',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.architecture),
                        title: const Text('Architecture'),
                        trailing: const Text('Clean + Riverpod',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.storage),
                        title: const Text('Local Storage'),
                        trailing: const Text('Drift (SQLite)',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.cloud),
                        title: const Text('Cloud Storage'),
                        trailing: const Text('Firebase Firestore',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditNameDialog(
      BuildContext context, WidgetRef ref, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Your Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Save')),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      final prefs = await ref.read(preferencesServiceProvider.future);
      await prefs.setUserName(controller.text.trim());
      ref.invalidate(preferencesServiceProvider);
    }
  }
}

// ── Stat Card ──────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
