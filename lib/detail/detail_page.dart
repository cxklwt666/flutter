// 商品详情模块（商品信息完整展示页）
// 实现原理：
//   1. 页面结构为 SafeArea → Column([Expanded(可滚动内容), 底部固定按钮])
//      Expanded 撑满中间区域，底部按钮始终固定在屏幕最下方
//   2. 收藏状态由父组件的 isFavorite + onToggleFavorite 回调控制，
//      本页只负责展示（无状态 StatelessWidget），体现"状态提升"设计模式
//   3. 商品大图高度根据屏幕宽度动态计算（手机240px / 平板320px / 桌面400px）
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';

// 商品详情页：展示大图、标题、价格、说明、服务标签和底部加入购物车按钮
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.product, required this.onAddToCart, this.isFavorite = false, this.onToggleFavorite});
  final ProductData product;
  final VoidCallback onAddToCart;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (_, c) {
          final w = c.maxWidth;
          final pad = innerHPadding(w);
          final imgH = w < 600 ? 240.0 : (w < 900 ? 320.0 : 400.0);

          return respWrap(Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顶部工具栏：返回按钮 + 收藏按钮 + 分类标签
                      Row(
                        children: [
                          IconButton.filledTonal(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
                          if (onToggleFavorite != null)
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFavorite ? const Color(0xFFE85D75) : null,
                              ),
                              onPressed: onToggleFavorite,
                            ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(999)),
                            child: Text(product.category, style: const TextStyle(color: Color(0xFFE85D75), fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 商品大图（图片/图标双模式）
                      Container(
                        height: imgH, width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: product.imagePath.isNotEmpty
                            ? Center(child: Image.asset(
                                product.imagePath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ))
                            : Container(
                                decoration: BoxDecoration(color: product.color, borderRadius: BorderRadius.circular(16)),
                                child: Center(child: Icon(product.icon, size: w < 600 ? 100 : 140, color: Colors.white)),
                              ),
                      ),
                      const SizedBox(height: 16),
                      // 商品标题 + 角标标签（新品/人气等）
                      Row(
                        children: [
                          Expanded(child: Text(product.title, style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(999)),
                            child: Text(product.tag, style: const TextStyle(color: Color(0xFFE85D75), fontWeight: FontWeight.w600, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 价格 + 原价（划线） + 评分
                      Row(
                        children: [
                          Text('¥${product.price}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFE85D75))),
                          const SizedBox(width: 8),
                          Text('¥${product.originalPrice}', style: TextStyle(color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
                          const Spacer(),
                          const Icon(Icons.star, color: Color(0xFFFFB13D), size: 18),
                          const SizedBox(width: 4),
                          Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 商品说明区域
                      Text('商品说明', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.6)),
                      const SizedBox(height: 16),
                      // 服务标签：包邮、7天无理由、官方精选
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: ['包邮', '7 天无理由', '官方精选'].map((l) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.grey.shade300)),
                          child: Text(l, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // 底部固定加入购物车按钮
              Container(
                padding: EdgeInsets.fromLTRB(pad, 12, pad, 16),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF222244), padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: onAddToCart,
                  child: const Text('加入购物车'),
                ),
              ),
            ],
          ));
        }),
      ),
    );
  }
}
