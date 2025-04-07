import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/food_log_cubit.dart';

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Progress'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: BlocBuilder<FoodLogCubit, FoodLogState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Container(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 2500,
                      barGroups: state.weeklyData.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Colors.orange,
                              width: 20,
                              fromY: 0,
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => 
                              Text('${value.toInt()}'),
                            interval: 500,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0: return Text('Mon');
                                case 1: return Text('Tue');
                                case 2: return Text('Wed');
                                case 3: return Text('Thu');
                                case 4: return Text('Fri');
                                case 5: return Text('Sat');
                                case 6: return Text('Sun');
                                default: return Text('');
                              }
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 500,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                _buildWeeklyStats(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeeklyStats(FoodLogState state) {
    final avgCalories = state.weeklyData.isEmpty 
      ? 0.0 
      : state.weeklyData.reduce((a, b) => a + b) / state.weeklyData.length;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  'Average',
                  '${avgCalories.toInt()} kcal',
                  Icons.analytics,
                ),
                _buildStatItem(
                  'Highest',
                  '${state.weeklyData.isEmpty ? 0 : state.weeklyData.reduce((a, b) => a > b ? a : b).toInt()} kcal',
                  Icons.arrow_upward,
                ),
                _buildStatItem(
                  'Lowest',
                  '${state.weeklyData.isEmpty ? 0 : state.weeklyData.reduce((a, b) => a < b ? a : b).toInt()} kcal',
                  Icons.arrow_downward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}