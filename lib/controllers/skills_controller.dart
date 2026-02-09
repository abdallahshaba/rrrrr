import 'package:get/get.dart';
import '../models/skill_model.dart';
import '../data/skills_data.dart';

class SkillsController extends GetxController {
  final RxList<SkillModel> allSkills = <SkillModel>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSkills();
  }

  Future<void> loadSkills() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    allSkills.value = SkillsData.getAllSkills();
    isLoading.value = false;
  }

  List<SkillModel> getSkillsByCategory(String category) {
    if (category.isEmpty) return allSkills;
    return allSkills.where((skill) => skill.category == category).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  List<SkillModel> get filteredSkills {
    if (selectedCategory.value.isEmpty) return allSkills;
    return getSkillsByCategory(selectedCategory.value);
  }
}