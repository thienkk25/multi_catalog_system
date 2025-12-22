import 'package:flutter/material.dart';
import 'package:multi_catalog_system/core/core.dart';

class CategoryGroupFormPage extends StatefulWidget {
  const CategoryGroupFormPage({super.key});

  @override
  State<CategoryGroupFormPage> createState() => _CategoryGroupFormPageState();
}

class _CategoryGroupFormPageState extends State<CategoryGroupFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _bottomBarKey = GlobalKey();
  double _bottomBarHeight = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _bottomBarKey.currentContext;
      if (context != null) {
        final height = context.size?.height ?? 0;
        if (height != _bottomBarHeight) {
          setState(() => _bottomBarHeight = height);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Thêm nhóm danh mục'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 20,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomCard(
                              child: Column(
                                spacing: 20,
                                children: [
                                  CustomInput(
                                    lable: _requiredLabel('Mã Nhóm danh mục'),
                                    hintText: 'Nhập mã nhóm danh mục',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập mã nhóm danh mục'
                                        : null,
                                  ),
                                  CustomInput(
                                    lable: _requiredLabel('Tên Nhóm danh mục'),
                                    hintText: 'Nhập tên nhóm danh mục',
                                    validator: (p0) => p0 == null || p0.isEmpty
                                        ? 'Vui lòng nhập tên nhóm danh mục'
                                        : null,
                                  ),
                                  CustomDropdownButton(
                                    lable: _requiredLabel('Lĩnh vực'),
                                    hint: '-- Chọn lĩnh vực --',
                                    items: const [
                                      DropdownMenuItem(
                                        value: '1',
                                        child: Text('Lĩnh vực 1'),
                                      ),
                                      DropdownMenuItem(
                                        value: '2',
                                        child: Text('Lĩnh vực 2'),
                                      ),
                                      DropdownMenuItem(
                                        value: '3',
                                        child: Text('Lĩnh vực 3'),
                                      ),
                                    ],
                                    onChanged: (value) {},
                                    validator: (p0) => p0 == null
                                        ? 'Vui lòng chọn lĩnh vực'
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            CustomCard(
                              child: CustomInput(
                                lable: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Mô tả chi tiết',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Tùy chọn',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                hintText:
                                    'Nhập mô tả chi tiết về nhóm danh mục này...',
                                minLines: 5,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.only(bottom: _bottomBarHeight),
                ),
              ],
            ),

            BottomFormActions(
              key: _bottomBarKey,
              onCancel: () => Navigator.pop(context),
              onSave: () {
                if (!_formKey.currentState!.validate()) return;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$text ',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
