// 收货地址页面
// 展示地址列表，支持设为默认、删除（可撤销）和通过弹窗新增地址。
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key, required this.addresses});
  final List<AddressData> addresses;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // 设置默认地址
  void _setDefault(int index) {
    setState(() {
      for (var i = 0; i < widget.addresses.length; i++) {
        widget.addresses[i] = widget.addresses[i].copyWith(isDefault: i == index);
      }
    });
  }

  // 删除地址（带撤销功能）
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
                          // 地址信息行
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
                          // 设为默认按钮
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
