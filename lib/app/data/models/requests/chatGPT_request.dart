class ChatGPTRequest {
  final String inputString;
  final int condition;
  const ChatGPTRequest({required this.inputString, required this.condition});

  Map<String, dynamic> toJson() {
    return {
      "inputString": inputString,
      "condition": condition,
    };
  }
}
