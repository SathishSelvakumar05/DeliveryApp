
class Message {
  final String text;
  final bool isUser;
  Message(this.text, this.isUser);
}
// enum PreferredTime { morning, afternoon, evening }
class PreferredTime{
 final String time;
 final String value;
 PreferredTime({required this.time,required this.value});
}

enum ChatMode { none, chatAI, freeTeleConsultation, clinicConsultation ,freeScalingConsultation}