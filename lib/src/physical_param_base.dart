import 'package:physical_param/src/physical_conversion_constants.dart';
import 'package:physical_param/src/physical_param_types.dart';

const invalidTypeOperation = 'Invalid operation for this type';
const noFromCoef = 'Нет коэффиентов перевода из этого параметра';
const unknwonUnit = 'Неизвестные единицы измерения';

class PhysicalParam {
  final double value;
  final PhysicalType type;

  PhysicalParam._(this.value, this.type);

  factory PhysicalParam.dimensionless(double value) =>
      PhysicalParam._(value, PhysicalType.dimensionless);

  factory PhysicalParam.length(
    double value, [
    LengthUnits unit = LengthUnits.meter,
  ]) {
    final coef = toMeter[unit]!;
    return PhysicalParam._(value * coef, PhysicalType.length);
  }

  factory PhysicalParam.square(
    double value, [
    SquareUnits unit = SquareUnits.squareMeter,
  ]) => PhysicalParam._(value, PhysicalType.square);

  factory PhysicalParam.time(double value, [TimeUnits unit = TimeUnits.sec]) {
    final coef = toSec[unit]!;
    return PhysicalParam._(value * coef, PhysicalType.time);
  }

  factory PhysicalParam.velocity(
    double value, [
    VelocityUnits unit = VelocityUnits.mps,
  ]) {
    final coef = toMps[unit]!;
    return PhysicalParam._(value * coef, PhysicalType.velocity);
  }

  factory PhysicalParam.acceleration(
    double value, [
    AccelerationUnits unit = AccelerationUnits.mps2,
  ]) => PhysicalParam._(value, PhysicalType.acceleration);

  PhysicalParam operator +(PhysicalParam other) {
    if (type != other.type) throw ArgumentError('Types must match');
    return PhysicalParam._(value + other.value, type);
  }

  PhysicalParam operator -(PhysicalParam other) {
    if (type != other.type) throw ArgumentError('Types must match');
    return PhysicalParam._(value - other.value, type);
  }

  PhysicalParam operator /(PhysicalParam other) {
    if (type == other.type) {
      return PhysicalParam.dimensionless(value / other.value);
    } else {
      switch (type) {
        // Деление длины
        case PhysicalType.length when other.type == PhysicalType.velocity:
          return PhysicalParam.time(value / other.value);
        case PhysicalType.length when other.type == PhysicalType.time:
          return PhysicalParam.velocity(value / other.value);

        // Деление скорости
        case PhysicalType.velocity when other.type == PhysicalType.time:
          return PhysicalParam.acceleration(value / other.value);
        default:
          throw ArgumentError(invalidTypeOperation);
      }
    }
  }

  PhysicalParam operator *(PhysicalParam other) {
    switch (type) {
      // Умножение длины
      case PhysicalType.length when other.type == PhysicalType.length:
        return PhysicalParam.square(value * other.value);

      // Умножение времени
      case PhysicalType.time when other.type == PhysicalType.velocity:
        return PhysicalParam.length(value * other.value);

      // Умножение скорости
      case PhysicalType.velocity when other.type == PhysicalType.time:
        return PhysicalParam.length(value * other.value);

      default:
        throw ArgumentError(invalidTypeOperation);
    }
  }

  double getValue(Enum unit) {
    final unitMap = physicUnitsMap[type]!;
    if (unitMap.containsKey(unit)) {
      double coef;
      switch (type) {
        case PhysicalType.length:
          coef = fromMeter[unit]!;
          break;
        case PhysicalType.time:
          coef = fromSec[unit]!;

        case PhysicalType.velocity:
          coef = fromMps[unit]!;
        default:
          throw ArgumentError(noFromCoef);
      }
      return value * coef;
    } else {
      throw ArgumentError(
        'У параметра типа ${type.name} нет таких единиц измерения ${unit.name}',
      );
    }
  }

  String getString([dynamic unit]) {
    if (type == PhysicalType.dimensionless) {
      return value.toStringAsFixed(2);
    }
    dynamic targetUnit;
    if (unit == null) {
      targetUnit = defaultunit[type]!;
    } else {
      targetUnit = unit;
    }
    return '${getValue(targetUnit).toStringAsFixed(2)} ${physicUnitsMap[type]?[targetUnit] ?? ''}';
  }
}
