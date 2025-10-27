import 'package:physical_param/physical_param.dart';
import 'package:physical_param/src/physical_param_types.dart';
import 'package:test/test.dart';

void main() {
  group('PhysicalParam Basic Operations', () {
    test('length + length', () {
      final a = PhysicalParam.length(10);
      final b = PhysicalParam.length(5);
      final result = a + b;
      expect(result.value, 15);
      expect(result.type, PhysicalType.length);
    });

    test('length - length', () {
      final a = PhysicalParam.length(10);
      final b = PhysicalParam.length(3);
      final result = a - b;
      expect(result.value, 7);
      expect(result.type, PhysicalType.length);
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

  group('PhysicalParam Unit Conversion', () {
    test('length conversion - meters to feet', () {
      final length = PhysicalParam.length(1, LengthUnits.meter);
      final valueInFeet = length.getValue(LengthUnits.foot);
      expect(valueInFeet, closeTo(3.28084, 0.001));
    });

    test('length conversion - feet to meters', () {
      final length = PhysicalParam.length(3.28084, LengthUnits.foot);
      final valueInMeters = length.getValue(LengthUnits.meter);
      expect(valueInMeters, closeTo(1.0, 0.001));
    });

    test('time conversion - seconds to minutes', () {
      final time = PhysicalParam.time(60, TimeUnits.sec);
      final valueInMinutes = time.getValue(TimeUnits.min);
      expect(valueInMinutes, closeTo(1.0, 0.001));
    });

    test('time conversion - minutes to seconds', () {
      final time = PhysicalParam.time(1, TimeUnits.min);
      final valueInSeconds = time.getValue(TimeUnits.sec);
      expect(valueInSeconds, closeTo(60.0, 0.001));
    });

    test('velocity conversion - mps to kmph', () {
      final velocity = PhysicalParam.velocity(1, VelocityUnits.mps);
      final valueInKmph = velocity.getValue(VelocityUnits.kmph);
      expect(valueInKmph, closeTo(3.6, 0.001));
    });

    test('velocity conversion - knots to mps', () {
      final velocity = PhysicalParam.velocity(1, VelocityUnits.knots);
      final valueInMps = velocity.getValue(VelocityUnits.mps);
      expect(valueInMps, closeTo(0.514, 0.001));
    });
  });

  group('PhysicalParam String Representation', () {
    test('toString with default units', () {
      final length = PhysicalParam.length(15.123);
      expect(length.getString(), '15.12 м');

      final velocity = PhysicalParam.velocity(20.456);
      expect(velocity.getString(), '20.46 м/с');

      final time = PhysicalParam.time(30.789);
      expect(time.getString(), '30.79 сек');
    });

    test('toString with specific units', () {
      final length = PhysicalParam.length(1, LengthUnits.meter);
      expect(length.getString(LengthUnits.foot), '3.28 фут');

      final time = PhysicalParam.time(3600, TimeUnits.sec);
      expect(time.getString(TimeUnits.hour), '1.00 час');

      final velocity = PhysicalParam.velocity(1, VelocityUnits.mps);
      expect(velocity.getString(VelocityUnits.kmph), '3.60 км/ч');
    });

    test('dimensionless string representation', () {
      final dim = PhysicalParam.dimensionless(7.5);
      expect(dim.getString(), '7.50');
    });
  });

  group('PhysicalParam Error Cases', () {
    test('invalid addition throws error', () {
      final length = PhysicalParam.length(10);
      final time = PhysicalParam.time(5);
      expect(() => length + time, throwsArgumentError);
    });

    test('invalid subtraction throws error', () {
      final length = PhysicalParam.length(10);
      final velocity = PhysicalParam.velocity(5);
      expect(() => length - velocity, throwsArgumentError);
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

    test('getValue with invalid unit throws error', () {
      final length = PhysicalParam.length(10);
      expect(() => length.getValue(TimeUnits.sec), throwsArgumentError);
    });
  });

  group('PhysicalParam Factory Methods', () {
    test('length factory with different units', () {
      final lengthMeter = PhysicalParam.length(1, LengthUnits.meter);
      final lengthFoot = PhysicalParam.length(3.28084, LengthUnits.foot);
      expect(lengthMeter.value, closeTo(lengthFoot.value, 0.001));
    });

    test('time factory with different units', () {
      final timeSec = PhysicalParam.time(60, TimeUnits.sec);
      final timeMin = PhysicalParam.time(1, TimeUnits.min);
      expect(timeSec.value, closeTo(timeMin.value, 0.001));
    });

    test('velocity factory with different units', () {
      final velocityMps = PhysicalParam.velocity(1, VelocityUnits.mps);
      final velocityKmph = PhysicalParam.velocity(3.6, VelocityUnits.kmph);
      expect(velocityMps.value, closeTo(velocityKmph.value, 0.001));
    });

    test('dimensionless factory', () {
      final dim = PhysicalParam.dimensionless(5.5);
      expect(dim.value, 5.5);
      expect(dim.type, PhysicalType.dimensionless);
    });
  });
}
