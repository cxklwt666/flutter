// 待发货订单页面
// 显示已付款的待发货商品列表，支持手动退款。
import 'package:flutter/material.dart';
import '../models.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.orders, required this.onRefund});
  final List<CartItemData> orders;
  final ValueChanged<CartItemData> onRefund;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<CartItemData> _items;

  @override
  void initState() {
    super.initState();
    // 复制订单数据到本地可变列表
    _items = List.from(widget.orders);
  }

  // 处理退款：调用外部回调 + 从本地列表移除 + 列表为空时返回上一页
  void _handleRefund(CartItemData item) {
    widget.onRefund(item);
    setState(() => _items.remove(item));
    if (_items.isEmpty && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('待发货'), backgroundColor: Colors.white),
      body: SafeArea(
        child: _items.isEmpty
            ? const Center(child: Text('暂无订单'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  final item = _items[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        // 左侧：商品缩略图
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
                        // 中间：商品信息（标题、数量、总价）
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
                        // 右侧：状态标签 + 退款按钮
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(999)),
                              child: const Text('待发货', style: TextStyle(color: Color(0xFFE85D75), fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 6),
                            TextButton(
                              onPressed: () => _handleRefund(item),
                              style: TextButton.styleFrom(foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), minimumSize: Size.zero),
                              child: const Text('退款', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
