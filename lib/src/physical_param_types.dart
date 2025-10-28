enum PhysicalType {
  length,
  square,
  velocity,
  acceleration,
  time,
  dimensionless,
}

enum LengthUnits { meter, foot, kilometer, seamiles, millimeter }

enum SquareUnits { squareMeter, squareFoot, squareKilometer, squareSeamile }

enum VelocityUnits { mps, kmph, smph, knots, parsec }

enum AccelerationUnits { mps2, kmph2, mph2 }

enum TimeUnits { sec, min, hour, day }

Map<PhysicalType, Map<Enum, String>> physicUnitsMap = {
  PhysicalType.length: lengthUnitsMap,
  PhysicalType.velocity: velocityUnitsMap,
  PhysicalType.time: timeUnitsMap,
  PhysicalType.acceleration: accelerationUnitsMap,
  PhysicalType.dimensionless: {},
};

Map<PhysicalType, Enum> defaultUnits = {
  PhysicalType.length: LengthUnits.meter,
  PhysicalType.time: TimeUnits.sec,
  // PhysicalType.velocity: VelocityUnits.mps,
  PhysicalType.acceleration: AccelerationUnits.mps2,
  // PhysicalType.square: SquareUnits.squareMeter,
};

Map<LengthUnits, String> lengthUnitsMap = {
  LengthUnits.meter: 'м',
  LengthUnits.foot: 'фут',
  LengthUnits.kilometer: 'км',
  // LengthUnits.seamiles: 'морские мили',
};

Map<VelocityUnits, String> velocityUnitsMap = {
  VelocityUnits.mps: 'м/с',
  VelocityUnits.kmph: 'км/ч',
  VelocityUnits.smph: 'морские_мили/ч',
  VelocityUnits.knots: 'узлы',
};

Map<TimeUnits, String> timeUnitsMap = {
  TimeUnits.sec: 'сек',
  TimeUnits.min: 'мин',
  TimeUnits.hour: 'час',
};

Map<AccelerationUnits, String> accelerationUnitsMap = {
  // AccelerationUnits.mps2: 'м/с²',
  AccelerationUnits.kmph2: 'км/ч²',
  AccelerationUnits.mph2: 'морские_мили/ч²',
};
