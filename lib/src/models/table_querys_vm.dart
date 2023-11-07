class MetersQuery {
  String filter;
  bool getAll;
  bool includeChart;
  String meterId;
  int page;
  int pageSize;
  String sortColumn;
  String sortDirection;
  int year;

  MetersQuery({
    String filter = '',
    bool getAll = false,
    this.includeChart = false,
    this.meterId = '00000000-0000-0000-0000-000000000000',
    int page = 1,
    int pageSize = 10,
    String sortColumn = 'title',
    String sortDirection = 'asc',
    int? year,
  })  : filter = filter,
        getAll = getAll,
        page = page,
        pageSize = pageSize,
        sortColumn = sortColumn,
        sortDirection = sortDirection,
        year = year ?? DateTime.now().year;

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'getAll': getAll,
      'includeChart': includeChart,
      'meterId': meterId,
      'page': page,
      'pageSize': pageSize,
      'sortColumn': sortColumn,
      'sortDirection': sortDirection,
      'year': year,
    };
  }
}

class RateQueryModel {
  int? page;
  int pageSize;
  String? sortColumn;
  String filter;
  String sortDirection;
  bool getAll;
  String LeaseholdId;
  String HouseId;
  RateQueryModel({
    this.page = 0,
    this.pageSize = 20,
    this.sortColumn = 'title',
    this.filter = '',
    this.sortDirection = 'asc',
    this.getAll = true,
    this.LeaseholdId = '',
    this.HouseId = '00000000-0000-0000-0000-000000000000',
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
      'LeaseholdId': LeaseholdId,
      'HouseId': HouseId,
    };
  }
}

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
