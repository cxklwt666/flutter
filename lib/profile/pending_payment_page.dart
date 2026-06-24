// 待付款页面
// 显示等待支付的商品列表，支持单个付款、全部付款和取消订单。
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';

class PendingPaymentPage extends StatelessWidget {
  const PendingPaymentPage({
    super.key,
    required this.items,
    required this.onPay,
    required this.onPayAll,
    required this.onCancel,
  });
  final List<CartItemData> items;
  final ValueChanged<CartItemData> onPay;
  final VoidCallback onPayAll;
  final ValueChanged<CartItemData> onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待付款'),
        backgroundColor: Colors.white,
        // 全部付款按钮
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: onPayAll,
              child: const Text('全部付款', style: TextStyle(color: Color(0xFFE85D75), fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: SafeArea(
        // 空状态或直播列表
        child: items.isEmpty
            ? const Center(child: Text('暂无待付款订单', style: TextStyle(color: Colors.grey)))
            : respWrap(
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          // 商品图
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(color: item.product.color, borderRadius: BorderRadius.circular(12)),
                            child: item.product.imagePath.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      item.product.imagePath,
                                      width: 40, height: 40,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Icon(item.product.icon, size: 32, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          // 商品信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('x${item.quantity}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text('¥${item.product.price * item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFE85D75))),
                              ],
                            ),
                          ),
                          // 状态标签 + 操作按钮
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(999)),
                                child: const Text('待付款', style: TextStyle(color: Color(0xFFFF9800), fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () => onCancel(item),
                                    style: TextButton.styleFrom(foregroundColor: Colors.grey, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), minimumSize: Size.zero),
                                    child: const Text('取消', style: TextStyle(fontSize: 12)),
                                  ),
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: () => onPay(item),
                                    style: TextButton.styleFrom(foregroundColor: const Color(0xFFE85D75), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), minimumSize: Size.zero),
                                    child: const Text('付款', style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
