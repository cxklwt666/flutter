// 个人中心全局状态管理（集中式状态层）
// 实现原理：
//   1. 使用普通 Dart 类（非 ChangeNotifier）配合父 Widget 的 setState 驱动 UI 更新
//   2. 订单状态机：购物车 checkout() → 待付款列表 → pay() → 待发货列表 → refund() 取消
//   3. 收藏用 Set<String> 存储商品ID，利用 Set 的 O(1) 查找性能判断是否已收藏
//   4. 地址管理使用 copyWith 不可变更新，删除默认地址时自动转移默认标记
import '../models.dart';

// 个人中心全局状态：管理用户信息、订单流程、收藏、地址、优惠券和设置
class ProfileState {
  // 用户设置
  String userName = '小鲸鱼';
  String userPhone = '138****8888';
  bool notifyOrder = true;
  bool notifyPromo = false;

  // 待发货订单列表（已付款未发货）
  final List<CartItemData> orders = [];
  // 待付款列表（已下单未付款）
  final List<CartItemData> pendingPayment = [];
  // 收藏商品 ID 集合
  final Set<String> favoriteIds = {};

  // 收货地址预置数据
  final List<AddressData> addresses = [
    const AddressData(name: '小鲸鱼', phone: '138****8888', region: '浙江省 杭州市 西湖区', detail: '文三路 100 号 3 栋 201', isDefault: true),
    const AddressData(name: '小鲸鱼', phone: '139****9999', region: '上海市 浦东新区', detail: '张江高科技园区 66 号'),
  ];

  // 优惠券预置数据
  final List<CouponData> coupons = [
    const CouponData(title: '618 满减券', discount: '¥50', condition: '满 300 可用', expiry: '2026-06-30'),
    const CouponData(title: '新人专享券', discount: '¥20', condition: '无门槛', expiry: '2026-07-15'),
    const CouponData(title: '会员折扣券', discount: '8折', condition: '满 200 可用', expiry: '2026-07-01', type: '折扣'),
    const CouponData(title: '包邮券', discount: '包邮', condition: '全场通用', expiry: '2026-06-30', type: '包邮'),
  ];

  // 待发货商品总数（累加每件商品的数量）
  int get pendingCount => orders.fold(0, (s, i) => s + i.quantity);

  // 从全部商品中筛选出已收藏的商品
  List<ProductData> getFavoriteProducts(List<ProductData> allProducts) {
    return allProducts.where((p) => favoriteIds.contains(p.id)).toList();
  }

  // 结算：购物车全部转入待付款列表
  void checkout(List<CartItemData> cartItems) {
    pendingPayment.addAll(cartItems);
  }

  // 付款：单件商品从待付款移到待发货
  void pay(CartItemData item) {
    pendingPayment.remove(item);
    orders.add(item);
  }

  // 全部付款：所有待付款商品直接转入待发货
  void payAll() {
    orders.addAll(pendingPayment);
    pendingPayment.clear();
  }

  // 取消待付款订单：从待付款列表中移除
  void cancelPending(CartItemData item) {
    pendingPayment.remove(item);
  }

  // 退款：从待发货列表中移除
  void refundOrder(CartItemData item) {
    orders.remove(item);
  }

  // 切换收藏状态：已收藏则取消，未收藏则添加
  void toggleFavorite(ProductData p) {
    if (favoriteIds.contains(p.id)) {
      favoriteIds.remove(p.id);
    } else {
      favoriteIds.add(p.id);
    }
  }

  // 判断指定商品是否已收藏
  bool isFavorite(String productId) => favoriteIds.contains(productId);

  // 设置某个地址为默认地址（遍历全部，只有目标索引为 true）
  void setAddressDefault(int index) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i] = addresses[i].copyWith(isDefault: i == index);
    }
  }

  // 删除指定地址，若删除的是默认地址则将第一条设为默认
  void deleteAddress(int index) {
    final removed = addresses[index];
    addresses.removeAt(index);
    if (removed.isDefault && addresses.isNotEmpty) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }
  }

  // 新增地址
  void addAddress(AddressData addr) {
    addresses.add(addr);
  }

  // 保存用户设置（昵称、手机号、通知开关）
  void saveSettings(String name, String phone, bool orderNotify, bool promoNotify) {
    userName = name;
    userPhone = phone;
    notifyOrder = orderNotify;
    notifyPromo = promoNotify;
  }
}
