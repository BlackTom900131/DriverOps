import 'package:shared_preferences/shared_preferences.dart';
import '../shared/models/driver.dart';

class DriverService {
  static const _key = 'drivers';

  Future<List<Driver>> getDrivers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    return Driver.listFromJson(jsonString);
  }

  Future<void> saveDrivers(List<Driver> drivers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Driver.listToJson(drivers));
  }

  Future<void> addDriver(Driver driver) async {
    final drivers = await getDrivers();
    drivers.add(driver);
    await saveDrivers(drivers);
  }

  Future<void> updateDriver(Driver updated) async {
    final drivers = await getDrivers();
    final idx = drivers.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      drivers[idx] = updated;
      await saveDrivers(drivers);
    }
  }

  Future<void> deleteDriver(String id) async {
    final drivers = await getDrivers();
    drivers.removeWhere((d) => d.id == id);
    await saveDrivers(drivers);
  }
}
