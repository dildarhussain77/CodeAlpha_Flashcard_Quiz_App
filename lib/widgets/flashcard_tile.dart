import 'package:flashcard_quiz_app/providers/flashcard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_quiz_app/models/flashcard_model.dart';
import 'package:flashcard_quiz_app/screens/edit_flashcard_screen.dart';
import 'package:flashcard_quiz_app/widgets/mastery_indicator.dart';
import 'package:provider/provider.dart';

class FlashcardTile extends StatelessWidget {
  final Flashcard flashcard;

  const FlashcardTile({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(        
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Optional: Add tap functionality if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      flashcard.question,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditFlashcardScreen(
                              id: flashcard.id,
                              currentQuestion: flashcard.question,
                              currentAnswer: flashcard.answer,
                            ),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Flashcard'),
                            content: const Text(
                                'Are you sure you want to delete this flashcard?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          final provider = Provider.of<FlashcardProvider>(
                              context,
                              listen: false);
                          provider.deleteFlashcard(flashcard.id);
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                flashcard.answer,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: MasteryIndicator(masteryLevel: flashcard.masteryLevel),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(flashcard.masteryLevel * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviewed ${flashcard.timesReviewed} times',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'Created: ${_formatDate(flashcard.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}