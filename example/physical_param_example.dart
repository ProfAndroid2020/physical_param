import 'package:physical_param/physical_param.dart';
import 'package:physical_param/src/physical_param_types.dart';

void main() {
  final distance = PhysicalParam.length(600);
  final time = PhysicalParam.time(10);

  final speed = distance / time;

  print(speed.getString(VelocityUnits.knots));
}
