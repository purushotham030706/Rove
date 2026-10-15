import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_button.dart';
import '../../domain/models/vehicle.dart';

class LowConfidenceDialog extends StatelessWidget {
  final Vehicle candidateVehicle;
  final double confidence;
  final List<dynamic> alternatives;
  final ValueChanged<Vehicle> onSelectCandidate;

  const LowConfidenceDialog({
    super.key,
    required this.candidateVehicle,
    required this.confidence,
    required this.alternatives,
    required this.onSelectCandidate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: PixelCard(
        title: 'AI MATCH RESOLUTION',
        padding: const EdgeInsets.all(16),
        borderColor: RetroPalette.signalOrange,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.help_outline,
                  color: RetroPalette.signalOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'WE THINK THIS IS...',
                    style: RetroTheme.pixelDisplay(
                      fontSize: 13,
                      color: RetroPalette.signalOrange,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: RetroPalette.surfaceLight,
                  child: Text(
                    '${(confidence * 100).toInt()}% CONF',
                    style: RetroTheme.pixelDisplay(
                      fontSize: 9,
                      color: RetroPalette.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Vision neural analysis indicates multiple close variant matches. Please confirm the exact vehicle observed in the field:',
              style: RetroTheme.readableBody(
                fontSize: 12,
                color: RetroPalette.cream,
              ),
            ),
            const SizedBox(height: 14),

            // Primary Candidate (Suggested)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onSelectCandidate(candidateVehicle);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: RetroPalette.canvasDark,
                  border: Border.all(color: RetroPalette.amber, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: RetroPalette.amber, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidateVehicle.canonicalName.toUpperCase(),
                            style: RetroTheme.pixelDisplay(
                              fontSize: 12,
                              color: RetroPalette.cream,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${candidateVehicle.displayYearRange} • ${candidateVehicle.category}',
                            style: RetroTheme.readableCaption(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'BEST MATCH',
                      style: RetroTheme.pixelDisplay(
                        fontSize: 8,
                        color: RetroPalette.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Alternative Candidates
            ...alternatives.map((alt) {
              final String altName = "${alt['make']} ${alt['model']} ${alt['generation'] ?? ''} ${alt['variant'] ?? ''}".trim();
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelectCandidate(candidateVehicle);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: RetroPalette.surface,
                      border: Border.all(color: RetroPalette.surfaceLight, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.radio_button_unchecked, color: RetroPalette.asphaltGrey, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            altName.toUpperCase(),
                            style: RetroTheme.pixelDisplay(
                              fontSize: 11,
                              color: RetroPalette.textMuted,
                            ),
                          ),
                        ),
                        Text(
                          'ALTERNATIVE',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 8,
                            color: RetroPalette.asphaltGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            PixelButton(
              text: 'CONFIRM PRIMARY MATCH',
              height: 44,
              backgroundColor: RetroPalette.amber,
              onPressed: () {
                Navigator.of(context).pop();
                onSelectCandidate(candidateVehicle);
              },
            ),
          ],
        ),
      ),
    );
  }
}
