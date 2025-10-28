import 'package:physical_param/physical_param.dart';
import 'package:test/test.dart';

void main() {
  group('PhysicalParam Creation', () {
    test('length with meter', () {
      final param = PhysicalParam.length(10, LengthUnits.meter);
      expect(param.value, 10);
      expect(param.type, PhysicalType.length);
    });

    test('length with kilometer conversion', () {
      final param = PhysicalParam.length(1, LengthUnits.kilometer);
      expect(param.value, 1000); // 1 km = 1000 meters
      expect(param.type, PhysicalType.length);
    });

    test('time with sec', () {
      final param = PhysicalParam.time(30, TimeUnits.sec);
      expect(param.value, 30);
      expect(param.type, PhysicalType.time);
    });

    test('time with hour conversion', () {
      final param = PhysicalParam.time(1, TimeUnits.hour);
      expect(param.value, 3600); // 1 hour = 3600 seconds
      expect(param.type, PhysicalType.time);
    });

    test('velocity with mps', () {
      final param = PhysicalParam.velocity(20, VelocityUnits.mps);
      expect(param.value, 20);
      expect(param.type, PhysicalType.velocity);
    });

    test('velocity with kmph conversion', () {
      final param = PhysicalParam.velocity(36, VelocityUnits.kmph);
      expect(param.value, closeTo(10, 0.001)); // 36 km/h ≈ 10 m/s
      expect(param.type, PhysicalType.velocity);
    });

    test('dimensionless creation', () {
      final param = PhysicalParam.dimensionless(5.5);
      expect(param.value, 5.5);
      expect(param.type, PhysicalType.dimensionless);
    });
  });

  group('PhysicalParam Operations', () {
    test('length + length', () {
      final a = PhysicalParam.length(10);
      final b = PhysicalParam.length(5);
      final result = a + b;
      expect(result.value, 15);
      expect(result.type, PhysicalType.length);
    });
    test('velocity - velocity', () {
      final a = PhysicalParam.velocity(10);
      final b = PhysicalParam.velocity(5);
      final result = a - b;
      expect(result.value, 5);
      expect(result.type, PhysicalType.velocity);
    });

    test('length / velocity = time', () {
      final length = PhysicalParam.length(100);
      final velocity = PhysicalParam.velocity(20);
      final result = length / velocity;
      expect(result.value, 5);
      expect(result.type, PhysicalType.time);
    });

    test('length / time = velocity', () {
      final length = PhysicalParam.length(200);
      final time = PhysicalParam.time(40);
      final result = length / time;
      expect(result.value, 5);
      expect(result.type, PhysicalType.velocity);
    });

    test('velocity / time = acceleration', () {
      final velocity = PhysicalParam.velocity(30);
      final time = PhysicalParam.time(6);
      final result = velocity / time;
      expect(result.value, 5);
      expect(result.type, PhysicalType.acceleration);
    });

    test('same type division returns dimensionless', () {
      final a = PhysicalParam.length(15);
      final b = PhysicalParam.length(3);
      final result = a / b;
      expect(result.value, 5);
      expect(result.type, PhysicalType.dimensionless);
    });

    test('length * length = square', () {
      final a = PhysicalParam.length(4);
      final b = PhysicalParam.length(5);
      final result = a * b;
      expect(result.value, 20);
      expect(result.type, PhysicalType.square);
    });

    test('time * velocity = length', () {
      final time = PhysicalParam.time(3);
      final velocity = PhysicalParam.velocity(10);
      final result = time * velocity;
      expect(result.value, 30);
      expect(result.type, PhysicalType.length);
    });

    test('velocity * time = length', () {
      final velocity = PhysicalParam.velocity(8);
      final time = PhysicalParam.time(4);
      final result = velocity * time;
      expect(result.value, 32);
      expect(result.type, PhysicalType.length);
    });
  });

  group('PhysicalParam Getters', () {
    test('getValue for length with different units', () {
      final param = PhysicalParam.length(1000); // 1000 meters
      expect(param.getValue(LengthUnits.meter), 1000);
      expect(param.getValue(LengthUnits.kilometer), 1);
    });

    test('getValue for time with different units', () {
      final param = PhysicalParam.time(3600); // 3600 seconds
      expect(param.getValue(TimeUnits.sec), 3600);
      expect(param.getValue(TimeUnits.hour), 1);
    });

    test('getValue for velocity with different units', () {
      final param = PhysicalParam.velocity(10); // 10 m/s
      expect(param.getValue(VelocityUnits.mps), 10);
      expect(param.getValue(VelocityUnits.kmph), closeTo(36, 0.001));
    });

    test('getValue dimensionless returns value', () {
      final param = PhysicalParam.dimensionless(7.5);
      expect(param.getValue(), 7.5);
      expect(
        param.getValue(LengthUnits.meter),
        7.5,
      ); // unit ignored for dimensionless
    });

    test('getString with default unit', () {
      final length = PhysicalParam.length(15.123);
      expect(length.getString(), '15.12 м');

      final time = PhysicalParam.time(30.789);
      expect(time.getString(), '30.79 сек');
    });

    test('getString with specific unit', () {
      final length = PhysicalParam.length(1500);
      expect(length.getString(LengthUnits.kilometer), '1.50 км');

      final time = PhysicalParam.time(7200);
      expect(time.getString(TimeUnits.hour), '2.00 час');
    });

    test('getString dimensionless', () {
      final dim = PhysicalParam.dimensionless(7.556);
      expect(dim.getString(), '7.56');
    });

    test('getValue with invalid unit throws error', () {
      final param = PhysicalParam.length(10);
      expect(() => param.getValue(TimeUnits.sec), throwsArgumentError);
    });
    test('getValue with no coef map', () {
      final param = PhysicalParam.square(10);
      expect(() => param.getValue(SquareUnits.squareFoot), throwsArgumentError);
    });

    test('getString with invalid unit throws error', () {
      final param = PhysicalParam.length(10);
      expect(() => param.getString(TimeUnits.sec), throwsArgumentError);
    });
    test('getString with no unitsString map', () {
      final param = PhysicalParam.square(10);
      expect(
        () => param.getString(SquareUnits.squareFoot),
        throwsArgumentError,
      );
    });
    test('getString with no default unit', () {
      final param = PhysicalParam.velocity(10);
      expect(() => param.getString(), throwsArgumentError);
    });
    test('getString with no default unit', () {
      final param = PhysicalParam.acceleration(10);
      expect(() => param.getString(), throwsArgumentError);
    });
    test('getString with no target unit string in map', () {
      final param = PhysicalParam.length(10);
      expect(() => param.getString(LengthUnits.seamiles), throwsArgumentError);
    });
  });

  group('Error Cases', () {
    test('invalid addition throws error', () {
      final length = PhysicalParam.length(10);
      final time = PhysicalParam.time(5);
      expect(() => length + time, throwsArgumentError);
    });

    test('invalid division throws error', () {
      final length = PhysicalParam.length(10);
      final acceleration = PhysicalParam.acceleration(2);
      expect(() => length / acceleration, throwsArgumentError);
    });

    test('invalid multiplication throws error', () {
      final length = PhysicalParam.length(10);
      final velocity = PhysicalParam.velocity(2);
      expect(() => length * velocity, throwsArgumentError);
    });

    test('invalid unit on creation length', () {
      expect(
        () => PhysicalParam.length(10, LengthUnits.millimeter),
        throwsArgumentError,
      );
    });
    test('invalid unit on creation velocity', () {
      expect(
        () => PhysicalParam.velocity(10, VelocityUnits.parsec),
        throwsArgumentError,
      );
    });
    test('invalid unit on creation time', () {
      expect(() => PhysicalParam.time(10, TimeUnits.day), throwsArgumentError);
    });
  });
}
