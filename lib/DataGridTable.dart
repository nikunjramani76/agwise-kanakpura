import 'package:chatbot/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PopSchedule{
  String field,fertilizer,mode,perplant,total,applicationdescription,date;

  PopSchedule(this.field, this.date, this.fertilizer, this.mode, this.perplant, this.total,
      this.applicationdescription);

}


Widget buildDataGridTable(){
  PopDataSource _popDataSource;



_popDataSource=PopDataSource(Constant.popschedule);
  return Container(
    // margin: EdgeInsets.all(10),
    child: SfDataGrid(
      columnWidthMode: ColumnWidthMode.fill,
      source: _popDataSource,
      columns: [

        GridTextColumn(
          width: 70,
            columnName: 'Field',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Field',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
            width: 150,
            columnName: 'Date',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
          width: 100,
            columnName: 'Fertilizer',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fertilizer',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
          width: 120,
            columnName: 'Mode',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mode',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
          width: 150,
            columnName: 'Per Plant(gm)',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Per Plant(gm)',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
            width: 100,
            columnName: 'Total(kg)',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Total(kg)',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
            width: 300,
            columnName: 'Application Description',
            label: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Application Description',
                  overflow: TextOverflow.ellipsis,
                ))),

      ],
      selectionMode: SelectionMode.multiple,
    ),
  );
}

class PopDataSource extends DataGridSource {

PopDataSource(List<PopSchedule> popschedule) {
  dataGridRows = popschedule
      .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
    DataGridCell<String>(columnName: 'field', value: dataGridRow.field),
    DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
    DataGridCell<String>(columnName: 'fertilizer', value: dataGridRow.fertilizer),
    DataGridCell<String>(columnName: 'mode', value: dataGridRow.mode),
    DataGridCell<String>(columnName: 'perplant', value: dataGridRow.perplant),
    DataGridCell<String>(columnName: 'total', value: dataGridRow.total),
    DataGridCell<String>(columnName: 'applicationdescription', value: dataGridRow.applicationdescription),

  ]))
      .toList();
}

List<DataGridRow> dataGridRows = [];

@override
List<DataGridRow> get rows => dataGridRows;

@override
DataGridRowAdapter buildRow(DataGridRow row) {
  return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
          dataGridCell.value.toString(),
          // overflow: TextOverflow.ellipsis,
        ));
      }).toList());
}
@override
bool shouldRecalculateColumnWidths() {
  return true;
}

}