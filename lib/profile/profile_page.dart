// 个人中心模块
// 展示用户信息卡片、订单快捷入口（待付款/待发货/收藏/设置）和常用服务列表。
// 点击各入口通过 onEntryTap 回调触发导航。
import 'package:flutter/material.dart';
import '../responsive.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onEntryTap, this.pendingDeliveryCount = 0, this.userName = '小鲸鱼'});
  final ValueChanged<String> onEntryTap;
  final int pendingDeliveryCount;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return respWrap(
      SafeArea(
        child: LayoutBuilder(builder: (_, c) {
          final w = c.maxWidth;
          final pad = contentPadding(w);

          return SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户信息卡片（头像 + 用户名 + 会员标签）
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFE85D75), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.person_rounded, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName, style: t.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('品牌会员 · 已连续签到 16 天', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 我的订单区域：四个快捷入口按钮
                Text('我的订单', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _entryBtn(context, Icons.receipt_long_rounded, '待付款', () => onEntryTap('待付款')),
                      _entryBtn(context, Icons.local_shipping_rounded, '待发货', () => onEntryTap('待发货'), badge: pendingDeliveryCount),
                      _entryBtn(context, Icons.favorite_border_rounded, '收藏', () => onEntryTap('收藏')),
                      _entryBtn(context, Icons.settings_rounded, '设置', () => onEntryTap('设置')),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 常用服务列表
                Text('常用服务', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Material(color: Colors.white, child: _serviceTile(context, Icons.location_on_outlined, '收货地址', () => onEntryTap('收货地址'))),
                      const Divider(height: 1, indent: 56),
                      Material(color: Colors.white, child: _serviceTile(context, Icons.local_offer_outlined, '优惠券', () => onEntryTap('优惠券'))),
                      const Divider(height: 1, indent: 56),
                      Material(color: Colors.white, child: _serviceTile(context, Icons.help_outline_rounded, '帮助中心', () => onEntryTap('帮助中心'))),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // 构建快捷入口按钮（图标 + 标签 + 可选数字角标）
  Widget _entryBtn(BuildContext c, IconData icon, String label, VoidCallback onTap, {int badge = 0}) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: const Color(0xFFE85D75), size: 20),
                ),
                if (badge > 0)
                  Positioned(
                    right: -4, top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: const BoxDecoration(color: Color(0xFFE85D75), shape: BoxShape.circle),
                      child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // 构建服务列表条目
  Widget _serviceTile(BuildContext c, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFFE85D75), size: 18),
      ),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
