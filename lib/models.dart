// 数据模型模块（全局共享的数据类）
// 实现原理：
//   1. ProductData 同时包含 imagePath（真实图片路径）和 icon（图标），
//      有 imagePath 的商品显示真实图片，否则显示彩色背景+图标，实现双模式渲染
//   2. CartItemData 使用 copyWith 实现不可变更新模式（immutable pattern），
//      每次修改数量都创建新对象，避免直接修改原数据引发副作用
//   3. AddressData / CouponData 作为纯数据容器（Plain Old Dart Object），不包含业务逻辑
import 'package:flutter/material.dart';

// 底部导航栏项目：包含导航标签和图标
class NavItem {
  const NavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

// 首页分类入口：包含文字标签、图标和背景色
class CategoryData {
  const CategoryData(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

// 商品数据：imagePath 可选，有路径显示真实图片否则显示图标
class ProductData {
  const ProductData({
    required this.id, required this.title, required this.tag, required this.category,
    required this.price, required this.originalPrice, required this.rating,
    required this.description, required this.color, required this.icon, this.imagePath = '',
  });
  final String id;
  final String title;
  final String tag;
  final String category;
  final int price;
  final int originalPrice;
  final double rating;
  final String description;
  final Color color;
  final IconData icon;
  final String imagePath;
}

// 购物车条目：商品 + 数量，copyWith 支持不可变更新
class CartItemData {
  const CartItemData({required this.product, required this.quantity});
  final ProductData product;
  final int quantity;

  // 创建修改后的副本（只修改指定的字段，其余保持不变）
  CartItemData copyWith({ProductData? product, int? quantity}) {
    return CartItemData(product: product ?? this.product, quantity: quantity ?? this.quantity);
  }
}

// 收货地址
class AddressData {
  const AddressData({
    required this.name, required this.phone,
    required this.region, required this.detail,
    this.isDefault = false,
  });
  final String name;
  final String phone;
  final String region;
  final String detail;
  final bool isDefault;

  // 创建修改后的地址副本（用于"设为默认"功能）
  AddressData copyWith({String? name, String? phone, String? region, String? detail, bool? isDefault}) {
    return AddressData(
      name: name ?? this.name, phone: phone ?? this.phone,
      region: region ?? this.region, detail: detail ?? this.detail,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

// 优惠券：分满减/折扣/包邮三种类型
class CouponData {
  const CouponData({
    required this.title, required this.discount,
    required this.condition, required this.expiry,
    this.type = '满减',
  });
  final String title;
  final String discount;
  final String condition;
  final String expiry;
  final String type;
}
