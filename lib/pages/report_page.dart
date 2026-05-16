import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final customerController = Get.find<CustomerController>();
    return Obx(() {
      if (orderController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final orderData = orderController.orderData;
      final dailyDataIncomePaid = Helper.generateDailyIncome(orderData);
      final barDataIncomePaid = generateBarDataGeneric(
        data: dailyDataIncomePaid,
        gradientColors: [Colors.green.shade700, Colors.green.shade300],
      );
      final labelIncomePaid = dailyDataIncomePaid.keys
          .map((date) => DateFormat('dd/MM').format(date))
          .toList();
      final dailyDataOrders = Helper.generateDailyOrderCount(orderData);
      final chartDataOrders = generateBarDataGeneric(
        data: dailyDataOrders,
        gradientColors: [Colors.blue.shade700, Colors.blue.shade300],
      );
      final labelOrders = dailyDataOrders.keys
          .map((date) => DateFormat('dd/MM').format(date))
          .toList();
      final totalOrder = orderData.length;
      final totalIncome = orderData.fold(
        0,
        (previousValue, element) => previousValue + element.totalPrice,
      );
      final totalPaid = orderData
          .where((element) => element.paymentStatus == "paid")
          .fold(
            0,
            (previousValue, element) => previousValue + element.totalPrice,
          );
      final totalUtang = orderData
          .where((element) => element.paymentStatus == "unpaid")
          .fold(
            0,
            (previousValue, element) => previousValue + element.totalPrice,
          );
      final totalCustomer = customerController.customerData.length;
      return ListView(
        padding: const EdgeInsets.all(15),
        children: [
          DashboardContainerWidget(
            title: "PEMASUKAN",
            value: Helper.formatRupiah(totalIncome),
            colorCircle: Colors.green.withValues(alpha: 0.15),
            icons: Icons.account_balance_wallet_outlined,
            colorIcon: Colors.green,
          ),
          const SizedBox(height: 10),
          DashboardContainerWidget(
            title: "TOTAL TERBAYAR",
            value: Helper.formatRupiah(totalPaid),
            colorCircle: Colors.green.withValues(alpha: 0.15),
            icons: Icons.done_all_outlined,
            colorIcon: Colors.green,
          ),
          const SizedBox(height: 10),
          DashboardContainerWidget(
            title: "TOTAL PIUTANG",
            value: Helper.formatRupiah(totalUtang),
            colorCircle: Colors.red.withValues(alpha: 0.15),
            icons: Icons.warning_amber,
            colorIcon: Colors.red,
          ),
          const SizedBox(height: 10),
          DashboardContainerWidget(
            title: "TOTAL ORDER",
            value: totalOrder.toString(),
            colorCircle: Colors.blue.withValues(alpha: 0.15),
            icons: Icons.shopping_bag_outlined,
            colorIcon: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          DashboardContainerWidget(
            title: "TOTAL PELANGGAN",
            value: totalCustomer.toString(),
            colorCircle: Colors.purple.withValues(alpha: 0.15),
            icons: Icons.person_2_outlined,
            colorIcon: Colors.purple,
          ),
          const SizedBox(height: 10),
          ModernReportChart(
            title: "Pendapatan Masuk",
            subtitle: "Total nota lunas per hari",
            themeColor: Colors.green,
            barGroups: barDataIncomePaid,
            labels: labelIncomePaid,
            maxY: dailyDataIncomePaid.values.isEmpty
                ? 100
                : dailyDataIncomePaid.values.reduce((a, b) => a > b ? a : b) *
                      1.2,
          ),
          const SizedBox(height: 15),
          ModernReportChart(
            title: "Produktivitas Laundry",
            subtitle: "Jumlah order yang masuk harian",
            themeColor: Colors.blue,
            barGroups: chartDataOrders,
            labels: labelOrders,
            maxY: dailyDataOrders.values.isEmpty
                ? 10
                : dailyDataOrders.values
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble() *
                      1.2,
          ),
        ],
      );
    });
  }
}

class ModernReportChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final List<String> labels;
  final double maxY;
  final String title;
  final String subtitle;
  final Color themeColor;

  const ModernReportChart({
    super.key,
    required this.barGroups,
    required this.labels,
    required this.maxY,
    required this.title,
    required this.subtitle,
    this.themeColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: themeColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey.shade900,
                    tooltipBorderRadius: BorderRadius.circular(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String valueText;
                      if (maxY < 1000) {
                        valueText = rod.toY.toInt().toString();
                      } else {
                        valueText = Helper.formatRupiah(rod.toY.toInt());
                      }
                      return BarTooltipItem(
                        valueText,
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: maxY > 0 ? maxY / 4 : 1,
                      getTitlesWidget: (value, meta) {
                        if (maxY < 1000) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        }
                        String text;
                        if (value >= 1000000000) {
                          text = "${(value / 1000000000).toStringAsFixed(1)} M";
                        } else if (value >= 1000000) {
                          text = "${(value / 1000000).toStringAsFixed(1)} JT";
                        } else if (value >= 1000) {
                          text = "${(value / 1000).toInt()} RB";
                        } else {
                          text = value.toInt().toString();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 9,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i >= labels.length || i < 0) {
                          return const SizedBox();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<BarChartGroupData> generateBarDataGeneric({
  required Map<DateTime, num> data,
  required List<Color> gradientColors,
  double barWidth = 18,
}) {
  final entries = data.entries.toList();
  return List.generate(entries.length, (index) {
    final item = entries[index];
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: item.value.toDouble(),
          width: barWidth,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: gradientColors,
          ),
        ),
      ],
    );
  });
}

class DashboardContainerWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icons;
  final Color colorIcon;
  final Color colorCircle;

  const DashboardContainerWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icons,
    required this.colorIcon,
    required this.colorCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: TextTheme.of(context).bodyLarge),
              Text(
                value,
                style: TextTheme.of(
                  context,
                ).bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: colorCircle,
            child: Center(child: Icon(icons, color: colorIcon, size: 20)),
          ),
        ],
      ),
    );
  }
}
