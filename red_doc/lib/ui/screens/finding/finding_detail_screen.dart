// import 'package:flutter/material.dart';
// import 'package:red_doc/data/models/evidence_model.dart';
// import 'package:red_doc/data/models/finding_model.dart';
// import 'package:red_doc/theme/app_theme.dart';
// import 'package:red_doc/ui/widgets/evidence_card.dart';
// import 'package:red_doc/ui/widgets/empty_widget.dart';
// import 'package:red_doc/data/repositories/finding_repository.dart';
// import 'package:red_doc/data/repositories/storage_repository.dart';
// import 'package:red_doc/utils/constants.dart';

// class FindingDetailScreen extends StatefulWidget {
//   final String findingId;

//   const FindingDetailScreen({super.key, required this.findingId});

//   @override
//   State<FindingDetailScreen> createState() => _FindingDetailScreenState();
// }

// class _FindingDetailScreenState extends State<FindingDetailScreen> {
//   final FindingRepository _findingRepository = FindingRepository();
//   final StorageRepository _storageRepository = StorageRepository();
//   late Future<FindingModel?> _findingFuture;

//   @override
//   void initState() {
//     super.initState();
//     _findingFuture = _findingRepository.getFinding(widget.findingId);
//   }

//   String _getSeverityDisplay(Severity severity) {
//     if (severity == Severity.critical) {
//       return 'Critical';
//     } else if (severity == Severity.high) {
//       return 'High';
//     } else if (severity == Severity.medium) {
//       return 'Medium';
//     } else if (severity == Severity.low) {
//       return 'Low';
//     } else if (severity == Severity.informational) {
//       return 'Informational';
//     } else {
//       return '';
//     }
//   }

//   Color _getSeverityColor(Severity severity) {
//     if (severity == Severity.critical) {
//       return AppTheme.severityCritical;
//     } else if (severity == Severity.high) {
//       return AppTheme.severityHigh;
//     } else if (severity == Severity.medium) {
//       return AppTheme.severityMedium;
//     } else if (severity == Severity.low) {
//       return AppTheme.severityLow;
//     } else if (severity == Severity.informational) {
//       return AppTheme.severityInfo;
//     } else {
//       return AppTheme.textLight;
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day} ${_getMonth(date.month)} ${date.year}, ${_padNumber(date.hour)}:${_padNumber(date.minute)} ${date.hour >= 12 ? 'PM' : 'AM'}';
//   }

//   String _getMonth(int month) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return months[month - 1];
//   }

//   String _padNumber(int number) {
//     return number.toString().padLeft(2, '0');
//   }

