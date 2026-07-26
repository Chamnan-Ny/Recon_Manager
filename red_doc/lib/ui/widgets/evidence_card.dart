import 'package:flutter/material.dart';
import 'package:red_doc/theme/app_theme.dart';

class EvidenceCard extends StatelessWidget {
  final String imageUrl;
  final String note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const EvidenceCard({
    super.key,
    required this.imageUrl,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: imageUrl.isEmpty
                  ? const Icon(Icons.image, size: 40, color: Colors.grey)
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    ),
            ),
            // Note
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      note.isEmpty ? 'No note' : note,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Delete button
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.close, size: 16, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
