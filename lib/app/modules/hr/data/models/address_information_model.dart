import 'package:ts_admin/app/modules/hr/domain/entities/address_information_entity.dart';

class AddressInformationModel extends AddressInformationEntity {
  const AddressInformationModel({
    super.presentAddress,
    super.presentAddress2,
    super.presentCountry,
    super.presentState,
    super.presentStateId,
    super.presentCity,
    super.presentZip,
    super.yearsAtThisAddress,
    super.previousAddress,
    super.previousAddress2,
    super.previousCity,
    super.previousState,
    super.previousStateId,
    super.previousZip,
    super.previousCountry,
    super.previousYearsAtThisAddress,
  });

  factory AddressInformationModel.fromJson(Map<String, dynamic> json) =>
      AddressInformationModel(
        presentAddress: json["present_address"],
        presentAddress2: json["present_address_2"],
        presentCountry: json["present_country"],
        presentState: json["present_state"],
        presentStateId: json["present_state_id"],
        presentCity: json["present_city"],
        presentZip: json["present_zip"],
        yearsAtThisAddress: json["years_at_this_address"],
        previousAddress: json["previous_address"],
        previousAddress2: json["previous_address_2"],
        previousCity: json["previous_city"],
        previousState: json["previous_state"],
        previousStateId: json["previous_state_id"],
        previousZip: json["previous_zip"],
        previousCountry: json["previous_country"],
        previousYearsAtThisAddress: json["previous_years_at_this_address"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "present_address": presentAddress,
        "present_address_2": presentAddress2,
        "present_country": presentCountry,
        "present_state": presentState,
        "present_state_id": presentStateId,
        "present_city": presentCity,
        "present_zip": presentZip,
        "years_at_this_address": yearsAtThisAddress,
        "previous_address": previousAddress,
        "previous_address_2": previousAddress2,
        "previous_city": previousCity,
        "previous_state": previousState,
        "previous_state_id": previousStateId,
        "previous_zip": previousZip,
        "previous_country": previousCountry,
        "previous_years_at_this_address": previousYearsAtThisAddress,
      };
}
