import 'package:equatable/equatable.dart';

class AddressInformationEntity extends Equatable {
  final String? presentAddress;
  final String? presentAddress2;
  final String? presentCountry;
  final String? presentState;
  final dynamic presentStateId;
  final String? presentCity;
  final String? presentZip;
  final String? yearsAtThisAddress;
  final String? previousAddress;
  final String? previousAddress2;
  final String? previousCity;
  final String? previousState;
  final dynamic previousStateId;
  final String? previousZip;
  final String? previousCountry;
  final String? previousYearsAtThisAddress;

  const AddressInformationEntity({
    this.presentAddress,
    this.presentAddress2,
    this.presentCountry,
    this.presentState,
    this.presentStateId,
    this.presentCity,
    this.presentZip,
    this.yearsAtThisAddress,
    this.previousAddress,
    this.previousAddress2,
    this.previousCity,
    this.previousState,
    this.previousStateId,
    this.previousZip,
    this.previousCountry,
    this.previousYearsAtThisAddress,
  });

  factory AddressInformationEntity.fromJson(Map<String, dynamic> json) =>
      AddressInformationEntity(
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

  @override
  List<Object?> get props => [
        presentAddress,
        presentAddress2,
        presentCountry,
        presentState,
        presentStateId,
        presentCity,
        presentZip,
        yearsAtThisAddress,
        previousAddress,
        previousAddress2,
        previousCity,
        previousState,
        previousStateId,
        previousZip,
        previousCountry,
        previousYearsAtThisAddress,
      ];

  String? getPresentYearsDuration() {
    if (yearsAtThisAddress == null) {
      return null;
    }

    if (yearsAtThisAddress == "N/A") {
      return null;
    }

    return "$yearsAtThisAddress Years";
  }

  String? getPreviousYearsDuration() {
    if (previousYearsAtThisAddress == null) {
      return null;
    }

    if (previousYearsAtThisAddress == "N/A") {
      return null;
    }

    return "$previousYearsAtThisAddress Years";
  }

  bool havePreviousAddress() {
    return _isNotNullOrEmpty(previousAddress) ||
        _isNotNullOrEmpty(previousAddress2) ||
        _isNotNullOrEmpty(previousCity) ||
        _isNotNullOrEmpty(previousState) ||
        _isNotNullOrEmpty(previousCountry) ||
        _isNotNullOrEmpty(previousZip);
  }

  bool _isNotNullOrEmpty(String? data) {
    final string = (data ?? "");
    return string.isNotEmpty && string.toLowerCase() != "n/a";
  }
}
