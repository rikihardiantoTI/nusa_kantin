import 'package:flutter/material.dart';

import 'data/repositories/menu_repository.dart';
import 'ui/core/window_size.dart';
import 'ui/menu/menu_screen.dart';
import 'ui/menu/menu_view_model.dart';
import 'ui/pesanan/pesanan_screen.dart';

void main() {
  runApp(const NusaKantinApp());
}

class NusaKantinApp extends StatefulWidget {
  const NusaKantinApp({super.key});

  @override
  State<NusaKantinApp> createState() => _NusaKantinAppState();
}

class _NusaKantinAppState extends State<NusaKantinApp> {
  late final MenuViewModel _viewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = MenuViewModel(MenuRepository());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaKantin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F7F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174D38),
          brightness: Brightness.light,
          surface: const Color(0xFFF8F7F2),
          primary: const Color(0xFF174D38),
          secondary: const Color(0xFFF2A65A),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: Color(0xFF17251F),
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: Color(0xFF17251F),
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF17251F),
          ),
          bodyMedium: TextStyle(color: Color(0xFF647069)),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE7EFEA),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF174D38));
            }
            return const IconThemeData(color: Color(0xFF7A807B));
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xFF174D38),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              );
            }
            return const TextStyle(color: Color(0xFF7A807B), fontSize: 12);
          }),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
        ),
      ),
      home: Builder(
        builder: (context) {
          final sizeClass = WindowSizeHelper.of(context);
          final useRail = sizeClass != WindowSizeClass.compact;

          final pages = [
            MenuScreen(
              viewModel: _viewModel,
              onCartTap: () => setState(() => _selectedIndex = 1),
            ),
            PesananScreen(viewModel: _viewModel),
          ];

          return ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final badgeCount = _viewModel.totalItemPesanan;

              return Scaffold(
                body: SafeArea(
                  child: useRail
                      ? Row(
                          children: [
                            NavigationRail(
                              selectedIndex: _selectedIndex,
                              onDestinationSelected: (index) {
                                setState(() => _selectedIndex = index);
                              },
                              backgroundColor: Colors.white,
                              indicatorColor: const Color(0xFFE1F2E8),
                              useIndicator: true,
                              labelType: NavigationRailLabelType.all,
                              destinations: [
                                const NavigationRailDestination(
                                  icon: Icon(Icons.restaurant_menu_outlined),
                                  selectedIcon: Icon(Icons.restaurant_menu),
                                  label: Text('Menu'),
                                ),
                                NavigationRailDestination(
                                  icon: Badge(
                                    isLabelVisible: badgeCount > 0,
                                    label: Text('$badgeCount'),
                                    child: const Icon(
                                      Icons.shopping_bag_outlined,
                                    ),
                                  ),
                                  selectedIcon: Badge(
                                    isLabelVisible: badgeCount > 0,
                                    label: Text('$badgeCount'),
                                    child: const Icon(Icons.shopping_bag),
                                  ),
                                  label: const Text('Pesanan'),
                                ),
                              ],
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(child: pages[_selectedIndex]),
                          ],
                        )
                      : pages[_selectedIndex],
                ),
                bottomNavigationBar: useRail
                    ? null
                    : NavigationBar(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (index) {
                          setState(() => _selectedIndex = index);
                        },
                        destinations: [
                          const NavigationDestination(
                            icon: Icon(Icons.restaurant_menu_outlined),
                            selectedIcon: Icon(Icons.restaurant_menu),
                            label: 'Menu',
                          ),
                          NavigationDestination(
                            icon: Badge(
                              isLabelVisible: badgeCount > 0,
                              label: Text('$badgeCount'),
                              child: const Icon(Icons.shopping_bag_outlined),
                            ),
                            selectedIcon: Badge(
                              isLabelVisible: badgeCount > 0,
                              label: Text('$badgeCount'),
                              child: const Icon(Icons.shopping_bag),
                            ),
                            label: 'Pesanan',
                          ),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
