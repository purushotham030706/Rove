import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_badge.dart';
import '../../services/rove_repository.dart';
import '../../services/audio_service.dart';
import '../vehicle_detail/vehicle_detail_screen.dart';

class CollectionScreen extends StatefulWidget {
  final RoveRepository repo;

  const CollectionScreen({super.key, required this.repo});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  String _selectedTierFilter = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'ALL',
    'COMMON',
    'UNCOMMON',
    'RARE',
    'EPIC',
    'LEGENDARY'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allItems = widget.repo.collection;

    // Filter by tier and search
    final filtered = allItems.where((item) {
      final v = item.vehicle;
      if (_selectedTierFilter != 'ALL' && v.tier.displayName != _selectedTierFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matches = v.canonicalName.toLowerCase().contains(query) ||
            v.make.toLowerCase().contains(query) ||
            v.generationCode.toLowerCase().contains(query) ||
            item.latestCity.toLowerCase().contains(query);
        if (!matches) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MY COLLECTION',
          style: RetroTheme.pixelDisplay(
            fontSize: 16,
            color: RetroPalette.cream,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${allItems.length} ARCHIVED',
                style: RetroTheme.pixelDisplay(
                  fontSize: 10,
                  color: RetroPalette.amber,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Retro Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: RetroPalette.surface,
                  border: Border.all(color: RetroPalette.surfaceLight, width: 2),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.search, color: RetroPalette.asphaltGrey, size: 18),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: RetroTheme.pixelDisplay(fontSize: 12, color: RetroPalette.cream),
                        decoration: InputDecoration(
                          hintText: 'SEARCH BY CAR, MAKE, OR CITY...',
                          hintStyle: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.asphaltGrey),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, color: RetroPalette.asphaltGrey, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                  ],
                ),
              ),
            ),

            // Rarity Filter Pills
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  final isSelected = _selectedTierFilter == f;
                  Color pillColor = RetroPalette.amber;
                  if (f != 'ALL') {
                    pillColor = RarityTier.fromString(f).color;
                  }

                  return GestureDetector(
                    onTap: () {
                      RetroAudioService.playButtonBeep();
                      setState(() => _selectedTierFilter = f);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? pillColor.withOpacity(0.25) : RetroPalette.surface,
                        border: Border.all(
                          color: isSelected ? pillColor : RetroPalette.surfaceLight,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          f,
                          style: RetroTheme.pixelDisplay(
                            fontSize: 10,
                            color: isSelected ? pillColor : RetroPalette.textMuted,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Collection Grid
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '[ NO VEHICLES MATCH FILTER ]',
                            style: RetroTheme.pixelDisplay(
                              fontSize: 12,
                              color: RetroPalette.asphaltGrey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try selecting a different tier or clearing search query.',
                            style: RetroTheme.readableCaption(),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _buildCollectionCard(context, item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, dynamic item) {
    final v = item.vehicle;
    return GestureDetector(
      onTap: () {
        RetroAudioService.playButtonBeep();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(
              vehicle: v,
              repo: widget.repo,
              encounterCount: item.encounterCount,
              latestCity: item.latestCity,
            ),
          ),
        );
      },
      child: PixelCard(
        padding: const EdgeInsets.all(6),
        borderColor: v.tier.color.withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // REAL CAPTURE PHOTO inside sharp pixel frame
            SizedBox(
              height: 104,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: RetroPalette.pixelBorder, width: 2),
                      color: Colors.black,
                    ),
                    child: Image.network(
                      item.primaryPhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            '[PHOTO]',
                            style: RetroTheme.pixelDisplay(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Encounter count badge
                  if (item.encounterCount > 1)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.black.withOpacity(0.8),
                        child: Text(
                          '×${item.encounterCount}',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 9,
                            color: RetroPalette.amber,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Vehicle Details
            Text(
              v.canonicalName.toUpperCase(),
              style: RetroTheme.pixelDisplay(
                fontSize: 11,
                color: RetroPalette.cream,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                PixelBadge.fromTier(v.tier, fontSize: 8),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'DISCOVERED IN ${item.latestCity.toUpperCase()}',
              style: RetroTheme.readableCaption(
                fontSize: 8.5,
                color: RetroPalette.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
