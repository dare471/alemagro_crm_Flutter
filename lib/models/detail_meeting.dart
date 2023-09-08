class DetailMeeting {
  final Data data;

  DetailMeeting({required this.data});

  factory DetailMeeting.fromJson(Map<String, dynamic> json) {
    return DetailMeeting(
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final int visitId;
  final int clientId;
  final String clientName;
  final String clientCategory;
  final String address;
  final List<dynamic> contactInf;
  final int clientIin;
  final int managerId;
  final String? managerName;
  final String? startVisit;
  final String? finishVisit;
  final bool statusVisit;
  final int visitTypeId;
  final String vistiTypeName;
  final int meetingTypeId;
  final String? meetingTypeName;
  final String meetingCoordinate;
  final int plotId;
  final String? plotName;
  final String summContract;
  final String summCurrentContractSeason;
  final bool checkContracts;
  final String potentialClientPercent;
  final String potentialClient;
  final String subscidesSum;
  final bool checkSubscides;
  final String duration;
  final String distance;

  Data({
    required this.visitId,
    required this.clientId,
    required this.clientName,
    required this.clientCategory,
    required this.address,
    required this.contactInf,
    required this.clientIin,
    required this.managerId,
    this.managerName,
    this.startVisit,
    this.finishVisit,
    required this.statusVisit,
    required this.visitTypeId,
    required this.vistiTypeName,
    required this.meetingTypeId,
    this.meetingTypeName,
    required this.meetingCoordinate,
    required this.plotId,
    this.plotName,
    required this.summContract,
    required this.summCurrentContractSeason,
    required this.checkContracts,
    required this.potentialClientPercent,
    required this.potentialClient,
    required this.subscidesSum,
    required this.checkSubscides,
    required this.duration,
    required this.distance,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      visitId: json['visitId'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientCategory: json['clientCategory'],
      address: json['address'],
      contactInf: json['contactInf'],
      clientIin: json['clientIin'],
      managerId: json['managerId'],
      managerName: json['managerName'],
      startVisit: json['startVisit'],
      finishVisit: json['finishVisit'],
      statusVisit: json['statusVisit'],
      visitTypeId: json['visitTypeId'],
      vistiTypeName: json['vistiTypeName'],
      meetingTypeId: json['meetingTypeId'],
      meetingTypeName: json['meetingTypeName'],
      meetingCoordinate: json['meetingCoordinate'],
      plotId: json['plotId'],
      plotName: json['plotName'],
      summContract: json['summContract'],
      summCurrentContractSeason: json['summCurrentContractSeason'],
      checkContracts: json['checkContracts'],
      potentialClientPercent: json['potentialClientPercent'],
      potentialClient: json['potentialClient'],
      subscidesSum: json['subscidesSum'],
      checkSubscides: json['checkSubscides'],
      duration: json['duration'],
      distance: json['distance'],
    );
  }
}
