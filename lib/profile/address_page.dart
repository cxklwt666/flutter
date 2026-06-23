// 收货地址页面（地址管理CRUD页）
// 实现原理：
//   1. 设为默认：遍历地址列表，用 copyWith 只将目标索引 isDefault 设为 true，其余设为 false
//   2. 删除带撤销功能：先 removeAt 立即删除，再用 SnackBar 的 SnackBarAction 提供"撤销"入口，
//      撤销时 insert 回原位置
//   3. 新增地址用 AlertDialog 弹窗 + TextEditingController 收集表单数据，
//      保存时构造 AddressData 添加到列表
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';

// 地址管理页：显示地址列表，支持新增、设为默认、删除（可撤销）
class AddressPage extends StatefulWidget {
  const AddressPage({super.key, required this.addresses});
  final List<AddressData> addresses;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // 将指定地址设为默认
  void _setDefault(int index) {
    setState(() {
      for (var i = 0; i < widget.addresses.length; i++) {
        widget.addresses[i] = widget.addresses[i].copyWith(isDefault: i == index);
      }
    });
  }

  // 删除地址：带 SnackBar 撤销功能
  void _deleteAddress(int index) {
    final removed = widget.addresses[index];
    setState(() => widget.addresses.removeAt(index));
    if (removed.isDefault && widget.addresses.isNotEmpty) {
      widget.addresses[0] = widget.addresses[0].copyWith(isDefault: true);
    }
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
      SnackBar(
        content: Text('已删除 ${removed.name} 的地址'),
        action: SnackBarAction(label: '撤销', onPressed: () {
          setState(() => widget.addresses.insert(index, removed));
        }),
      ),
    );
  }

  // 弹出新增地址对话框
  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final regionCtrl = TextEditingController(text: '浙江省 杭州市');
    final detailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新增地址'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '姓名', border: OutlineInputBorder()),),
              const SizedBox(height: 10),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: '手机号', border: OutlineInputBorder()),),
              const SizedBox(height: 10),
              TextField(controller: regionCtrl, decoration: const InputDecoration(labelText: '地区', border: OutlineInputBorder()),),
              const SizedBox(height: 10),
              TextField(controller: detailCtrl, decoration: const InputDecoration(labelText: '详细地址', border: OutlineInputBorder()),),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
              setState(() {
                widget.addresses.add(AddressData(
                  name: nameCtrl.text, phone: phoneCtrl.text,
                  region: regionCtrl.text, detail: detailCtrl.text,
                  isDefault: widget.addresses.isEmpty,
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收货地址'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: respWrap(
          widget.addresses.isEmpty
              ? const Center(child: Text('暂无收货地址', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.addresses.length,
                  itemBuilder: (_, i) {
                    final addr = widget.addresses[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 地址信息行：姓名、手机号、默认标签、删除按钮
                          Row(
                            children: [
                              Text(addr.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                              const SizedBox(width: 12),
                              Text(addr.phone, style: TextStyle(color: Colors.grey.shade600)),
                              const Spacer(),
                              if (addr.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFFFEDF1), borderRadius: BorderRadius.circular(999)),
                                  child: const Text('默认', style: TextStyle(color: Color(0xFFE85D75), fontSize: 11, fontWeight: FontWeight.w600)),
                                ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18),
                                onPressed: () => _deleteAddress(i),
                                color: Colors.grey.shade400,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 详细地址
                          Text('${addr.region} ${addr.detail}', style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
                          const SizedBox(height: 10),
                          // 非默认地址显示"设为默认"按钮
                          if (!addr.isDefault)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _setDefault(i),
                                style: TextButton.styleFrom(foregroundColor: const Color(0xFFE85D75), padding: const EdgeInsets.symmetric(horizontal: 8)),
                                child: const Text('设为默认', style: TextStyle(fontSize: 13)),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFFE85D75),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('新增地址'),
      ),
    );
  }
}
