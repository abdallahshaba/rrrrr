import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIAssistantController extends GetxController {
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    messages.add({
      'role': 'assistant',
      'content': 'مرحباً! أنا مساعدك الذكي للصحة النفسية. كيف يمكنني مساعدتك اليوم؟'
    });
  }

  Future<void> sendMessage(String message) async {
    messages.add({'role': 'user', 'content': message});
    isTyping.value = true;
    
    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));
    
    final response = _generateResponse(message);
    messages.add({'role': 'assistant', 'content': response});
    
    isTyping.value = false;
  }

  String _generateResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('i feel sad') || lowerMessage.contains('i feel sad')) {
      return 'أنا آسف لسماع ذلك. الحزن شعور طبيعي. هل تريد التحدث عما يجعلك تشعر بهذه الطريقة؟ يمكنني أيضاً أن أقترح عليك بعض تمارين اليقظة الذهنية.';
    }
    
    if (lowerMessage.contains('قلق') || lowerMessage.contains('خائف')) {
      return 'القلق شعور شائع. دعنا نجرب بعض تمارين التنفس العميق. يمكنك أيضاً استخدام مهارات تحمل الضيق من قسم مهارات DBT.';
    }
    
    if (lowerMessage.contains('شكرا')) {
      return 'العفو! أنا هنا دائماً لمساعدتك. لا تتردد في سؤالي عن أي شيء.';
    }
    
    return 'أنا هنا للاستماع إليك. هل يمكنك إخباري المزيد عن شعورك؟';
  }

  void clearChat() {
    messages.clear();
    messages.add({
      'role': 'assistant',
      'content': 'تم مسح المحادثة. كيف يمكنني مساعدتك؟'
    });
  }
}