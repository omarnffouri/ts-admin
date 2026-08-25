import 'package:dartz/dartz.dart';
import 'package:ts_admin/app/core/enum/additional_pay_status.dart';
import 'package:ts_admin/app/core/helpers/base_use_case.dart';
import 'package:ts_admin/app/core/network/error/failures.dart';
import 'package:ts_admin/app/modules/shipment/domain/enitities/additional_pay_entity.dart';
import 'package:ts_admin/app/modules/shipment/domain/repositories/shipment_repository.dart';

class ResolveAdditionalPayUsecase
    extends BaseUseCase<AdditionalPayEntity, ResolveAdditionalPayParams> {
  final IShipmentRepository shipmentRepository;

  ResolveAdditionalPayUsecase({required this.shipmentRepository});

  @override
  Future<Either<AdditionalPayEntity, Failure>> call(
      ResolveAdditionalPayParams params) async {
    return await shipmentRepository.resolveAdditionalPay(params);
  }
}

class ResolveAdditionalPayParams {
  /// Goes in the path, not the body.
  final int id;
  final AdditionalPayStatus status;
  final String? decisionNote;

  const ResolveAdditionalPayParams({
    required this.id,
    required this.status,
    this.decisionNote,
  });

  Map<String, dynamic> toBody() => {
        'status': status.name,
        if (decisionNote != null && decisionNote!.isNotEmpty)
          'decision_note': decisionNote,
      };
}
