import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_button.dart';
import '../../services/rove_repository.dart';

class SettingsScreen extends StatefulWidget {
  final RoveRepository repo;

  const SettingsScreen({super.key, required this.repo});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _locationPermission = true;
  bool _blurExactLocation = true;
  bool _notifications = false;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.repo.backendUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ROVE SETTINGS',
          style: RetroTheme.pixelDisplay(fontSize: 16, color: RetroPalette.cream),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // System Engine & Demo Mode
              PixelCard(
                title: 'ENGINE & SIMULATION',
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'DEMO MODE (OFFLINE)',
                        style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.cream),
                      ),
                      subtitle: Text(
                        'Runs without external AI or map servers using local automotive seed archive.',
                        style: RetroTheme.readableCaption(),
                      ),
                      value: widget.repo.isDemoMode,
                      activeColor: RetroPalette.amber,
                      onChanged: (val) {
                        setState(() => widget.repo.toggleDemoMode(val));
                      },
                    ),
                    const Divider(color: RetroPalette.surfaceLight, height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BACKEND SYNC ENDPOINT',
                                style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.cream),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _urlController,
                                style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.amber),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: RetroPalette.amber),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        PixelButton(
                          text: 'SYNC',
                          height: 38,
                          fontSize: 10,
                          onPressed: () {
                            widget.repo.setBackendUrl(_urlController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Testing backend synchronization...')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Location & Privacy
              PixelCard(
                title: 'LOCATION & PRIVACY SAFEGUARDS',
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'ENABLE LOCATION TAGGING',
                        style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.cream),
                      ),
                      subtitle: Text(
                        'Attaches city/district coordinates to archived discoveries.',
                        style: RetroTheme.readableCaption(),
                      ),
                      value: _locationPermission,
                      activeColor: RetroPalette.amber,
                      onChanged: (val) => setState(() => _locationPermission = val),
                    ),
                    const Divider(color: RetroPalette.surfaceLight, height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'FUZZY LOCATION (PRIVACY MODE)',
                        style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.cream),
                      ),
                      subtitle: Text(
                        'Rounds GPS coordinates to approximate city sectors to protect user privacy.',
                        style: RetroTheme.readableCaption(),
                      ),
                      value: _blurExactLocation,
                      activeColor: RetroPalette.amber,
                      onChanged: (val) => setState(() => _blurExactLocation = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Notifications Placeholder
              PixelCard(
                title: 'FIELD NOTIFICATIONS',
                padding: const EdgeInsets.all(12),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'SPOTTING ALERTS',
                    style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.cream),
                  ),
                  subtitle: Text(
                    'Notify when rare or epic vehicles are active in your roved sector.',
                    style: RetroTheme.readableCaption(),
                  ),
                  value: _notifications,
                  activeColor: RetroPalette.amber,
                  onChanged: (val) => setState(() => _notifications = val),
                ),
              ),

              const SizedBox(height: 14),

              // Demo Reset & Seed Controls
              PixelCard(
                title: 'LOCAL ARCHIVE CONTROLS',
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: PixelButton(
                            text: 'RESET CLEAN SLATE',
                            height: 40,
                            fontSize: 9,
                            backgroundColor: RetroPalette.surface,
                            textColor: RetroPalette.racingRed,
                            borderColor: RetroPalette.racingRed,
                            onPressed: () {
                              widget.repo.resetDemo();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Archive reset to clean slate.')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: PixelButton(
                            text: 'SEED STARTER ARCHIVE',
                            height: 40,
                            fontSize: 9,
                            backgroundColor: RetroPalette.surface,
                            textColor: RetroPalette.retroGreen,
                            borderColor: RetroPalette.retroGreen,
                            onPressed: () {
                              widget.repo.seedStarter();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Loaded starter discovery archive.')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // About ROVE
              PixelCard(
                title: 'ABOUT ${RoveBranding.appName}',
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${RoveBranding.appName} ${RoveBranding.version}',
                      style: RetroTheme.pixelDisplay(fontSize: 12, color: RetroPalette.amber),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      RoveBranding.tagline,
                      style: RetroTheme.readableBody(fontSize: 12, color: RetroPalette.cream),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Built from zero with Flutter & Python. Real-world car photographs contrasted against a bespoke 8-bit retro automotive aesthetic.',
                      style: RetroTheme.readableCaption(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
