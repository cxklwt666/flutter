// 应用入口与全局状态壳（架构核心）
// 实现原理：
//   1. 使用 IndexedStack 管理 4 个 Tab 页面，切换时不销毁页面状态
//   2. 所有共享状态放在 _ShopHomeShellState 中（购物车列表、当前分类、ProfileState）
//   3. 数据流向：State 持有数据 → 通过构造函数传给子页面 → 子页面通过回调函数修改数据
//   4. 订单流转：购物车 → 待付款 → 待发货，通过 ProfileState 中的列表迁移实现
import 'package:flutter/material.dart';
import 'models.dart';
import 'home/home_page.dart';
import 'category/category_page.dart';
import 'cart/cart_page.dart';
import 'detail/detail_page.dart';
import 'profile/profile_state.dart';
import 'profile/profile_page.dart';
import 'profile/pending_payment_page.dart';
import 'profile/favorites_page.dart';
import 'profile/settings_page.dart';
import 'profile/address_page.dart';
import 'profile/coupon_page.dart';
import 'profile/help_page.dart';
import 'profile/order_page.dart';

void main() {
  runApp(const ShopDemoApp());
}

// 应用根组件，配置 MaterialApp 主题
class ShopDemoApp extends StatelessWidget {
  const ShopDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '商城',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE85D75),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const ShopHomeShell(),
    );
  }
}

// 主页面壳：管理底部导航和全局状态
class ShopHomeShell extends StatefulWidget {
  const ShopHomeShell({super.key});

  @override
  State<ShopHomeShell> createState() => _ShopHomeShellState();
}

// 全局状态管理：持有购物车、分类、个人资料等共享数据
class _ShopHomeShellState extends State<ShopHomeShell> {
  int _currentIndex = 0;
  String _selectedCategory = '全部';
  final List<CartItemData> _cartItems = [];

  final ProfileState profile = ProfileState();

  // 底部导航栏配置
  static const _navItems = [
    NavItem('首页', Icons.home_rounded),
    NavItem('分类', Icons.grid_view_rounded),
    NavItem('购物车', Icons.shopping_bag_rounded),
    NavItem('我的', Icons.person_rounded),
  ];

  // 首页分类入口数据
  static const _homeCategories = [
    CategoryData('上新', Icons.auto_awesome_rounded, Color(0xFFFF7B7B)),
    CategoryData('女装', Icons.checkroom_rounded, Color(0xFFFFA24B)),
    CategoryData('美妆', Icons.spa_rounded, Color(0xFF9C6BFF)),
    CategoryData('数码', Icons.headphones_rounded, Color(0xFF4E8DFF)),
    CategoryData('家居', Icons.chair_alt_rounded, Color(0xFF27C498)),
  ];

