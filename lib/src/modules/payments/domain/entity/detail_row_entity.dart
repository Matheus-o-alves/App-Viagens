class DetailRowData {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  DetailRowData({
    this.leftLabel = '',
    this.leftValue = '',
    this.rightLabel = '',
    this.rightValue = '',
  });

  bool get isEmpty => leftLabel.isEmpty && rightLabel.isEmpty;
}
