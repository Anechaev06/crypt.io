import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../app/constants/colors.dart';
import '../../data/repositories/coin_service.dart';

class CoinChart extends StatefulWidget {
  final CoinService service;
  final int index;

  const CoinChart({super.key, required this.service, required this.index});

  @override
  State<CoinChart> createState() => _CoinChartState();
}

class _CoinChartState extends State<CoinChart> {
  String _selectedInterval = '24h';

  void _onPeriodChange(String interval) =>
      setState(() => _selectedInterval = interval);

  Widget _buildButton(String interval, String label) {
    final bool isSelected = _selectedInterval == interval;
    final ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    return isSelected
        ? ElevatedButton(
            onPressed: () => _onPeriodChange(interval),
            style: style,
            child: Text(label))
        : OutlinedButton(
            onPressed: () => _onPeriodChange(interval),
            style: style,
            child: Text(label));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.service.fetchCoinChartData(
          widget.service.coinsList[widget.index].id, _selectedInterval),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              SizedBox(
                width: 375,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.transparent,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((barSpot) {
                              return LineTooltipItem(
                                barSpot.y.toStringAsFixed(2),
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: true, reservedSize: 25),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: snapshot.data!['prices']
                              ?.asMap()
                              .entries
                              .map((entry) =>
                                  FlSpot(entry.key.toDouble(), entry.value))
                              .toList(),
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          color: newPrimaryColor,
                        ),
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildButton('24h', '1D'),
                    _buildButton('7d', '7D'),
                    _buildButton('30d', '1M'),
                    _buildButton('1y', '1Y'),
                  ],
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