  // 全部商品数据
  static const _products = [
    ProductData(
        id: 'shoe-01',
        title: '跑鞋',
        tag: '新品',
        category: '上新',
        price: 629,
        originalPrice: 666,
        rating: 4.8,
        description: '轻盈鞋底搭配透气鞋面，适合日常通勤和轻运动场景。',
        color: Color(0xFFFF8A8A),
        icon: Icons.directions_run_rounded,
        imagePath: "assets/goods/008332032094301c.png"
    ),
    ProductData(
        id: 'bag-01',
        title: '大疆手持云台',
        tag: '人气',
        category: '数码',
        price: 219,
        originalPrice: 289,
        rating: 4.7,
        description: '大疆（DJI）Osmo Pocket 3 一英寸口袋云台相机 OP灵眸手持数码相机 旅游摄像 直播vlog拍摄',
        color: Color(0xFF7B61FF),
        icon: Icons.backpack_rounded,
        imagePath: "assets/goods/00835dc5dcfd34e8.jpg"
    ),
    ProductData(
        id: 'gift-01',
        title: 'DIOR粉底液',
        tag: '推荐',
        category: '美妆',
        price: 699,
        originalPrice: 799,
        rating: 4.9,
        description: '迪奥Dior锁妆无瑕粉底液柔雾哑光0N30ml遮瑕防晒化妆品生日礼物送女友',
        color: Color(0xFFFF6FAE),
        icon: Icons.card_giftcard_rounded,
        imagePath: "assets/goods/0083320320c2c59e.jpg"
    ),
    ProductData(
        id: 'audio-01',
        title: '小米空调',
        tag: '热卖',
        category: '家居',
        price: 2299,
        originalPrice: 1999,
        rating: 4.6,
        description: '小米（MI）空调米家 1.5匹速冷静 新一级能效 双排蒸发器 整机十年质保',
        color: Color(0xFF48B8FF),
        icon: Icons.headphones_rounded,
        imagePath: "assets/goods/0083320320d4713d.jpg"
    ),
    ProductData(
        id: 'chair-01',
        title: '黑金松雾礼盒',
        tag: '舒适',
        category: '美妆',
        price: 399,
        originalPrice: 529,
        rating: 4.5,
        description: 'YSL圣罗兰夜皇后精华修护保湿护肤品生日礼物女毕业礼物',
        color: Color(0xFF3EC5A1),
        icon: Icons.weekend_rounded,
        imagePath: "assets/goods/0083465465d73a28.png"
    ),
    ProductData(
        id: 'dress-01',
        title: '天选7Pro',
        tag: '精选',
        category: '数码',
        price: 10399,
        originalPrice: 7989,
        rating: 4.7,
        description: '清爽剪裁与温柔配色兼具，适合约会和夏日出行穿搭。',
        color: Color(0xFFFF9BC8),
        icon: Icons.checkroom_rounded,
        imagePath: "assets/goods/008332032030f5f3.jpg"
    ),
    ProductData(
        id: 'shoe-02',
        title: '轻氧跑鞋',
        tag: '新品',
        category: '上新',
        price: 299,
        originalPrice: 399,
        rating: 4.8,
        description: '轻盈鞋底搭配透气鞋面，适合日常通勤和轻运动场景。',
        color: Color(0xFFFF8A8A),
        icon: Icons.directions_run_rounded,
    ),
    ProductData(
        id: 'bag-02',
        title: '果冻双肩包',
        tag: '人气',
        category: '女装',
        price: 219,
        originalPrice: 289,
        rating: 4.7,
        description: '高颜值透明拼接设计，容量实用，适合出游与日常搭配。',
        color: Color(0xFF7B61FF),
        icon: Icons.backpack_rounded,
    ),
    ProductData(
        id: 'gift-02',
        title: '香氛礼盒',
        tag: '推荐',
        category: '美妆',
        price: 169,
        originalPrice: 239,
        rating: 4.9,
        description: '花果木质调组合礼盒，送礼自用都合适，包装精致。',
        color: Color(0xFFFF6FAE),
        icon: Icons.card_giftcard_rounded,
    ),
    ProductData(
        id: 'audio-02',
        title: '无线耳机',
        tag: '热卖',
        category: '数码',
        price: 459,
        originalPrice: 599,
        rating: 4.6,
        description: '低延迟蓝牙连接，支持主动降噪和全天候续航。',
        color: Color(0xFF48B8FF),
        icon: Icons.headphones_rounded,
    ),
    ProductData(
        id: 'chair-02',
        title: '云朵懒人椅',
        tag: '舒适',
        category: '家居',
        price: 399,
        originalPrice: 529,
        rating: 4.5,
        description: '高回弹填充配合柔软面料，适合卧室和阳台休闲角落。',
        color: Color(0xFF3EC5A1),
        icon: Icons.weekend_rounded,
    ),
    ProductData(
        id: 'dress-02',
        title: '轻甜连衣裙',
        tag: '精选',
        category: '女装',
        price: 259,
        originalPrice: 329,
        rating: 4.7,
        description: '清爽剪裁与温柔配色兼具，适合约会和夏日出行穿搭。',
        color: Color(0xFFFF9BC8),
        icon: Icons.checkroom_rounded,
    ),
  ];

  // 生成分类筛选标签列表
  List<String> get _categoryTabs => ['全部', ..._homeCategories.map((c) => c.label)];

  // 根据当前选中分类筛选商品
  List<ProductData> get _filteredProducts =>
      _selectedCategory == '全部'
          ? _products
          : _products.where((p) => p.category == _selectedCategory).toList();

  // 购物车商品总数（累加每件商品的数量）
  int get _cartCount => _cartItems.fold(0, (s, i) => s + i.quantity);

  // 购物车总价（单价 × 数量，累加）
  double get _cartTotal => _cartItems.fold(0.0, (s, i) => s + i.product.price * i.quantity);

