import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_catalog_system/core/core.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_bloc.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_event.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/bloc/catalog_lookup_state.dart';
import 'package:multi_catalog_system/features/catalog_lookup/presentation/widgets/infor_card_widget.dart';

class CategoryLookupPage extends StatefulWidget {
  const CategoryLookupPage({super.key});

  @override
  State<CategoryLookupPage> createState() => _CategoryLookupPageState();
}

class _CategoryLookupPageState extends State<CategoryLookupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedDomainId;
  String? _selectedCategoryGroupId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogLookupBloc>().add(
        const CatalogLookupEvent.getDomainsRef(),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogLookupBloc, CatalogLookupState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Form(
                  key: _formKey,
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        const Text(
                          'Bộ lọc tìm kiếm',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        CustomInput(
                          hintText: 'Nhập mã hoặc tên danh mục...',
                          lable: const Text(
                            'Tìm kiếm',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          suffixIcon: const Icon(Icons.search),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Vui lòng nhập dữ liệu cần tìm'
                              : null,
                        ),
                        CustomDropdownButton<String>(
                          lable: const Text(
                            'Lĩnh vực',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          hint: 'Chọn lĩnh vực',
                          value: _selectedDomainId,
                          items: state.domainsRef
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e.id,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _selectedDomainId = value;
                              _selectedCategoryGroupId = null;
                            });

                            context.read<CatalogLookupBloc>().add(
                              CatalogLookupEvent.getCategoryGroupsRef(
                                domainId: value,
                              ),
                            );
                          },
                        ),
                        CustomDropdownButton<String>(
                          lable: const Text(
                            'Nhóm danh mục',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          hint: 'Chọn nhóm danh mục',
                          value: _selectedCategoryGroupId,
                          items: state.categoryGroupRef
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e.id,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryGroupId = value;
                            });
                          },
                        ),
                        CustomButton(
                          colorBackground: Colors.blue,
                          onTap: () {
                            if (!_formKey.currentState!.validate()) return;

                            // context.read<CatalogLookupBloc>().add(
                            //       CatalogLookupEvent.searchCatalog(
                            //         domainId: _selectedDomainId,
                            //         categoryGroupId: _selectedCategoryGroupId,
                            //       ),
                            //     );
                          },
                          textButton: const Text(
                            'Tìm kiếm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Kết quả tìm kiếm',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
