import 'package:equatable/equatable.dart';
import 'package:ts_admin/app/modules/hr/domain/entities/application_file_entity.dart';

class DrivingLicenseInformationEntity extends Equatable {
  final String? cdlName;
  final String? cdlType;
  final String? cdlLicenseExpiration;
  final String? abr;
  final String? atr;
  final String? cdlExp;
  final String? currentLicenseNum;
  final String? cdlDotMc;
  final String? cdlIssuingState;
  final String? cdlIssuingStateId;
  final String? cdlEndorsement;
  final String? cdlDotMcExpireDate;
  final String? cdlDryVanExp;
  final String? cdlFlatbedExp;
  final String? cdlReeferExp;
  final String? printName;
  final ApplicationFileEntity? license;
  final ApplicationFileEntity? medical;

  const DrivingLicenseInformationEntity({
    this.cdlName,
    this.cdlType,
    this.cdlLicenseExpiration,
    this.abr,
    this.atr,
    this.cdlExp,
    this.currentLicenseNum,
    this.cdlDotMc,
    this.cdlIssuingState,
    this.cdlIssuingStateId,
    this.cdlEndorsement,
    this.cdlDotMcExpireDate,
    this.cdlDryVanExp,
    this.cdlFlatbedExp,
    this.cdlReeferExp,
    this.printName,
    this.license,
    this.medical,
  });

  factory DrivingLicenseInformationEntity.fromJson(Map<String, dynamic> json) =>
      DrivingLicenseInformationEntity(
        cdlName: json["cdl_name"],
        cdlType: json["cdl_type"],
        cdlLicenseExpiration: json["cdl_license_expiration"],
        abr: json["abr"],
        atr: json["atr"],
        cdlExp: json["cdl_exp"],
        currentLicenseNum: json["current_license_num"],
        cdlDotMc: json["cdl_dot_mc"],
        cdlIssuingState: json["cdl_issuing_state"],
        cdlIssuingStateId: json["cdl_issuing_state_id"],
        cdlEndorsement: json["cdl_endorsement"],
        cdlDotMcExpireDate: json["cdl_dot_mc_expire_date"],
        cdlDryVanExp: json["cdl_dry_van_exp"],
        cdlFlatbedExp: json["cdl_flatbed_exp"],
        cdlReeferExp: json["cdl_reefer_exp"],
        printName: json["print_name"],
        license: json["license"] == null
            ? null
            : ApplicationFileEntity.fromJson(json["license"]),
        medical: json["medical"] == null
            ? null
            : ApplicationFileEntity.fromJson(json["medical"]),
      );

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

  @override
  List<Object?> get props => [
        cdlName,
        cdlType,
        cdlLicenseExpiration,
        abr,
        atr,
        cdlExp,
        currentLicenseNum,
        cdlDotMc,
        cdlIssuingState,
        cdlIssuingStateId,
        cdlEndorsement,
        cdlDotMcExpireDate,
        cdlDryVanExp,
        cdlFlatbedExp,
        cdlReeferExp,
        printName,
        license,
        medical,
      ];
}
