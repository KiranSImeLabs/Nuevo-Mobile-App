import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/health_provider.dart';
import '../../../../domain/models/health/patient_habit_history.dart';
import '../../../../domain/models/health/health_enums.dart';
import '../../../../domain/models/health/metric_stats.dart';
import '../../../../domain/services/health_analytics_service.dart';

import 'historical_trends_components/historical_trends_chart.dart';
import 'historical_trends_components/historical_trends_insight.dart';
import 'historical_trends_components/historical_trends_summary.dart';
import 'historical_trends_components/historical_trends_overview.dart';
import '../../../../core/theme/app_theme.dart';

class AnalyticsFilter {
  final MetricType type;
  final TimeRange range;
  AnalyticsFilter(this.type, this.range);
  @override bool operator ==(Object other) => other is AnalyticsFilter && type == other.type && range == other.range;
  @override int get hashCode => type.hashCode ^ range.hashCode;
}

List<PatientHabitHistory> _filterDataStateless(List<PatientHabitHistory> allData, TimeRange range) {
    final now = DateTime.now();
    DateTime cutoff = range == TimeRange.weekly 
        ? now.subtract(const Duration(days: 7)) 
        : now.subtract(const Duration(days: 30));
        
    final filtered = allData.where((d) {
      try { 
          final dt = DateTime.parse(d.date);
          return dt.isAfter(cutoff) || dt.isAtSameMomentAs(cutoff); 
      } catch (e) { return false; }
    }).toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
}

final computedAnalyticsProvider = Provider.autoDispose.family<MetricStats?, AnalyticsFilter>((ref, filter) {
  final historyAsync = ref.watch(patientHabitHistoryListProvider);
  return historyAsync.maybeWhen(
    data: (data) {
       final service = ref.read(healthAnalyticsServiceProvider);
       final filtered = _filterDataStateless(data, filter.range);
       return service.analyze(rawData: filtered, selectedMetric: filter.type, selectedRange: filter.range);
    },
    orElse: () => null,
  );
});

class HistoricalTrendsScreen extends ConsumerStatefulWidget {
  const HistoricalTrendsScreen({super.key});
  @override ConsumerState<HistoricalTrendsScreen> createState() => _HistoricalTrendsScreenState();
}

class _HistoricalTrendsScreenState extends ConsumerState<HistoricalTrendsScreen> with SingleTickerProviderStateMixin {
  TimeRange _selectedRange = TimeRange.weekly;
  MetricType _selectedMetric = MetricType.sleep;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  
  BoxDecoration get _bgDecoration => const BoxDecoration(
    color: AppColors.backgroundColor,
  );

  Color get _textColor => AppColors.textPrimary;
  Color get _subTextColor => AppColors.textSecondary;
  Color get _trackerBgColor => AppColors.surfaceContainerLow;

  Widget _buildPremiumSegmentedControl() {
    return Container(
      height: 44,
      decoration: BoxDecoration(color: _trackerBgColor, borderRadius: BorderRadius.circular(22)),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth) / 2;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _selectedRange == TimeRange.weekly ? 0 : tabWidth,
                top: 0, bottom: 0, width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(color: Color(0x15000000), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                   _buildSegmentButton("Weekly", TimeRange.weekly),
                   _buildSegmentButton("Monthly", TimeRange.monthly),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSegmentButton(String title, TimeRange range) {
    final isSelected = _selectedRange == range;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedRange = range); },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.label.copyWith(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600, color: isSelected ? _textColor : _subTextColor),
            child: Text(title),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: MetricType.values.map((type) {
          final isSelected = _selectedMetric == type;
          final color = type.color;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () { HapticFeedback.lightImpact(); setState(() => _selectedMetric = type); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : (isDark ? const Color(0xFF38383A) : const Color(0xFFE5DCD8)), width: 1.5,
                  ),
                  boxShadow: isSelected ? [ BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)) ] : [],
                ),
                child: Row(
                  children: [
                    Icon(type.icon, size: 16, color: isSelected ? Colors.white : color),
                    const SizedBox(width: 8),
                    Text(type.name, style: AppTextStyles.label.copyWith(color: isSelected ? Colors.white : _textColor, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsSync = ref.watch(computedAnalyticsProvider(AnalyticsFilter(_selectedMetric, _selectedRange)));
    final historyAsync = ref.watch(patientHabitHistoryListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: _bgDecoration,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // Sticky Top Nav
            SliverAppBar(
              backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.8),
              elevation: 0, pinned: true, centerTitle: true,
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(color: Colors.transparent),
                ),
              ),
              title: Text("Historical Trends", style: AppTextStyles.h3),
              leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textColor, size: 20), onPressed: () { HapticFeedback.lightImpact(); Navigator.of(context).pop(); }),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(130),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
                    boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      _buildPremiumSegmentedControl(),
                      const SizedBox(height: 20),
                      _buildMetricSelector(),
                    ],
                  ),
                ),
              ),
            ),
          
          // Data Content Layout
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutQuart,
                switchOutCurve: Curves.easeInQuart,
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(animation), child: child)),
                child: (statsSync != null && historyAsync.hasValue) ? (() {
                  final rawData = _filterDataStateless(historyAsync.value!, _selectedRange);
                  return Column(
                    key: ValueKey("${_selectedMetric.name}_${_selectedRange.name}"),
                    children: [
                      if (statsSync.anomalyMessage.isNotEmpty)
                          Container(
                             margin: const EdgeInsets.only(bottom: 24), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                             decoration: BoxDecoration(color: const Color(0xFFFF8A00).withValues(alpha: 0.1), border: Border.all(color: const Color(0xFFFF8A00).withValues(alpha: 0.3)), borderRadius: BorderRadius.circular(12)),
                             child: Row(children: [ const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF8A00), size: 20), const SizedBox(width: 12), Expanded(child: Text(statsSync.anomalyMessage, style: const TextStyle(color: Color(0xFFFF8A00), fontWeight: FontWeight.w700, fontSize: 13))) ])
                          ),
                      HistoricalTrendsOverview(stats: statsSync, selectedMetric: _selectedMetric),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Icon(Icons.query_stats_rounded, color: _subTextColor, size: 20),
                          const SizedBox(width: 8),
                          Text("Trend Analysis", style: AppTextStyles.h3),
                        ]
                      ),
                      const SizedBox(height: 16),
                      SizedBox(height: 290, child: HistoricalTrendsChart(data: rawData, stats: statsSync, selectedMetric: _selectedMetric)),
                      const SizedBox(height: 32),
                      HistoricalTrendsInsight(stats: statsSync),
                      const SizedBox(height: 32),
                      HistoricalTrendsSummary(stats: statsSync, rawData: rawData, selectedMetric: _selectedMetric),
                    ],
                  );
                })() : SizedBox(key: const ValueKey("loading_state"), height: 350, child: Center(child: CupertinoActivityIndicator(radius: 14, color: _textColor))),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
