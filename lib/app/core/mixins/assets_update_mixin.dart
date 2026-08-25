import 'package:get/get.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/trailer_entity.dart';
import 'package:ts_admin/app/modules/assets_management/domain/entities/truck_entity.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/trailers/controllers/trailers_controller.dart';
import 'package:ts_admin/app/modules/assets_management/presentation/trucks/controllers/trucks_controller.dart';

// Mixin that can be used by multiple controllers
mixin AssetsUpdateMixin {
  void syncTrucks({
    required String id,
    required TruckEntity updatedTruck,
  }) {
    final controller = Get.find<TrucksController>();
    final index = controller.trucks.indexWhere(
      (element) => element.id.toString() == id,
    );

    if (index != -1) {
      controller.trucks[index] = updatedTruck;
      controller.trucks.refresh();
    }
  }

  void syncTrailers({
    required String id,
    required TrailerEntity updatedTrailer,
  }) {
    final controller = Get.find<TrailersController>();
    final index = controller.trailers.indexWhere(
      (element) => element.id.toString() == id,
    );

    if (index != -1) {
      controller.trailers[index] = updatedTrailer;
      controller.trailers.refresh();
    }
  }
}
