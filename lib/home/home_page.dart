// 首页模块（用户第一眼看到的页面）
// 实现原理：
//   1. 整体使用 CustomScrollView + SliverGrid 架构：固定内容放 SliverToBoxAdapter，商品网格放 SliverGrid
//   2. UI 数据全部由父组件通过构造函数传入（categories、products、cartCount），
//      用户操作通过 onCategoryTap、onCartTap 等回调函数传回父组件处理
//   3. 购物车角标用 Stack + Positioned 叠加在购物车图标右上角，数量为 0 时不显示
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';
import '../widgets/product_card.dart';

// 首页组件：展示问候语、促销Banner、分类入口和商品网格
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.categories, required this.products, required this.cartCount,
    required this.onCategoryTap, required this.onCartTap,
    required this.onProductTap, required this.onAddToCart,
    this.userName = '小鱼',
  });
  final List<CategoryData> categories;
  final List<ProductData> products;
  final int cartCount;
  final ValueChanged<String> onCategoryTap;
  final VoidCallback onCartTap;
  final ValueChanged<ProductData> onProductTap;
  final ValueChanged<ProductData> onAddToCart;
  final String userName;

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

          return CustomScrollView(
            slivers: [
              // 固定内容区域：顶部问候栏、Banner、分类入口、"猜你喜欢"标题
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, 12, pad, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部：用户名问候 + 购物车入口（带数量角标）
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hi, $userName', style: t.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                                const SizedBox(height: 2),
                                Text('发现今日潮流好物', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: onCartTap),
                              if (cartCount > 0)
                                Positioned(
                                  right: 4, top: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Color(0xFFE85D75), shape: BoxShape.circle),
                                    child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 促销 Banner：品牌色背景 + 促销文案 + 抢购按钮
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(w < 600 ? 16 : 24),
                        decoration: BoxDecoration(color: const Color(0xFFE85D75), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('618 品牌狂欢', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 8),
                                  Text('潮流焕新季\n全场满减进行中', style: t.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.2)),
                                  const SizedBox(height: 12),
                                  FilledButton(
                                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFE85D75)),
                                    onPressed: () {}, child: const Text('立即抢购'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: w < 600 ? 80 : 100, height: w < 600 ? 120 : 140,
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                              child: Icon(Icons.shopping_bag_rounded, size: w < 600 ? 44 : 56, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 分类入口：居中排列，自动换行，每个显示图标+文字
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: categories.map((c) {
                            return InkWell(
                              onTap: () => onCategoryTap(c.label),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: w < 600 ? 72 : 88,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: w < 600 ? 40 : 48, height: w < 600 ? 40 : 48,
                                      decoration: BoxDecoration(color: c.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                                      child: Icon(c.icon, color: c.color, size: w < 600 ? 22 : 26),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(c.label, style: TextStyle(fontSize: w < 600 ? 12 : 14, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // "猜你喜欢"标题
                      Text('猜你喜欢', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              // 商品网格列表：使用 SliverGrid 实现响应式多列布局
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 0, pad, 20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: ratio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => ProductCard(product: products[i], onTap: () => onProductTap(products[i]), onAddToCart: () => onAddToCart(products[i])),
                    childCount: products.length,
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
