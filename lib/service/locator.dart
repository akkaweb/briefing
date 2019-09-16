import 'package:briefing/route/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
