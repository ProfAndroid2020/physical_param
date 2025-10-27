# physical_param

Dart библиотека для типобезопасной работы с физическими параметрами, единицами измерения и автоматическими преобразованиями.

## Проблема

При работе с физическими величинами легко допустить ошибки смешивания единиц измерения:

### ❌ Без библиотеки - потенциальные ошибки

```dart
// Опасно - легко перепутать единицы измерения
double calculateTime(double distanceInMeters, double speedInKmph) {
  // Баг! Смешиваем метры и км/ч без преобразования
  return distanceInMeters / speedInKmph; // Неправильный результат!
}

double calculateVelocity(double distanceInMiles, double timeInMinutes) {
  // Нужно помнить все коэффициенты преобразования
  final distanceInMeters = distanceInMiles * 1609.34;
  final timeInSeconds = timeInMinutes * 60;
  return distanceInMeters / timeInSeconds; // м/с
}

void main() {
  // Какие единицы? Легко перепутать!
  final distance = 100.0; // Метры? Километры? Мили?
  final speed = 50.0;     // м/с? км/ч? мили/час?
  
  final time = distance / speed; // Бессмысленный результат!
  print('Время: $time'); // 2.0... но 2 чего?
}
```

## Решение

### ✅ С библиотекой physical_param

```dart
import 'package:physical_param/physical_param.dart';

void main() {
  // Создание параметров с явными единицами измерения
  final distance = PhysicalParam.length(100, LengthUnits.kilometer);
  final speed = PhysicalParam.velocity(50, VelocityUnits.kmph);
  final time = PhysicalParam.time(2, TimeUnits.hour);
  
  // Автоматические преобразования и проверка типов
  final travelTime = distance / speed; // PhysicalParam.time
  print('Время пути: ${travelTime.getString(TimeUnits.hour)}'); // "2.00 час"
  
  final requiredSpeed = distance / time; // PhysicalParam.velocity  
  print('Необходимая скорость: ${requiredSpeed.getString(VelocityUnits.kmph)}'); // "50.00 км/ч"
  
  // Автоматическое определение результирующего типа
  final acceleration = speed / time; // PhysicalParam.acceleration
  print('Ускорение: ${acceleration.getString()}'); // "25.00 м/с²"
  
  // Умножение с автоматическим определением типа
  final area = distance * distance; // PhysicalParam.square
  print('Площадь: ${area.getString()}'); // "10000.00 м²"
}
```

## Возможности

### 📐 Поддерживаемые физические величины
- **Длина** (метры, футы, километры, мили)
- **Время** (секунды, минуты, часы)  
- **Скорость** (м/с, км/ч, узлы, мили/час)
- **Ускорение** (м/с², км/ч²)
- **Площадь** (м², футы², км², мили²)
- **Безразмерные величины**

### 🔧 Операции
```dart
final a = PhysicalParam.length(10);
final b = PhysicalParam.velocity(2);

// Сложение/вычитание (только одинаковые типы)
final sum = a + PhysicalParam.length(5);

// Умножение/деление с автоматическим определением типа
final time = a / b;           // Длина / Скорость = Время
final speed = a / time;       // Длина / Время = Скорость  
final area = a * a;           // Длина × Длина = Площадь
```

### 🔄 Преобразования единиц
```dart
final distance = PhysicalParam.length(1, LengthUnits.mile);
print(distance.getString(LengthUnits.kilometer)); // "1.85 км"
print(distance.getString(LengthUnits.foot));      // "6076.12 фут"

final speed = PhysicalParam.velocity(1, VelocityUnits.mps); 
print(speed.getString(VelocityUnits.kmph));       // "3.60 км/ч"
print(speed.getString(VelocityUnits.knots));      // "1.94 узлы"
```

## Установка

Добавьте в `pubspec.yaml`:
```yaml
dependencies:
  physical_param: ^1.0.0
```

И запустите:
```bash
dart pub get
```

## Типобезопасность

Библиотека предотвращает распространенные ошибки:

```dart
final length = PhysicalParam.length(100);
final time = PhysicalParam.time(5);

// ❌ Не скомпилируется - нельзя складывать разные типы
// length + time; // ArgumentError: Types must match

// ✅ Автоматическое преобразование при делении
final velocity = length / time; // PhysicalParam.velocity
```

## Примеры использования

### 🚗 Расчет времени пути
```dart
void calculateTrip() {
  final distance = PhysicalParam.length(350, LengthUnits.kilometer);
  final averageSpeed = PhysicalParam.velocity(80, VelocityUnits.kmph);
  
  final tripTime = distance / averageSpeed;
  print('Время в пути: ${tripTime.getString(TimeUnits.hour)}'); // "4.38 час"
}
```

### 🏃 Расчет скорости
```dart
void calculateRunningPace() {
  final marathon = PhysicalParam.length(42.195, LengthUnits.kilometer);
  final worldRecord = PhysicalParam.time(2 * 3600 + 1 * 60 + 39); // 2:01:39
  
  final pace = marathon / worldRecord;
  print('Темп: ${pace.getString(VelocityUnits.kmph)}'); // "20.81 км/ч"
}
```

### 📊 Научные расчеты
```dart
void physicsCalculations() {
  final initialSpeed = PhysicalParam.velocity(10); // 10 м/с
  final acceleration = PhysicalParam.acceleration(2); // 2 м/с²
  final time = PhysicalParam.time(5); // 5 сек
  
  final finalSpeed = initialSpeed + (acceleration * time);
  final distance = initialSpeed * time + (acceleration * time * time) / 2;
  
  print('Конечная скорость: ${finalSpeed.getString()}'); // "20.00 м/с"
  print('Пройденное расстояние: ${distance.getString()}'); // "75.00 м"
}
```

## Поддерживаемые преобразования

| Операция | Результат |
|----------|-----------|
| Длина / Скорость | Время |
| Длина / Время | Скорость |
| Скорость / Время | Ускорение |
| Длина × Длина | Площадь |
| Скорость × Время | Длина |
| Время × Скорость | Длина |

## Разработка

Запуск тестов:
```bash
dart test
```

Генерация документации:
```bash
dart doc
```

## Лицензия

MIT License - смотрите файл [LICENSE](LICENSE) для деталей.