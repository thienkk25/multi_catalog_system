import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/utils/formatter/file_size_formatter.dart';
import 'package:multi_catalog_system/core/widgets/custom_card.dart';
import 'package:multi_catalog_system/core/widgets/custom_circular_progress.dart';
import 'package:multi_catalog_system/core/widgets/file_icon.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/document_file_cubit.dart';
import 'package:multi_catalog_system/features/legal_document/presentation/bloc/document_file_state.dart';

class LegalDocumentImportFile extends StatelessWidget {
  const LegalDocumentImportFile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentFileCubit, DocumentFileState>(
      builder: (context, state) {
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 5,
                children: [
                  Icon(
                    Icons.attach_file_rounded,
                    size: 20,
                    color: const Color(0xFF2563EB),
                  ),
                  const Text(
                    'Tài liệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              if (state.error != null)
                Text(state.error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              state.file == null && state.remoteFileName == null
                  ? InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: state.isLoading
                          ? null
                          : () => context.read<DocumentFileCubit>().pickFile(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            state.isLoading
                                ? const CustomCircularProgressButton()
                                : Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 28,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            const Text(
                              'Chọn tệp để tải lên',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'PDF, DOC, DOCX (tối đa 10MB)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: .5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          FileIcon(
                            fileName: state.remoteFileName ?? state.file!.name,
                          ),

                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.remoteFileName ?? state.file!.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight(600),
                                    fontSize: 16,
                                  ),
                                ),
                                if (state.remoteFileName == null)
                                  Text(
                                    formatFileSize(state.file!.size),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<DocumentFileCubit>().clear();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
