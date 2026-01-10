class AdvisingMessage {
  final int? id;
  final String senderEmail;
  final String? receiverEmail;
  final String message;
  final bool isBroadcast;
  final bool isRead;
  final DateTime createdAt;

  AdvisingMessage({
    this.id,
    required this.senderEmail,
    this.receiverEmail,
    required this.message,
    this.isBroadcast = false,
    this.isRead = false,
    required this.createdAt,
  });

  factory AdvisingMessage.fromJson(Map<String, dynamic> json) {
    return AdvisingMessage(
      id: json['id'],
      senderEmail: json['sender_email'],
      receiverEmail: json['receiver_email'],
      message: json['message'],
      isBroadcast: json['is_broadcast'] == 1 || json['is_broadcast'] == true,
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_email': senderEmail,
      'receiver_email': receiverEmail,
      'message': message,
      'is_broadcast': isBroadcast,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
