import 'package:ts_admin/app/modules/hr/data/models/application_file_model.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/driving_license_information_entity.dart';

class DrivingLicenseInformationModel extends DrivingLicenseInformationEntity {
  const DrivingLicenseInformationModel({
    super.cdlName,
    super.cdlType,
    super.cdlLicenseExpiration,
    super.abr,
    super.atr,
    super.cdlExp,
    super.currentLicenseNum,
    super.cdlDotMc,
    super.cdlIssuingState,
    super.cdlIssuingStateId,
    super.cdlEndorsement,
    super.cdlDotMcExpireDate,
    super.cdlDryVanExp,
    super.cdlFlatbedExp,
    super.cdlReeferExp,
    super.printName,
    super.license,
    super.medical,
  });

  factory DrivingLicenseInformationModel.fromJson(Map<String, dynamic> json) =>
      DrivingLicenseInformationModel(
        cdlName: json["cdl_name"],
        cdlType: json["cdl_type"],
        cdlLicenseExpiration: json["cdl_license_expiration"],
        abr: json["abr"],
        atr: json["atr"],
        cdlExp: json["cdl_exp"],
        currentLicenseNum: json["current_license_num"],
        cdlDotMc: json["cdl_dot_mc"],
        cdlIssuingState: json["cdl_issuing_state"],
        cdlIssuingStateId: json["cdl_issuing_state_id"].toString(),
        cdlEndorsement: json["cdl_endorsement"],
        cdlDotMcExpireDate: json["cdl_dot_mc_expire_date"],
        cdlDryVanExp: json["cdl_dry_van_exp"],
        cdlFlatbedExp: json["cdl_flatbed_exp"],
        cdlReeferExp: json["cdl_reefer_exp"],
        printName: json["print_name"],
        license: json["license"] == null
            ? null
            : ApplicationFileModel.fromJson(json["license"]),
        medical: json["medical"] == null
            ? null
            : ApplicationFileModel.fromJson(json["medical"]),
      );

  @override
  Map<String, dynamic> toJson() => {
        "cdl_name": cdlName,
        "cdl_type": cdlType,
        "cdl_license_expiration": cdlLicenseExpiration,
        "abr": abr,
        "atr": atr,
        "cdl_exp": cdlExp,
        "current_license_num": currentLicenseNum,
        "cdl_dot_mc": cdlDotMc,
        "cdl_issuing_state": cdlIssuingState,
        "cdl_issuing_state_id": cdlIssuingStateId,
        "cdl_endorsement": cdlEndorsement,
        "cdl_dot_mc_expire_date": cdlDotMcExpireDate,
        "cdl_dry_van_exp": cdlDryVanExp,
        "cdl_flatbed_exp": cdlFlatbedExp,
        "cdl_reefer_exp": cdlReeferExp,
        "print_name": printName,
        "license": license?.toJson(),
        "medical": medical?.toJson(),
      };
}
