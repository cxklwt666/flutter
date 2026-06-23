// 个人中心全局状态管理
// 集中管理用户信息、订单流程、收藏、地址、优惠券和设置。
// 被 main.dart 中的 ShopHomeShell 持有，生命周期与应用一致。
import '../models.dart';

class ProfileState {
  // 用户设置
  String userName = '小鲸鱼';
  String userPhone = '138****8888';
  bool notifyOrder = true;
  bool notifyPromo = false;

  // 订单列表
  final List<CartItemData> orders = [];
  // 待付款列表
  final List<CartItemData> pendingPayment = [];
  // 收藏商品 ID 集合
  final Set<String> favoriteIds = {};

  // 收货地址数据
  final List<AddressData> addresses = [
    const AddressData(name: '小鲸鱼', phone: '138****8888', region: '浙江省 杭州市 西湖区', detail: '文三路 100 号 3 栋 201', isDefault: true),
    const AddressData(name: '小鲸鱼', phone: '139****9999', region: '上海市 浦东新区', detail: '张江高科技园区 66 号'),
  ];

  // 优惠券数据
  final List<CouponData> coupons = [
    const CouponData(title: '618 满减券', discount: '¥50', condition: '满 300 可用', expiry: '2026-06-30'),
    const CouponData(title: '新人专享券', discount: '¥20', condition: '无门槛', expiry: '2026-07-15'),
    const CouponData(title: '会员折扣券', discount: '8折', condition: '满 200 可用', expiry: '2026-07-01', type: '折扣'),
    const CouponData(title: '包邮券', discount: '包邮', condition: '全场通用', expiry: '2026-06-30', type: '包邮'),
  ];

  // 待发货商品总数
  int get pendingCount => orders.fold(0, (s, i) => s + i.quantity);

  // 获取已收藏的商品列表
  List<ProductData> getFavoriteProducts(List<ProductData> allProducts) {
    return allProducts.where((p) => favoriteIds.contains(p.id)).toList();
  }

  // 结算：购物车 → 待付款
  void checkout(List<CartItemData> cartItems) {
    pendingPayment.addAll(cartItems);
  }

  // 付款：待付款 → 待发货
  void pay(CartItemData item) {
    pendingPayment.remove(item);
    orders.add(item);
  }

  // 全部付款
  void payAll() {
    orders.addAll(pendingPayment);
    pendingPayment.clear();
  }

  // 取消待付款订单
  void cancelPending(CartItemData item) {
    pendingPayment.remove(item);
  }

  // 退款
  void refundOrder(CartItemData item) {
    orders.remove(item);
  }

  // 切换收藏状态
  void toggleFavorite(ProductData p) {
    if (favoriteIds.contains(p.id)) {
      favoriteIds.remove(p.id);
    } else {
      favoriteIds.add(p.id);
    }
  }

  // 检查是否已收藏
  bool isFavorite(String productId) => favoriteIds.contains(productId);

  // 地址管理
  void setAddressDefault(int index) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i] = addresses[i].copyWith(isDefault: i == index);
    }
  }

  void deleteAddress(int index) {
    final removed = addresses[index];
    addresses.removeAt(index);
    if (removed.isDefault && addresses.isNotEmpty) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }
  }

  void addAddress(AddressData addr) {
    addresses.add(addr);
  }

  // 保存用户设置
  void saveSettings(String name, String phone, bool orderNotify, bool promoNotify) {
    userName = name;
    userPhone = phone;
    notifyOrder = orderNotify;
    notifyPromo = promoNotify;
  }
}
