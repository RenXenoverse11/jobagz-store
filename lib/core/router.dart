import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/add_product_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (ctx, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/add',
      builder: (ctx, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/product/edit/:id',
      builder: (ctx, state) => AddProductScreen(
        productId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
