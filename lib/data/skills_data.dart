import '../models/skill_model.dart';

class SkillsData {
  static List<SkillModel> getAllSkills() {
    return [
      // Mindfulness Skills
      SkillModel(
        id: 1,
        title: 'التنفس الواعي',
        description: 'تمرين بسيط للتركيز على التنفس',
        category: 'اليقظة الذهنية',
        content: 'التنفس الواعي هو أساس اليقظة الذهنية. من خلال التركيز على أنفاسك، يمكنك تهدئة عقلك والبقاء في اللحظة الحالية.',
        steps: [
          'اجلس في وضع مريح',
          'أغلق عينيك أو اخفض نظرك',
          'ركز على أنفاسك',
          'لاحظ الشهيق والزفير',
          'إذا تشتت ذهنك، أعده بلطف للتنفس',
        ],
        difficulty: 1,
      ),
      
      SkillModel(
        id: 2,
        title: 'المسح الذهني للجسم',
        description: 'الوعي بأحاسيس الجسم المختلفة',
        category: 'اليقظة الذهنية',
        content: 'تقنية تساعدك على الوعي بجسدك وتخفيف التوتر.',
        steps: [
          'استلقِ أو اجلس بشكل مريح',
          'ابدأ من أصابع قدميك',
          'لاحظ أي أحاسيس',
          'انتقل ببطء إلى أعلى الجسم',
          'استرخِ كل منطقة تمر بها',
        ],
        difficulty: 2,
      ),
      
      SkillModel(
        id: 3,
        title: 'الأكل الواعي',
        description: 'تناول الطعام بوعي كامل',
        category: 'اليقظة الذهنية',
        content: 'استخدام جميع الحواس أثناء تناول الطعام.',
        steps: [
          'اختر قطعة طعام صغيرة',
          'انظر إليها بعناية',
          'اشممها',
          'ضعها في فمك ببطء',
          'لاحظ الطعم والقوام',
          'امضغ ببطء وبوعي',
        ],
        difficulty: 1,
      ),
      
      // Distress Tolerance Skills
      SkillModel(
        id: 4,
        title: 'مهارة TIPP',
        description: 'تقنيات سريعة لإدارة الأزمات',
        category: 'تحمل الضيق',
        content: 'TIPP = درجة الحرارة، التمرين المكثف، التنفس المتناسب، استرخاء العضلات',
        steps: [
          'T - درجة الحرارة: ضع وجهك في ماء بارد',
          'I - التمرين المكثف: قم بتمرين قوي لمدة دقيقة',
          'P - التنفس المتناسق: تنفس بعمق وانتظام',
          'P - استرخاء العضلات: شد ثم استرخِ عضلاتك',
        ],
        difficulty: 2,
      ),
      
      SkillModel(
        id: 5,
        title: 'تقنية 5-4-3-2-1',
        description: 'تمرين التأريض باستخدام الحواس',
        category: 'تحمل الضيق',
        content: 'تقنية فعالة لإعادتك إلى اللحظة الحالية.',
        steps: [
          '5 أشياء يمكنك رؤيتها',
          '4 أشياء يمكنك لمسها',
          '3 أشياء يمكنك سماعها',
          'شيئان يمكنك شمهما',
          'شيء واحد يمكنك تذوقه',
        ],
        difficulty: 1,
      ),
      
      SkillModel(
        id: 6,
        title: 'ACCEPTS',
        description: 'إلهاء صحي عن الألم',
        category: 'تحمل الضيق',
        content: 'طرق للتعامل مع الضيق من خلال الإلهاء الصحي.',
        steps: [
          'A - الأنشطة (Activities)',
          'C - المساهمة (Contributing)',
          'C - المقارنات (Comparisons)',
          'E - العواطف المعاكسة (Emotions)',
          'P - الدفع بعيداً (Pushing away)',
          'T - الأفكار (Thoughts)',
          'S - الأحاسيس (Sensations)',
        ],
        difficulty: 2,
      ),
      
      // Emotion Regulation Skills
      SkillModel(
        id: 7,
        title: 'ABC PLEASE',
        description: 'بناء المرونة العاطفية',
        category: 'تنظيم العواطف',
        content: 'استراتيجية لتقليل الضعف أمام العواطف السلبية.',
        steps: [
          'تراكم الخبرات الإيجابية',
          'بناء الإتقان',
          'التخطيط المسبق للتعامل مع المشاكل',
          'P - العلاج الجسدي (Physical illness)',
          'L - الأكل المتوازن (baLanced eating)',
          'E - تجنب المخدرات (avoid mood-altering substances)',
          'A - النوم الكافي (sleep)',
          'S - التمارين (Exercise)',
        ],
        difficulty: 3,
      ),
      
      SkillModel(
        id: 8,
        title: 'الفعل المعاكس',
        description: 'التصرف عكس الرغبة العاطفية',
        category: 'تنظيم العواطف',
        content: 'عندما لا تكون عاطفتك مناسبة للموقف، افعل العكس.',
        steps: [
          'حدد العاطفة الحالية',
          'تحقق مما إذا كانت مناسبة',
          'إذا لم تكن مناسبة، افعل العكس',
          'مثال: إذا كنت تشعر بالخوف بدون سبب، واجه ما تخافه',
        ],
        difficulty: 2,
      ),
      
      SkillModel(
        id: 9,
        title: 'وصف العواطف',
        description: 'التعرف على المشاعر وتسميتها',
        category: 'تنظيم العواطف',
        content: 'فهم عواطفك هو الخطوة الأولى لإدارتها.',
        steps: [
          'لاحظ الحدث الذي أثار العاطفة',
          'حدد تفسيرك للحدث',
          'سمِ العاطفة',
          'لاحظ تعابير وجهك',
          'لاحظ أحاسيس جسمك',
          'لاحظ رغبات الفعل',
        ],
        difficulty: 2,
      ),
      
      // Interpersonal Effectiveness Skills
      SkillModel(
        id: 10,
        title: 'DEAR MAN',
        description: 'طلب ما تريد بفعالية',
        category: 'الفعالية الشخصية',
        content: 'مهارة للحصول على ما تريد مع الحفاظ على العلاقات.',
        steps: [
          'D - صِف (Describe) الموقف',
          'E - عبّر (Express) عن مشاعرك',
          'A - اطلب (Assert) ما تريد',
          'R - عزز (Reinforce) الشخص الآخر',
          'M - كن يقظاً (Mindful)',
          'A - اظهر بثقة (Appear confident)',
          'N - تفاوض (Negotiate)',
        ],
        difficulty: 3,
      ),
      
      SkillModel(
        id: 11,
        title: 'GIVE',
        description: 'الحفاظ على العلاقات',
        category: 'الفعالية الشخصية',
        content: 'مهارات لبناء والحفاظ على علاقات صحية.',
        steps: [
          'G - كن لطيفاً (be Gentle)',
          'I - أظهر اهتماماً (act Interested)',
          'V - تحقق من صحة (Validate) مشاعر الآخرين',
          'E - استخدم أسلوباً سهلاً (Easy manner)',
        ],
        difficulty: 2,
      ),
      
      SkillModel(
        id: 12,
        title: 'FAST',
        description: 'احترام الذات في العلاقات',
        category: 'الفعالية الشخصية',
        content: 'الحفاظ على احترام الذات أثناء التفاعل مع الآخرين.',
        steps: [
          'F - كن عادلاً (be Fair)',
          'A - لا تعتذر كثيراً (no unnecessary Apologies)',
          'S - التزم بقيمك (Stick to values)',
          'T - كن صادقاً (be Truthful)',
        ],
        difficulty: 2,
      ),
    ];
  }
}