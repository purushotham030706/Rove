import 'package:flutter/material.dart';
import 'core/branding/branding.dart';
import 'core/theme/retro_theme.dart';
import 'services/rove_repository.dart';
import 'services/audio_service.dart';
import 'features/home/home_screen.dart';
import 'features/collection/collection_screen.dart';
import 'features/capture/capture_screen.dart';
import 'features/map/map_screen.dart';
import 'features/profile/profile_screen.dart';

class RoveApp extends StatelessWidget {
  final RoveRepository repository;

  const RoveApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        return MaterialApp(
          title: RoveBranding.appName,
          debugShowCheckedModeBanner: false,
          theme: RetroTheme.darkTheme,
          home: MainNavigationScaffold(repo: repository),
        );
      },
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  final RoveRepository repo;

  const MainNavigationScaffold({super.key, required this.repo});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    RetroAudioService.playButtonBeep();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        repo: widget.repo,
        onNavigateToCapture: () => _navigateToTab(2), // Capture tab
        onNavigateToCollection: () => _navigateToTab(1), // Collection tab
      ),
      CollectionScreen(repo: widget.repo),
      CaptureScreen(repo: widget.repo),
      MapScreen(repo: widget.repo),
      ProfileScreen(repo: widget.repo),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: RetroPalette.pixelBorder, width: 2.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _navigateToTab,
          selectedItemColor: RetroPalette.amber,
          unselectedItemColor: RetroPalette.asphaltGrey,
          backgroundColor: RetroPalette.surface,
          selectedLabelStyle: RetroTheme.pixelDisplay(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
          unselectedLabelStyle: RetroTheme.pixelDisplay(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              activeIcon: Icon(Icons.home, size: 22),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined, size: 22),
              activeIcon: Icon(Icons.grid_view, size: 22),
              label: 'COLLECTION',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined, size: 24),
              activeIcon: Icon(Icons.camera_alt, size: 24),
              label: 'CAPTURE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 22),
              activeIcon: Icon(Icons.map, size: 22),
              label: 'MAP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 22),
              activeIcon: Icon(Icons.person, size: 22),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
