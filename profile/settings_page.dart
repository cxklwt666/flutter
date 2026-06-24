// 设置页面
// 允许用户修改昵称、手机号和通知偏好设置，修改后保存至 ProfileState。
import 'package:flutter/material.dart';
import '../responsive.dart';

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
    // 初始化表单数据
    _nameController = TextEditingController(text: widget.userName);
    _phoneController = TextEditingController(text: widget.userPhone);
    _notifyOrder = widget.notifyOrder;
    _notifyPromo = widget.notifyPromo;
  }

  @override
  void dispose() {
    // 释放控制器
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
                // 个人信息设置
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
                // 通知设置
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
                // 应用信息
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
                // 保存按钮
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

  // 保存设置并返回
  void _save(BuildContext context) {
    widget.onSave(_nameController.text, _phoneController.text, _notifyOrder, _notifyPromo);
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('设置已保存')));
    Navigator.of(context).pop();
  }

  // 构建输入框
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

  // 构建开关设置项
  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFFE85D75),
    );
  }

  // 构建只读信息项
  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 15)),
      trailing: Text(value, style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
