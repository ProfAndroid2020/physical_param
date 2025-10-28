import 'package:physical_param/src/physical_param_types.dart';

// Map<PhysicalType, Map<Enum, double>> toCoefMap = {
//   PhysicalType.length: toMeter,
//   PhysicalType.time: toSec,
//   PhysicalType.velocity: toMps,
// };

Map<PhysicalType, Map<Enum, double>> fromCoefMap = {
  PhysicalType.length: fromMeter,
  PhysicalType.velocity: fromMps,
  PhysicalType.time: fromSec,
};

// Коэффициенты для работы с длинами

/// Коэффициент перевода футов в метры
const meterToFoot = 3.28084;

/// Коэффициент перевода метров в футы
const footToMeter = 1 / meterToFoot;

/// Коэффициент перевода километров в метры
const kilometerToMeter = 1000.0;

/// Коэффициент перевода метров в километры
const meterToKilometer = 1 / kilometerToMeter;

/// Коэффциент перевода морских миль в метры
const seamilesToMeter = 1852.0;

/// Коэффициент перевода метров в морские мили
const meterToSeamiles = 1 / seamilesToMeter;

/// Карта коэффициентов перевода в метры
Map<LengthUnits, double> toMeter = {
  LengthUnits.meter: 1,
  LengthUnits.foot: footToMeter,
  LengthUnits.kilometer: kilometerToMeter,
  LengthUnits.seamiles: seamilesToMeter,
};

/// Карта коэффициентов перевода из метров
Map<LengthUnits, double> fromMeter = {
  LengthUnits.meter: 1,
  LengthUnits.foot: meterToFoot,
  LengthUnits.kilometer: meterToKilometer,
  LengthUnits.seamiles: meterToSeamiles,
};

// Коэффициенты для работы со временем

/// Коэффициент перевода минут в секунды
const minToSec = 60.0;

/// Коэффициент перевода секунд в минуты
const secToMin = 1 / minToSec;

/// Коэффициент перевода часов в секунды
const hourToSec = 3600.0;

/// Коэффициент перевода секунд в часы
const secToHour = 1 / hourToSec;

/// Карта коэффициентов перевода в секунды
Map<TimeUnits, double> toSec = {
  TimeUnits.sec: 1,
  TimeUnits.min: minToSec,
  TimeUnits.hour: hourToSec,
};

/// Карта коэффициентов перевода из секунд
Map<TimeUnits, double> fromSec = {
  TimeUnits.sec: 1,
  TimeUnits.min: secToMin,
  TimeUnits.hour: secToHour,
};

// Коэффициенты для работы со скоростью

/// Коэффициент перевода метров в секунду в узлы
const mpsToKnot = 1.94384;

/// Коэффициент перевода узлов в метры в секунду
const knotToMps = 1 / mpsToKnot;

/// Коэффициент перевода метров в секунду в километры в час
const mpsToKmph = 3.6;

/// Коэффициент перевода километров в час в метры в секунду
const kmphToMps = 1 / mpsToKmph;

/// Коэффициент перевода метров в секунду в морские мили в час
const mpsToSmph = 1.9438612860586;

/// Коэффициент перевода морских миль в час в метры в секунду
const smphToMps = 1 / mpsToSmph;

Map<VelocityUnits, double> toMps = {
  VelocityUnits.mps: 1,
  VelocityUnits.knots: knotToMps,
  VelocityUnits.kmph: kmphToMps,
  VelocityUnits.smph: smphToMps,
};

Map<VelocityUnits, double> fromMps = {
  VelocityUnits.mps: 1,
  VelocityUnits.knots: mpsToKnot,
  VelocityUnits.kmph: mpsToKmph,
  VelocityUnits.smph: mpsToSmph,
};
