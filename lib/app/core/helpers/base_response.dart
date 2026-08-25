import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class BaseResponse<T> extends Equatable {
  late String? message;
  late bool? hasMore;
  late int? code;
  late T? data;

  BaseResponse({this.message, this.hasMore, this.code, this.data});

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) payloadFromJson) {
    return BaseResponse<T>(
      message: json['message'],
      hasMore: json['has_more'],
      code: json['code'],
      data: payloadFromJson(json['data']),
    );
  }

  /// List payload: null/absent `data` parses as an empty list.
  /// [hasMoreWhenOmitted] derives `hasMore` when the envelope has no
  /// `has_more` (per convention: full page ⇒ more).
  static BaseResponse<List<E>> listFromJson<E>(
      Map<String, dynamic> json, E Function(dynamic) itemFromJson,
      {bool Function(List<E> data)? hasMoreWhenOmitted}) {
    final List<E> data =
        List<E>.from((json['data'] as List? ?? []).map(itemFromJson));
    return BaseResponse<List<E>>(
      message: json['message'],
      hasMore: json['has_more'] ?? hasMoreWhenOmitted?.call(data),
      code: json['code'],
      data: data,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T?) dataToJson) {
    return {
      'message': message,
      'has_more': hasMore,
      'code': code,
      'data': dataToJson(data),
    };
  }

  @override
  List<Object?> get props => [message, code, data];
}
