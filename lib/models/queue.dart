class Queues {
  String? id;
  int? priority;
  String? appointmentId;
  int? timeStamp;
  int? delay;

  Queues(
      {this.id, this.appointmentId, this.timeStamp, this.priority, this.delay});

  factory Queues.fromJson(Map<String, dynamic> map) => Queues(
      id: map['id'] ?? '',
      appointmentId: map['appointmentid'] ?? '',
      priority: map['priority'] ?? 0,
      timeStamp: map['timestamp'] ?? 0,
      delay: map['delay'] ?? 0);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentid': appointmentId,
      'priority': priority,
      'timestamp': timeStamp,
      'delay': delay,
    };
  }
}
