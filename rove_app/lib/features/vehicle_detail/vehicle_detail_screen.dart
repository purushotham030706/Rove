import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_badge.dart';
import '../../domain/models/vehicle.dart';
import '../../services/rove_repository.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;
  final RoveRepository repo;
  final int encounterCount;
  final String latestCity;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
    required this.repo,
    this.encounterCount = 1,
    this.latestCity = 'Mysuru',
  });

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  bool _specsExpanded = true;
  bool _loreExpanded = true;

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    final s = v.specifications;
    final l = v.lore;
    final photo = v.photoUrl ?? 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          v.canonicalName.toUpperCase(),
          style: RetroTheme.pixelDisplay(fontSize: 14, color: RetroPalette.cream),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle Identity Title
              Text(
                v.canonicalName.toUpperCase(),
                style: RetroTheme.pixelDisplay(
                  fontSize: 20,
                  color: RetroPalette.cream,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  PixelBadge.fromTier(v.tier, fontSize: 10),
                  const SizedBox(width: 8),
                  Text(
                    '${v.generationCode} • ${v.displayYearRange} • ${v.country.toUpperCase()}',
                    style: RetroTheme.readableCaption(
                      fontSize: 11,
                      color: RetroPalette.textMuted,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // REAL CAPTURED PHOTO with Pixel Art Frame
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: v.tier.color, width: 3.0),
                  boxShadow: const [
                    BoxShadow(
                      color: RetroPalette.pixelBorder,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    )
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            '[REAL FIELD PHOTOGRAPH]',
                            style: RetroTheme.pixelDisplay(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.black.withOpacity(0.85),
                        child: Text(
                          '${widget.latestCity.toUpperCase()} • ×${widget.encounterCount}',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 9,
                            color: RetroPalette.amber,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Headline Specs (Quick Glance)
              if (s != null)
                PixelCard(
                  title: 'HEADLINE PERFORMANCE METRICS',
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecPill('${s.horsepower} HP', 'OUTPUT'),
                      _buildSpecPill(s.zeroToHundredSec != null ? '${s.zeroToHundredSec}s' : 'N/A', '0–100 KM/H'),
                      _buildSpecPill(s.topSpeedKmh != null ? '${s.topSpeedKmh} KM/H' : 'N/A', 'V-MAX'),
                      _buildSpecPill(s.drivetrain, 'DRIVETRAIN'),
                    ],
                  ),
                ),

              const SizedBox(height: 14),

              // Expandable Full Technical Data (For Enthusiasts)
              PixelCard(
                title: 'TECHNICAL BLUEPRINT',
                trailing: GestureDetector(
                  onTap: () => setState(() => _specsExpanded = !_specsExpanded),
                  child: Text(
                    _specsExpanded ? '[-] COLLAPSE' : '[+] EXPAND',
                    style: RetroTheme.pixelDisplay(fontSize: 9, color: RetroPalette.amber),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: _specsExpanded && s != null
                    ? Column(
                        children: [
                          _buildDataRow('Engine', s.engine),
                          _buildDataRow('Displacement', s.displacement ?? 'N/A'),
                          _buildDataRow('Cylinders', s.cylinders ?? 'N/A'),
                          _buildDataRow('Aspiration', s.aspiration ?? 'N/A'),
                          _buildDataRow('Horsepower', '${s.horsepower} HP'),
                          _buildDataRow('Torque', s.torqueNm != null ? '${s.torqueNm} Nm' : 'N/A'),
                          _buildDataRow('Transmission', s.transmission),
                          _buildDataRow('Drivetrain', s.drivetrain),
                          _buildDataRow('Curb Weight', s.curbWeightKg != null ? '${s.curbWeightKg} kg' : 'N/A'),
                          _buildDataRow('Top Speed', s.topSpeedKmh != null ? '${s.topSpeedKmh} km/h' : 'N/A'),
                          _buildDataRow('0–100 km/h', s.zeroToHundredSec != null ? '${s.zeroToHundredSec} s' : 'N/A'),
                          _buildDataRow('Production Years', s.productionYears ?? v.displayYearRange),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 14),

              // Car Lore Section
              PixelCard(
                title: 'AUTOMOTIVE LORE & HERITAGE',
                trailing: GestureDetector(
                  onTap: () => setState(() => _loreExpanded = !_loreExpanded),
                  child: Text(
                    _loreExpanded ? '[-] COLLAPSE' : '[+] EXPAND',
                    style: RetroTheme.pixelDisplay(fontSize: 9, color: RetroPalette.amber),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: _loreExpanded && l != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Documented & Community Nicknames
                          if (l.documentedNicknames.isNotEmpty || l.communityNicknames.isNotEmpty) ...[
                            Text(
                              'KNOWN MONIKERS & NICKNAMES',
                              style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.amber),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                ...l.documentedNicknames.map((n) => _buildNicknameTag(n, isDocumented: true)),
                                ...l.communityNicknames.map((n) => _buildNicknameTag(n, isDocumented: false)),
                              ],
                            ),
                            const Divider(color: RetroPalette.surfaceLight, height: 20),
                          ],

                          // Historical Significance
                          Text(
                            'HISTORICAL SIGNIFICANCE',
                            style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.amber),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l.history,
                            style: RetroTheme.readableBody(fontSize: 13, color: RetroPalette.cream),
                          ),

                          // Motorsport Heritage
                          if (l.motorsport != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              'MOTORSPORT HERITAGE',
                              style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.racingRed),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.motorsport!,
                              style: RetroTheme.readableBody(fontSize: 13, color: RetroPalette.cream),
                            ),
                          ],

                          // Interesting Facts
                          if (l.interestingFacts.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Text(
                              'KEY ENGINEERING FACTS',
                              style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.steelBlue),
                            ),
                            const SizedBox(height: 4),
                            ...l.interestingFacts.map(
                              (fact) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('■ ', style: RetroTheme.pixelDisplay(fontSize: 8, color: RetroPalette.steelBlue)),
                                    Expanded(child: Text(fact, style: RetroTheme.readableBody(fontSize: 12.5))),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // Trivia
                          if (l.trivia.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Text(
                              'CULTURAL TRIVIA',
                              style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.amber),
                            ),
                            const SizedBox(height: 4),
                            ...l.trivia.map(
                              (t) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('◆ ', style: RetroTheme.pixelDisplay(fontSize: 8, color: RetroPalette.amber)),
                                    Expanded(child: Text(t, style: RetroTheme.readableBody(fontSize: 12.5))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecPill(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: RetroTheme.pixelDisplay(
            fontSize: 13,
            color: RetroPalette.amber,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: RetroTheme.pixelDisplay(fontSize: 8, color: RetroPalette.textMuted),
        ),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: RetroTheme.readableCaption(fontSize: 12, color: RetroPalette.textMuted)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: RetroTheme.readableBody(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameTag(String name, {required bool isDocumented}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDocumented ? RetroPalette.surfaceLight : const Color(0xFF1B232E),
        border: Border.all(
          color: isDocumented ? RetroPalette.amber : RetroPalette.steelBlue,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '"$name"',
            style: RetroTheme.pixelDisplay(
              fontSize: 10,
              color: isDocumented ? RetroPalette.cream : RetroPalette.cream,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isDocumented ? '[HISTORIC]' : '[COMMUNITY]',
            style: RetroTheme.pixelDisplay(
              fontSize: 7,
              color: isDocumented ? RetroPalette.amber : RetroPalette.steelBlue,
            ),
          ),
        ],
      ),
    );
  }
}
