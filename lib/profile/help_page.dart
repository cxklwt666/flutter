// 帮助中心页面（FAQ常见问题页）
// 实现原理：
//   1. FAQ 列表使用 ExpansionPanel 的简化实现：通过 _expandedIndex 记录当前展开项的索引，
//      点击问题切换展开/收起状态（setState 驱动 UI 更新）
//   2. 展开时在问题下方显示答案文本，收起时隐藏，使用条件渲染 if (isExpanded)
//   3. Q 图标用 Container + 圆角 + 背景色模拟，不带图片资源，纯代码实现
import 'package:flutter/material.dart';
import '../responsive.dart';

// 帮助中心页：可展开的常见问题列表 + 联系方式
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int? _expandedIndex;

  // FAQ 问答对列表
  static const _faqs = [
    _FaqItem('如何下单？', '浏览商品页面，选择心仪的商品，点击"加入购物车"按钮。在购物车中确认商品数量和金额后，点击"去结算"完成下单。'),
    _FaqItem('如何付款？', '下单后进入"待付款"页面，选择需要付款的订单，点击"付款"按钮即可完成支付。目前支持模拟支付，无需输入真实支付信息。'),
    _FaqItem('如何查看订单状态？', '在"我的"页面点击"待发货"可以查看已付款的订单。订单状态包括：待付款、待发货、已发货、已完成等。'),
    _FaqItem('如何申请退款？', '在"待发货"订单列表中，点击对应商品的"退款"按钮即可申请退款。退款申请将立即生效。'),
    _FaqItem('如何收藏商品？', '在商品详情页点击页面顶部的爱心图标即可收藏商品。已收藏的商品可以在"我的"页面点击"收藏"查看。'),
    _FaqItem('如何联系客服？', '目前暂未开通在线客服功能。如有问题，请发送邮件至 support@example.com，我们会在 24 小时内回复您。'),
    _FaqItem('配送时效是多久？', '下单后一般 1-3 个工作日内发货，同城配送约 1-2 天送达，跨省配送约 3-5 天送达。具体以物流信息为准。'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助中心'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: respWrap(
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "常见问题"标题 + 可展开的 FAQ 列表
                Text('常见问题', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: List.generate(_faqs.length, (i) {
                      final isLast = i == _faqs.length - 1;
                      final isExpanded = _expandedIndex == i;
                      return Column(
                        children: [
                          // 每个问题行：Q图标 + 问题文字 + 展开/收起箭头
                          InkWell(
                            onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
                            borderRadius: BorderRadius.vertical(top: i == 0 ? const Radius.circular(12) : Radius.zero),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24, height: 24,
                                    decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(6)),
                                    child: const Center(child: Text('Q', style: TextStyle(color: Color(0xFFE85D75), fontWeight: FontWeight.w700, fontSize: 13))),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(_faqs[i].question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                                  Icon(
                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                    color: Colors.grey.shade500, size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 展开时显示答案
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(50, 0, 16, 14),
                              child: Text(_faqs[i].answer, style: TextStyle(color: Colors.grey.shade700, height: 1.6, fontSize: 13)),
                            ),
                          if (!isLast) const Divider(height: 1, indent: 50),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // "联系我们"区域：邮箱 + 工作时间
                Text('联系我们', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _contactRow(Icons.email_outlined, 'support@example.com'),
                      const SizedBox(height: 12),
                      _contactRow(Icons.access_time_rounded, '工作日 9:00 - 18:00'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建联系信息行（图标 + 文字）
  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFE85D75)),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// FAQ 问答数据模型
class _FaqItem {
  const _FaqItem(this.question, this.answer);
  final String question;
  final String answer;
}
