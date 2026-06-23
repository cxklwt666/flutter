// 优惠券页面
// 展示可用优惠券列表，根据优惠券类型（满减/折扣/包邮）显示不同颜色。
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({super.key, required this.coupons});
  final List<CouponData> coupons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的优惠券'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: respWrap(
          coupons.isEmpty
              ? const Center(child: Text('暂无优惠券', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: coupons.length,
                  itemBuilder: (_, i) {
                    final c = coupons[i];
                    // 根据优惠券类型选择颜色
                    Color couponColor;
                    switch (c.type) {
                      case '折扣':
                        couponColor = const Color(0xFF7B61FF);
                        break;
                      case '包邮':
                        couponColor = const Color(0xFF27C498);
                        break;
                      default:
                        couponColor = const Color(0xFFE85D75);
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            // 左侧：折扣/优惠金额
                            Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: couponColor,
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(c.discount, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text(c.condition, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
                                ],
                              ),
                            ),
                            // 中间：优惠券信息
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(color: couponColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                                          child: Text(c.type, style: TextStyle(color: couponColor, fontSize: 11, fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                                        const SizedBox(width: 4),
                                        Text('有效期至 ${c.expiry}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // 右侧：已领取标签
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: couponColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text('已领取', style: TextStyle(color: couponColor, fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
