import 'dart:ffi';

import 'package:chatbot/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlotGraph{
  final String label;
  final double r1if;
  double r2if;
  double r3if;
  PlotGraph(this.label,this.r1if,this.r2if,this.r3if);
}

Widget BarGraph(){
   TooltipBehavior _tooltipBehavior;
   _tooltipBehavior = TooltipBehavior(
       enable: true);
  return SfCartesianChart(
      tooltipBehavior: _tooltipBehavior,
      // borderColor: Colors.red,
      // borderWidth: 2,
      // Sets 15 logical pixels as margin for all the 4 sides.
      margin: EdgeInsets.all(15),
      primaryXAxis: CategoryAxis(),
      legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom
      ),
      // enableSideBySideSeriesPlacement: false,
      series: <ChartSeries>[
        BarSeries<PlotGraph, String>(
          name:'Replica 1',
          color: Colors.blue,
          enableTooltip: true,
          dataSource: Constant.ploatData,
          // dataLabelSettings: DataLabelSettings(isVisible:true, showCumulativeValues: true),
            xValueMapper: (PlotGraph plot, _) =>  plot.label,
            yValueMapper: (PlotGraph plot, _) => plot.r1if,
        ),
        BarSeries<PlotGraph, String>(
          name:'Replica 2',
          color: Colors.yellow,
          enableTooltip: true,
          dataSource: Constant.ploatData,
          // dataLabelSettings: DataLabelSettings(isVisible:true, showCumulativeValues: true),
          xValueMapper: (PlotGraph plot, _) =>  plot.label,
          yValueMapper: (PlotGraph plot, _) => plot.r2if,
        ),
        BarSeries<PlotGraph, String>(
          name:'Replica 3',
          enableTooltip: true,
          color: Colors.green,
          // dataLabelSettings: DataLabelSettings(isVisible:true, showCumulativeValues: true),
          dataSource: Constant.ploatData,
          xValueMapper: (PlotGraph plot, _) =>  plot.label,
          yValueMapper: (PlotGraph plot, _) => plot.r3if,
        ),
      ]
  );

}