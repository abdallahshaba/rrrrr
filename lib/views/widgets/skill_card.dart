import 'package:flutter/material.dart';
import '../../models/skill_model.dart';
import '../../utils/constants.dart';

class SkillCard extends StatelessWidget {
  final SkillModel skill;
  final VoidCallback onTap;

  const SkillCard({
    super.key,
    required this.skill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: Icon(
                      AppConstants.skillIcons[skill.category] ?? Icons.stars,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.title,
                          style: const TextStyle(
                            fontSize: AppConstants.fontLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          skill.category,
                          style: TextStyle(
                            fontSize: AppConstants.fontSmall,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                skill.description,
                style: TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildDifficultyChip(skill.difficulty),
                  const Spacer(),
                  Text(
                    '${skill.steps.length} خطوات',
                    style: TextStyle(
                      fontSize: AppConstants.fontSmall,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(int difficulty) {
    String text;
    Color color;
    
    switch (difficulty) {
      case 1:
        text = 'سهل';
        color = Colors.green;
        break;
      case 2:
        text = 'متوسط';
        color = Colors.orange;
        break;
      default:
        text = 'متقدم';
        color = Colors.red;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppConstants.fontSmall,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}