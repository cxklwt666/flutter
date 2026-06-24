// 可复用商品卡片组件（首页和分类页的网格项）
// 实现原理：
//   1. 用 Expanded(flex:5)+Padding(flex:3) 控制图片与信息区的比例（5:3）
//   2. 图片区使用三目运算：product.imagePath.isNotEmpty ? Image.asset : Icon，
//      有真实图片路径就覆盖显示，否则显示彩色背景+图标作为占位
//   3. 标签（新品/人气/热卖）用 Stack+Positioned 定位在图片区域左上角
import 'package:flutter/material.dart';
import '../models.dart';

// 商品卡片：显示缩略图、标题、分类、价格、评分和加入购物车按钮
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap, required this.onAddToCart});
  final ProductData product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品图片区域：有图片就显示真实图片，否则显示彩色背景+图标
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: product.color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                  child: Stack(
                    children: [
                      if (product.imagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            product.imagePath,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Center(child: Icon(product.icon, size: 44, color: Colors.white)),
                      // 商品标签（新品/人气/热卖）定位在左上角
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(999)),
                          child: Text(product.tag,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 商品信息区域：标题、分类、价格、评分、加入购物车按钮
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(product.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(child: Text('¥${product.price}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFE85D75), fontSize: 14))),
                        const Icon(Icons.star, size: 12, color: Color(0xFFFFB13D)),
                        const SizedBox(width: 2),
                        Text('${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF222244), padding: const EdgeInsets.symmetric(vertical: 8), minimumSize: const Size(0, 32)),
                        onPressed: onAddToCart,
                        child: const Text('加入购物车', style: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
