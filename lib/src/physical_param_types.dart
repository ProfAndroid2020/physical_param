enum PhysicalType {
  length,
  square,
  velocity,
  acceleration,
  time,
  dimensionless,
}

enum LengthUnits { meter, foot, kilometer, miles }

enum SquareUnits { squareMeter, squareFoot, squareKilometer, squareSeamiles }

enum VelocityUnits { mps, kmph, smph, knots }

enum AccelerationUnits { mps2, kmph2, mph2 }

enum TimeUnits { sec, min, hour }

Map<PhysicalType, Map<Enum, String>> physicUnitsMap = {
  PhysicalType.length: lengthUnitsMap,
  PhysicalType.velocity: velocityUnitsMap,
  PhysicalType.time: timeUnitsMap,
  PhysicalType.dimensionless: {},
};

Map<PhysicalType, dynamic> defaultunit = {
  PhysicalType.length: LengthUnits.meter,
  PhysicalType.time: TimeUnits.sec,
  PhysicalType.velocity: VelocityUnits.mps,
  PhysicalType.acceleration: AccelerationUnits.mps2,
  PhysicalType.square: SquareUnits.squareMeter,
  PhysicalType.dimensionless: null,
};

Map<LengthUnits, String> lengthUnitsMap = {
  LengthUnits.meter: 'м',
  LengthUnits.foot: 'фут',
  LengthUnits.kilometer: 'км',
  LengthUnits.miles: 'морские мили',
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
