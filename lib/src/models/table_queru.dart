class TableQueryModel {
  int? page;
  int pageSize;
  String? sortColumn;
  String filter;
  String sortDirection;
  bool getAll;

  TableQueryModel({
    this.page,
    this.pageSize = 100,
    this.sortColumn,
    this.filter = '',
    this.sortDirection = 'asc',
    this.getAll = true,
  });

  bool get getAllItems => getAll && page == null && pageSize == 0;

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'sortColumn': sortColumn,
      'filter': filter,
      'sortDirection': sortDirection,
      'getAll': getAll,
    };
  }
}
