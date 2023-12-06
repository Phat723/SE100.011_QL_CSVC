
class InOutLog {
  final String inOutId;
  final String? creatorName;
  final String createDay;
  final String createType;
  final String createCase;

  const InOutLog(this.inOutId, this.creatorName, this.createDay, this.createType, this.createCase);

  Map<String, dynamic> toMap(){
    return {
      "In_Out Id": inOutId,
      "Creator's Name": creatorName,
      "Created Day": createDay,
      "Type": createType,
      "Create Case": createCase,
    };
  }
}