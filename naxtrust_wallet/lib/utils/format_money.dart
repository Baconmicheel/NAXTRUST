import 'package:intl/intl.dart' as intl;

formatMoney(var money) {
  if (money is String)
    return intl.NumberFormat.decimalPattern().format(double.parse(money));
  else
    return intl.NumberFormat.decimalPattern().format(money);
}
