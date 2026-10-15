import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_camera_frame.dart';
import '../../core/widgets/pixel_button.dart';
import '../../domain/models/vehicle.dart';
import '../../services/rove_repository.dart';
import '../../services/audio_service.dart';
import 'low_confidence_dialog.dart';
import '../discovery_reveal/discovery_reveal_screen.dart';

class CaptureScreen extends StatefulWidget {
  final RoveRepository repo;

  const CaptureScreen({super.key, required this.repo});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  bool _isAnalyzing = false;
  bool _simulateLowConfidence = false;
  String _selectedCity = 'Mysuru';
  Vehicle? _selectedDemoVehicle;

  final List<String> _demoCities = ['Mysuru', 'Bengaluru', 'Chennai', 'Mumbai', 'Delhi'];

  @override
  void initState() {
    super.initState();
    if (widget.repo.catalogue.isNotEmpty) {
      _selectedDemoVehicle = widget.repo.catalogue[0];
    }
  }

  Future<void> _handleCapture({Vehicle? overrideVehicle}) async {
    RetroAudioService.playShutterClick();
    setState(() => _isAnalyzing = true);

    final targetVehicle = overrideVehicle ?? _selectedDemoVehicle ?? widget.repo.catalogue[0];

    // Run AI identification (supports mock demo or backend API)
    final result = await widget.repo.identifyVehicle(
      imageHint: targetVehicle.canonicalName,
      forceLowConfidence: _simulateLowConfidence,
    );

    setState(() => _isAnalyzing = false);

    if (!mounted) return;

    final vehicle = result['vehicle'] as Vehicle;
    final isLowConfidence = result['is_low_confidence'] as bool;
    final confidence = result['confidence'] as double;
    final alternatives = result['alternatives'] as List<dynamic>;

    if (isLowConfidence) {
      // Show Low Confidence Confirmation Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LowConfidenceDialog(
          candidateVehicle: vehicle,
          confidence: confidence,
          alternatives: alternatives,
          onSelectCandidate: (confirmedVehicle) {
            _proceedToReveal(confirmedVehicle, confidence);
          },
        ),
      );
    } else {
      _proceedToReveal(vehicle, confidence);
    }
  }

  void _proceedToReveal(Vehicle vehicle, double confidence) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DiscoveryRevealScreen(
          vehicle: vehicle,
          repo: widget.repo,
          city: _selectedCity,
          confidence: confidence,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoCount = widget.repo.profile.totalEncounters + 1;
    final currentPreviewUrl = _selectedDemoVehicle?.photoUrl ??
        'https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=1200&q=80';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'ROVE OPTICAL SCAN',
          style: RetroTheme.pixelDisplay(fontSize: 14, color: RetroPalette.cream),
        ),
        actions: [
          // Low Confidence Toggle for quick demo testing
          Row(
            children: [
              Text(
                'LOW CONF',
                style: RetroTheme.pixelDisplay(
                  fontSize: 8,
                  color: _simulateLowConfidence ? RetroPalette.signalOrange : RetroPalette.asphaltGrey,
                ),
              ),
              Switch(
                value: _simulateLowConfidence,
                activeColor: RetroPalette.signalOrange,
                onChanged: (val) {
                  setState(() => _simulateLowConfidence = val);
                },
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Retro Viewfinder Frame
            Expanded(
              flex: 5,
              child: PixelCameraFrame(
                photoCount: photoCount,
                instruction: _isAnalyzing ? 'ANALYZING NEURAL SIGNATURE...' : 'FRAME THE CAR IN SIGHT',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Simulated real-world automotive camera viewport with real photo
                    Image.network(
                      currentPreviewUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF181C20),
                        child: Center(
                          child: Text(
                            '[ REAL CAR CAMERA FEED ]',
                            style: RetroTheme.pixelDisplay(fontSize: 12),
                          ),
                        ),
                      ),
                    ),

                    // CRT Scanline / Viewfinder mesh
                    Container(
                      color: Colors.black.withOpacity(0.18),
                    ),

                    // Analysis Scanning Indicator
                    if (_isAnalyzing)
                      Container(
                        color: Colors.black.withOpacity(0.65),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: RetroPalette.amber, width: 2),
                                ),
                                child: const CircularProgressIndicator(
                                  color: RetroPalette.amber,
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'IDENTIFYING VEHICLE SPECS...',
                                style: RetroTheme.pixelDisplay(
                                  fontSize: 11,
                                  color: RetroPalette.amber,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Controls & Demo Car Preset Selection Panel
            Expanded(
              flex: 4,
              child: Container(
                color: RetroPalette.canvasDark,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Location Pill Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LOCATION PIN:',
                          style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.textMuted),
                        ),
                        DropdownButton<String>(
                          value: _selectedCity,
                          dropdownColor: RetroPalette.surface,
                          style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.amber),
                          underline: Container(height: 1, color: RetroPalette.amber),
                          onChanged: (newCity) {
                            if (newCity != null) setState(() => _selectedCity = newCity);
                          },
                          items: _demoCities.map((c) {
                            return DropdownMenuItem(value: c, child: Text(c.toUpperCase()));
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Demo Car Preset Selector
                    Text(
                      'FIELD TARGET (DEMO TESTER):',
                      style: RetroTheme.pixelDisplay(fontSize: 9, color: RetroPalette.asphaltGrey),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.repo.catalogue.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final v = widget.repo.catalogue[index];
                          final isSelected = _selectedDemoVehicle?.id == v.id;
                          return GestureDetector(
                            onTap: () {
                              RetroAudioService.playButtonBeep();
                              setState(() => _selectedDemoVehicle = v);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? RetroPalette.amber : RetroPalette.surface,
                                border: Border.all(
                                  color: isSelected ? RetroPalette.pixelBorder : RetroPalette.surfaceLight,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  v.canonicalName.toUpperCase(),
                                  style: RetroTheme.pixelDisplay(
                                    fontSize: 9,
                                    color: isSelected ? RetroPalette.canvasDark : RetroPalette.cream,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Spacer(),

                    // Shutter Capture Button
                    PixelButton(
                      text: _isAnalyzing ? 'IDENTIFYING...' : 'CAPTURE PHOTO',
                      height: 52,
                      fontSize: 14,
                      backgroundColor: RetroPalette.amber,
                      textColor: RetroPalette.canvasDark,
                      icon: const Icon(Icons.camera_alt, color: RetroPalette.canvasDark, size: 20),
                      onPressed: _isAnalyzing ? null : () => _handleCapture(),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
