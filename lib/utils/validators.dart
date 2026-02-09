class Validators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صحيح';
    }
    
    return null;
  }
  
  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    
    return null;
  }
  
  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الاسم';
    }
    
    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    
    return null;
  }
  
  // Required Field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    return null;
  }
  
  // Phone Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'الرجاء إدخال رقم هاتف صحيح';
    }
    
    return null;
  }
}