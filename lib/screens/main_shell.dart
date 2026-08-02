import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Home',     icon: Icons.home_outlined,        activeIcon: Icons.home,         route: '/'),
    _NavItem(label: 'Learn',    icon: Icons.menu_book_outlined,   activeIcon: Icons.menu_book,    route: '/learn'),
    _NavItem(label: 'Projects', icon: Icons.rocket_launch_outlined,activeIcon: Icons.rocket_launch,route: '/projects'),
    _NavItem(label: 'Roadmap',  icon: Icons.map_outlined,         activeIcon: Icons.map,          route: '/roadmap'),
    _NavItem(label: 'Stats',    icon: Icons.bar_chart_outlined,   activeIcon: Icons.bar_chart,    route: '/stats'),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    context.go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: cs.outline, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onTap,
          backgroundColor: cs.surface,
          indicatorColor: cs.primary.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _navItems
              .map((item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.activeIcon, color: cs.primary),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
