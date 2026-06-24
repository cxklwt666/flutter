// 分类浏览模块（商品筛选与浏览页）
// 实现原理：
//   1. 分类标签使用 Material 3 的 ChoiceChip 组件，选中状态由父组件的 selectedCategory 驱动
//   2. 商品过滤逻辑在父组件中实现（_filteredProducts 计算属性），本页只接收过滤后的数据展示
//   3. 布局结构：Column([标题, Wrap(ChoiceChip列表), Expanded(GridView)])
//      标签行用 Wrap 实现自动换行，商品网格用 Expanded 撑满剩余空间
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';
import '../widgets/product_card.dart';

// 分类浏览页：顶部筛选标签 + 下方商品网格
class CategoryPage extends StatelessWidget {
  const CategoryPage({
    super.key,
    required this.categories, required this.selectedCategory, required this.products,
    required this.onCategorySelected, required this.onProductTap, required this.onAddToCart,
  });
  final List<String> categories;
  final String selectedCategory;
  final List<ProductData> products;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<ProductData> onProductTap;
  final ValueChanged<ProductData> onAddToCart;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return respWrap(
      SafeArea(
        child: LayoutBuilder(builder: (_, c) {
          final w = c.maxWidth;
          final pad = contentPadding(w);
          final cols = gridColumns(w);
          final ratio = gridRatio(w);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              Padding(
                padding: EdgeInsets.fromLTRB(pad, 16, pad, 10),
                child: Text('分类浏览', style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              // 分类筛选标签行：使用 ChoiceChip，选中状态高亮主题色
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: categories.map((c) {
                    final sel = c == selectedCategory;
                    return ChoiceChip(
                      label: Text(c),
                      selected: sel,
                      onSelected: (_) => onCategorySelected(c),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: BorderSide(color: sel ? const Color(0xFFE85D75) : const Color(0xFFDDDDDD)),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              // 商品网格：根据筛选结果动态展示
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('这个分类暂时没有商品', style: TextStyle(color: Colors.grey)))
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(pad, 0, pad, 20),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: ratio,
                        ),
                        itemBuilder: (_, i) => ProductCard(
                          product: products[i], onTap: () => onProductTap(products[i]), onAddToCart: () => onAddToCart(products[i]),
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
