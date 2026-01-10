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

class _CategoryLookupPageState extends State<CategoryLookupPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedDomainId;
  String? _selectedCategoryGroupId;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                          validator: (v) => v == null || v.isEmpty
                              ? 'Vui nhập chọn lĩnh vực'
                              : null,
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
                          validator: (v) => v == null || v.isEmpty
                              ? 'Vui nhập chọn nhóm danh mục'
                              : null,
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
                state.catalog.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const Text(
                            'Kết quả tìm kiếm',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.catalog.length,
                            itemBuilder: (context, index) {
                              final catalog = state.catalog[index];
                              return InforCardWidget(
                                subDomain: '',
                                title: '',
                                subGroup: '',
                                subDocument: '',
                                dateTime: DateTime.now(),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