  // 显示全局提示条
  void _msg(String m) => ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(m)));

  // 加入购物车：已有该商品则数量+1，否则新增条目
  void _addToCart(ProductData p) {
    setState(() {
      final i = _cartItems.indexWhere((x) => x.product.id == p.id);
      if (i >= 0) {
        _cartItems[i] = _cartItems[i].copyWith(quantity: _cartItems[i].quantity + 1);
      } else {
        _cartItems.add(CartItemData(product: p, quantity: 1));
      }
    });
    _msg('${p.title} 已加入购物车');
  }

  // 购物车数量 +1
  void _incCart(ProductData p) => setState(() {
    final i = _cartItems.indexWhere((x) => x.product.id == p.id);
    if (i >= 0) _cartItems[i] = _cartItems[i].copyWith(quantity: _cartItems[i].quantity + 1);
  });

  // 购物车数量 -1，减到0则移除该商品
  void _decCart(ProductData p) => setState(() {
    final i = _cartItems.indexWhere((x) => x.product.id == p.id);
    if (i < 0) return;
    if (_cartItems[i].quantity <= 1) {
      _cartItems.removeAt(i);
    } else {
      _cartItems[i] = _cartItems[i].copyWith(quantity: _cartItems[i].quantity - 1);
    }
  });

  // 从购物车删除商品
  void _removeCart(ProductData p) {
    setState(() => _cartItems.removeWhere((x) => x.product.id == p.id));
    _msg('${p.title} 已从购物车移除');
  }

  // 结算：购物车商品全部转入待付款列表
  void _checkout() {
    if (_cartItems.isEmpty) return;
    setState(() {
      profile.checkout(_cartItems);
      _cartItems.clear();
    });
    _msg('下单成功，共 ${profile.pendingPayment.fold(0, (s, i) => s + i.quantity)} 件商品，请尽快付款');
  }

  // 单个付款：待付款 → 待发货
  void _pay(CartItemData item) {
    setState(() => profile.pay(item));
    _msg('付款成功');
  }

  // 全部付款
  void _payAll() {
    if (profile.pendingPayment.isEmpty) return;
    setState(() => profile.payAll());
    _msg('全部付款成功');
  }

  // 取消待付款订单
  void _cancelPending(CartItemData item) {
    setState(() => profile.cancelPending(item));
    _msg('已取消订单');
  }

  // 退款：待发货 → 取消
  void _refundOrder(CartItemData item) {
    setState(() => profile.refundOrder(item));
    _msg('已申请退款');
  }

  // 查看待发货订单列表
  void _viewOrders() {
    if (profile.orders.isEmpty) {
      _msg('暂无待发货订单');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderPage(
          orders: profile.orders,
          onRefund: _refundOrder,
        ),
      ),
    );
  }

  // 切换商品收藏状态
  void _toggleFavorite(ProductData p) {
    setState(() => profile.toggleFavorite(p));
    _msg(profile.isFavorite(p.id) ? '已收藏 ${p.title}' : '已取消收藏');
  }

  // 检查商品是否已收藏
  bool _isFavorite(String pid) => profile.isFavorite(pid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 首页 Tab
          HomePage(
            categories: _homeCategories, products: _products, cartCount: _cartCount, userName: profile.userName,
            onCategoryTap: (c) => setState(() { _selectedCategory = c; _currentIndex = 1; }),
            onCartTap: () => setState(() => _currentIndex = 2),
            onProductTap: (p) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(
              product: p, onAddToCart: () => _addToCart(p),
              isFavorite: _isFavorite(p.id), onToggleFavorite: () => _toggleFavorite(p),
            ))),
            onAddToCart: _addToCart,
          ),
          // 分类 Tab
          CategoryPage(
            categories: _categoryTabs, selectedCategory: _selectedCategory, products: _filteredProducts,
            onCategorySelected: (c) => setState(() => _selectedCategory = c),
            onProductTap: (p) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(
              product: p, onAddToCart: () => _addToCart(p),
              isFavorite: _isFavorite(p.id), onToggleFavorite: () => _toggleFavorite(p),
            ))),
            onAddToCart: _addToCart,
          ),
          // 购物车 Tab
          CartPage(
            items: _cartItems, totalPrice: _cartTotal,
            onIncrease: _incCart, onDecrease: _decCart, onRemove: _removeCart,
            onCheckout: _checkout,
          ),
          // 个人中心 Tab
          ProfilePage(
            userName: profile.userName,
            pendingDeliveryCount: profile.pendingCount,
            onEntryTap: (l) {
              if (l == '待发货') {
                _viewOrders();
              } else if (l == '待付款') {
                if (profile.pendingPayment.isEmpty) {
                  _msg('暂无待付款订单');
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PendingPaymentPage(
                    items: profile.pendingPayment,
                    onPay: _pay,
                    onPayAll: _payAll,
                    onCancel: _cancelPending,
                  ),
                ));
              } else if (l == '收藏') {
                final favProducts = profile.getFavoriteProducts(_products);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FavoritesPage(
                    products: favProducts,
                    onProductTap: (p) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(
                      product: p, onAddToCart: () => _addToCart(p),
                      isFavorite: _isFavorite(p.id), onToggleFavorite: () => _toggleFavorite(p),
                    ))),
                    onAddToCart: _addToCart,
                    onRemoveFavorite: _toggleFavorite,
                  ),
                ));
              } else if (l == '设置') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage(
                  userName: profile.userName,
                  userPhone: profile.userPhone,
                  notifyOrder: profile.notifyOrder,
                  notifyPromo: profile.notifyPromo,
                  onSave: (name, phone, notifyOrder, notifyPromo) {
                    setState(() => profile.saveSettings(name, phone, notifyOrder, notifyPromo));
                  },
                )));
              } else if (l == '收货地址') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressPage(addresses: profile.addresses)));
              } else if (l == '优惠券') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CouponPage(coupons: profile.coupons)));
              } else if (l == '帮助中心') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpPage()));
              } else {
                _msg('$l 功能待开发');
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: _navItems.map((n) {
          final isCart = n.label == '购物车';
          return NavigationDestination(
            icon: _IconBadge(icon: n.icon, count: isCart ? _cartCount : 0),
            selectedIcon: _IconBadge(icon: n.icon, count: isCart ? _cartCount : 0),
            label: n.label,
          );
        }).toList(),
      ),
    );
  }
}

// 导航图标角标组件：购物车图标右上角显示商品数量
class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.count});
  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -10, top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: const BoxDecoration(color: Color(0xFFE85D75), shape: BoxShape.circle),
              child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }
}
