class GetApplicationsParams {
  String? search;
  String? status;
  int? page;
  int? perPage;

  GetApplicationsParams({
    this.status,
    this.search,
    this.page = 1,
    this.perPage = 20,
  });

  Map<String, dynamic> toJson() => {
        "search": search,
        "status": status,
        "page": page,
        "perPage": perPage,
      };
}
