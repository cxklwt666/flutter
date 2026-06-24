// 购物车模块
// 显示已加入的商品列表，支持增减数量、删除商品、实时合计金额、去结算。
// 商品图支持图片/图标双模式，结算后商品进入待付款列表。
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.items, required this.totalPrice,
    required this.onIncrease, required this.onDecrease, required this.onRemove, required this.onCheckout,
  });
  final List<CartItemData> items;
  final double totalPrice;
  final ValueChanged<ProductData> onIncrease;
  final ValueChanged<ProductData> onDecrease;
  final ValueChanged<ProductData> onRemove;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return respWrap(
      SafeArea(
        child: LayoutBuilder(builder: (_, c) {
          final w = c.maxWidth;
          final pad = innerHPadding(w);

          return Column(
            children: [
              // 顶部标题 + 合计金额
              Padding(
                padding: EdgeInsets.fromLTRB(pad, 16, pad, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('购物车', style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('已选 ${items.fold(0, (s, i) => s + i.quantity)} 件商品', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    Text('合计 ¥${totalPrice.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFE85D75))),
                  ],
                ),
              ),
              // 商品列表
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('购物车还是空的', style: TextStyle(color: Colors.grey)))
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(pad, 0, pad, 12),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final item = items[i];
                          final imgSize = w < 600 ? 72.0 : 88.0;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                // 商品图
                                Container(
                                  width: imgSize, height: imgSize,
                                  decoration: BoxDecoration(color: item.product.color, borderRadius: BorderRadius.circular(12)),
                                  child: item.product.imagePath.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            item.product.imagePath,
                                            width: imgSize * 0.65,
                                            height: imgSize * 0.65,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Icon(item.product.icon, size: imgSize / 2, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                // 商品信息 + 数量调节
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text(item.product.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text('¥${item.product.price}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFE85D75))),
                                          const Spacer(),
                                          QtyBtn(Icons.remove, () => onDecrease(item.product)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                          ),
                                          QtyBtn(Icons.add, () => onIncrease(item.product)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // 删除按钮
                                IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () => onRemove(item.product), color: Colors.grey),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              // 底部结算栏
              Container(
                padding: EdgeInsets.fromLTRB(pad, 12, pad, 16),
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('应付金额', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          Text('¥${totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFE85D75))),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF222244), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
                      onPressed: items.isEmpty ? null : onCheckout,
                      child: const Text('去结算'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class QtyBtn extends StatelessWidget {
  const QtyBtn(this.icon, this.onTap, {super.key});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
