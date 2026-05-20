import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/trips/trip_detail_screen.dart';
import '../screens/trips/add_edit_trip_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/collaborative/collaborative_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/app_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/collaborative',
            name: 'collaborative',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CollaborativeScreen()),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
      // Sub-routes (outside shell — full screen)
      GoRoute(
        path: '/trips/add',
        name: 'add-trip',
        builder: (context, state) => AddEditTripScreen(
          initialDestination: state.uri.queryParameters['destination'],
        ),
      ),
      GoRoute(
        path: '/trips/:id',
        name: 'trip-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TripDetailScreen(tripId: id);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'edit-trip',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return AddEditTripScreen(tripId: id);
            },
          ),
        ],
      ),
    ],
  );
});
