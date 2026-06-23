// 设置页面（用户信息编辑页）
// 实现原理：
//   1. 使用 TextEditingController 绑定输入框初始值，用户修改后通过 onSave 回调传回父组件
//   2. 通知偏好使用 SwitchListTile 组件，true/false 状态由本地 _notifyOrder / _notifyPromo 管理
//   3. 保存时调用 widget.onSave 回调 → 父组件 setState 更新 ProfileState
//   4. 输入框、开关、只读信息分别用 _buildTextField / _buildSwitchTile / _buildInfoTile 封装复用
import 'package:flutter/material.dart';
import '../responsive.dart';

// 设置页面：修改昵称、手机号和通知偏好
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.notifyOrder,
    required this.notifyPromo,
    required this.onSave,
  });
  final String userName;
  final String userPhone;
  final bool notifyOrder;
  final bool notifyPromo;
  final void Function(String name, String phone, bool notifyOrder, bool notifyPromo) onSave;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late bool _notifyOrder;
  late bool _notifyPromo;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _phoneController = TextEditingController(text: widget.userPhone);
    _notifyOrder = widget.notifyOrder;
    _notifyPromo = widget.notifyPromo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: respWrap(
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 个人信息设置：昵称 + 手机号输入框
                Text('个人信息', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _buildTextField('昵称', _nameController, Icons.person_outline),
                      const SizedBox(height: 12),
                      _buildTextField('手机号', _phoneController, Icons.phone_outlined),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 通知设置：订单通知 + 促销通知（开关）
                Text('通知设置', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _buildSwitchTile('订单通知', '接收订单状态变更通知', _notifyOrder, (v) => setState(() => _notifyOrder = v)),
                      const Divider(height: 1, indent: 16),
                      _buildSwitchTile('促销通知', '接收优惠促销推送', _notifyPromo, (v) => setState(() => _notifyPromo = v)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 应用信息：版本号 + 开发团队（只读）
                Text('应用信息', style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _buildInfoTile('版本号', 'v1.0.0'),
                      const Divider(height: 1, indent: 16),
                      _buildInfoTile('开发团队', 'Flutter Demo Team'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 保存按钮：保存设置并返回
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF222244), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () => _save(context),
                    child: const Text('保存设置'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 保存设置并返回上一页
  void _save(BuildContext context) {
    widget.onSave(_nameController.text, _phoneController.text, _notifyOrder, _notifyPromo);
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('设置已保存')));
    Navigator.of(context).pop();
  }

  // 构建带图标的输入框
  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  // 构建开关设置项（标题 + 副标题 + Switch）
  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFFE85D75),
    );
  }

  // 构建只读信息项（标签 + 值）
  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: Text(value, style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