//   void _showDeleteDialog(FindingModel finding) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Finding'),
//         content: const Text('Are you sure you want to delete this finding?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               try {
//                 await _findingRepository.deleteFinding(finding.findingId);
//                 if (!mounted) return;
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Finding deleted successfully!'),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Error: $e'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<FindingModel?>(
//       future: _findingFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   AppTheme.primaryColor,
//                 ),
//               ),
//             ),
//           );
//         }

//         if (snapshot.hasError || snapshot.data == null) {
//           return Scaffold(
//             appBar: AppBar(title: const Text('Finding Detail')),
//             body: Center(
//               child: Text('Error loading finding', style: AppTheme.bodyMedium),
//             ),
//           );
//         }

//         final finding = snapshot.data!;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(finding.title),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () {
//                   _showDeleteDialog(finding);
//                 },
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getSeverityColor(
//                           finding.severity,
//                         ).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         _getSeverityDisplay(finding.severity),
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: _getSeverityColor(finding.severity),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         finding.status,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Description', style: AppTheme.heading3),
//                         const SizedBox(height: 8),
//                         Text(finding.description, style: AppTheme.bodyMedium),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 if (finding.recommendation.isNotEmpty)
//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Recommendation', style: AppTheme.heading3),
//                           const SizedBox(height: 8),
//                           Text(
//                             finding.recommendation,
//                             style: AppTheme.bodyMedium,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [Text('Evidence', style: AppTheme.heading3)],
//                 ),
//                 const SizedBox(height: 8),
//                 StreamBuilder<List<EvidenceModel>>(
//                   stream: _storageRepository.getEvidenceByFinding(
//                     widget.findingId,
//                   ),
//                   builder: (context, evidenceSnapshot) {
//                     if (evidenceSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const SizedBox(
//                         height: 120,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               AppTheme.primaryColor,
//                             ),
//                           ),
//                         ),
//                       );
//                     }

//                     final evidenceList = evidenceSnapshot.data ?? [];

//                     if (evidenceList.isEmpty) {
//                       return const EmptyWidget(
//                         message: 'No evidence uploaded yet.',
//                       );
//                     }

//                     return SizedBox(
//                       height: 120,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: evidenceList.length,
//                         itemBuilder: (context, index) {
//                           final evidence = evidenceList[index];
//                           return EvidenceCard(
//                             imageUrl: evidence.imageUrl,
//                             note: evidence.note,
//                             onTap: () {
//                               // View full image
//                             },
//                             onDelete: () async {
//                               try {
//                                 await _storageRepository.deleteEvidence(
//                                   evidence.evidenceId,
//                                   evidence.imageUrl,
//                                 );
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Evidence deleted successfully!',
//                                     ),
//                                     backgroundColor: Colors.green,
//                                   ),
//                                 );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text('Error: $e'),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                             },
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildInfoRow('Status', finding.status),
//                         _buildInfoRow(
//                           'Created',
//                           _formatDate(finding.createdAt),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(width: 80, child: Text(label, style: AppTheme.bodyMedium)),
//           Expanded(child: Text(value, style: AppTheme.bodyLarge)),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:red_doc/data/models/evidence_model.dart';
import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/theme/app_theme.dart';
import 'package:red_doc/ui/widgets/evidence_card.dart';
import 'package:red_doc/ui/widgets/empty_widget.dart';
import 'package:red_doc/data/repositories/finding_repository.dart';
import 'package:red_doc/data/repositories/storage_repository.dart';
import 'package:red_doc/services/image_picker_service.dart';
import 'package:red_doc/utils/constants.dart';

class FindingDetailScreen extends StatefulWidget {
  final String findingId;

  const FindingDetailScreen({super.key, required this.findingId});

  @override
  State<FindingDetailScreen> createState() => _FindingDetailScreenState();
}

class _FindingDetailScreenState extends State<FindingDetailScreen> {
  final FindingRepository _findingRepository = FindingRepository();
  final StorageRepository _storageRepository = StorageRepository();
  final ImagePickerService _imagePickerService = ImagePickerService();
  late Future<FindingModel?> _findingFuture;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _findingFuture = _findingRepository.getFinding(widget.findingId);
  }

  String _getSeverityDisplay(Severity severity) {
    if (severity == Severity.critical) {
      return 'Critical';
    } else if (severity == Severity.high) {
      return 'High';
    } else if (severity == Severity.medium) {
      return 'Medium';
    } else if (severity == Severity.low) {
      return 'Low';
    } else if (severity == Severity.informational) {
      return 'Informational';
    } else {
      return '';
    }
  }

  Color _getSeverityColor(Severity severity) {
    if (severity == Severity.critical) {
      return AppTheme.severityCritical;
    } else if (severity == Severity.high) {
      return AppTheme.severityHigh;
    } else if (severity == Severity.medium) {
      return AppTheme.severityMedium;
    } else if (severity == Severity.low) {
      return AppTheme.severityLow;
    } else if (severity == Severity.informational) {
      return AppTheme.severityInfo;
    } else {
      return AppTheme.textLight;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}, ${_padNumber(date.hour)}:${_padNumber(date.minute)} ${date.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _padNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  // Shows a small sheet letting the user choose Camera or Gallery.
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Picks an image, uploads it through StorageRepository, and shows
  // a loading state while the upload is in progress.
  //
  // Reads the picked image as bytes (readAsBytes) instead of using
  // File(pickedFile.path) - dart:io File doesn't work on Flutter Web,
  // but reading bytes works the same way on web, mobile, and desktop.
  // This is what makes "Add" work when demoing in Chrome.
  void _pickImage(ImageSource source) async {
    try {
      final Uint8List? rawBytes = source == ImageSource.camera
          ? await _imagePickerService.captureImageFromCamera()
          : await _imagePickerService.pickImageFromGallery();

      if (rawBytes == null) {
        return;
      }

      if (!mounted) return;
      final String? note = await _promptForNote();
      if (note == null) {
        // User tapped Cancel on the note dialog - abort the upload.
        return;
      }

      setState(() {
        _isUploading = true;
      });

      final Uint8List imageBytes = _compressImage(rawBytes);

      await _storageRepository.uploadEvidence(
        imageBytes: imageBytes,
        findingId: widget.findingId,
        note: note,
      );

      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evidence uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading evidence: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Shows a small dialog asking for an optional note describing the
  // evidence (e.g. "Burp Suite request showing SQLi payload").
  // Returns the note text if the user taps Upload (may be empty string),
  // or null if the user cancels - null is used as the signal to abort
  // the whole upload.
  Future<String?> _promptForNote() async {
    final TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Evidence Note'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'e.g. Burp Suite request showing SQLi payload',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  // Resizes the image down to a max of 1024px on the longest side and
  // re-encodes it as a JPEG at 70% quality.
  //
  // This is done manually because image_picker's own maxWidth/maxHeight/
  // imageQuality options are unreliable on Flutter Web - a photo picked
  // in Chrome often comes through at full original size (several MB),
  // which is what makes the upload feel slow. Resizing here guarantees
  // a small file regardless of platform.
  Uint8List _compressImage(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      // If decoding fails for some reason, fall back to the original
      // bytes rather than crashing the upload.
      return bytes;
    }

    final bool isWiderThanTall = decoded.width >= decoded.height;
    final resized = img.copyResize(
      decoded,
      width: isWiderThanTall ? 1024 : null,
      height: isWiderThanTall ? null : 1024,
    );

    return Uint8List.fromList(img.encodeJpg(resized, quality: 70));
  }

  void _showDeleteDialog(FindingModel finding) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Finding'),
        content: const Text('Are you sure you want to delete this finding?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _findingRepository.deleteFinding(finding.findingId);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Finding deleted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFullImage(String imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(base64Decode(imageData)),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FindingModel?>(
      future: _findingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Finding Detail')),
            body: Center(
              child: Text('Error loading finding', style: AppTheme.bodyMedium),
            ),
          );
        }

        final finding = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(finding.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(finding);
                },
              ),
            ],
          ),
          // Wrapped in a Stack so a loading overlay can sit on top
          // while an evidence upload is in progress.
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(
                              finding.severity,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getSeverityDisplay(finding.severity),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _getSeverityColor(finding.severity),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            finding.status,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description', style: AppTheme.heading3),
                              const SizedBox(height: 8),
                              Text(
                                finding.description,
                                style: AppTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (finding.recommendation.isNotEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommendation',
                                  style: AppTheme.heading3,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  finding.recommendation,
                                  style: AppTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Evidence header, now with the Add button.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Evidence', style: AppTheme.heading3),
                        ElevatedButton.icon(
                          onPressed: _isUploading
                              ? null
                              : _showImagePickerOptions,
                          icon: _isUploading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.add, size: 18),
                          label: Text(_isUploading ? 'Uploading...' : 'Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            // This button sits in a Row, so it must not
                            // inherit the app-wide infinite minimumSize
                            // that AppTheme sets for full-width buttons.
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<List<EvidenceModel>>(
                      stream: _storageRepository.getEvidenceByFinding(
                        widget.findingId,
                      ),
                      builder: (context, evidenceSnapshot) {
                        if (evidenceSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          );
                        }

                        if (evidenceSnapshot.hasError) {
                          // Printed so the real Firestore error (e.g. a
                          // missing composite index) shows up in the
                          // debug console instead of being swallowed.
                          debugPrint(
                            'getEvidenceByFinding error: ${evidenceSnapshot.error}',
                          );
                          return SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(
                                'Error loading evidence:\n${evidenceSnapshot.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }

                        final evidenceList = evidenceSnapshot.data ?? [];

                        if (evidenceList.isEmpty) {
                          return const EmptyWidget(
                            message: 'No evidence uploaded yet.',
                          );
                        }

                        return SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: evidenceList.length,
                            itemBuilder: (context, index) {
                              final evidence = evidenceList[index];
                              return EvidenceCard(
                                imageData: evidence.imageData,
                                note: evidence.note,
                                onTap: () {
                                  _showFullImage(evidence.imageData);
                                },
                                onDelete: () async {
                                  try {
                                    await _storageRepository.deleteEvidence(
                                      evidence.evidenceId,
                                    );
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Evidence deleted successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Status', finding.status),
                            _buildInfoRow(
                              'Created',
                              _formatDate(finding.createdAt),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isUploading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: AppTheme.bodyMedium)),
          Expanded(child: Text(value, style: AppTheme.bodyLarge)),
        ],
      ),
    );
  }
}
