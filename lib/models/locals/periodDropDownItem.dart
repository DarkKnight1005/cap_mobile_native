enum PeriodType{
  YEARLY,
  QUARTERLY,
  MONTHLY
}

class PeriodDropDownItem{

  final String title;
  final PeriodType periodType;
  final bool isSelectable;

  PeriodDropDownItem({required this.title, required this.periodType, required this.isSelectable});

}