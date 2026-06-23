// 收藏页面（收藏商品管理页）
// 实现原理：
//   1. 商品列表由父组件从 ProfileState.getFavoriteProducts() 获取后传入，本页只做展示
//   2. 每个商品卡片右上角叠加一个半透明关闭按钮（Stack + Positioned），点击时触发 onRemoveFavorite 回调
//   3. 页面为 StatelessWidget，收藏状态的增删由父组件通过 setState + ProfileState.toggleFavorite 控制
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';
import '../widgets/product_card.dart';

// 收藏页：显示已收藏的商品网格，支持取消收藏和加入购物车
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onRemoveFavorite,
  });
  final List<ProductData> products;
  final ValueChanged<ProductData> onProductTap;
  final ValueChanged<ProductData> onAddToCart;
  final ValueChanged<ProductData> onRemoveFavorite;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = contentPadding(w);
    final cols = gridColumns(w);
    final ratio = gridRatio(w);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: products.isEmpty
            ? const Center(child: Text('还没有收藏商品', style: TextStyle(color: Colors.grey)))
            : respWrap(
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 收藏数量统计文字
                      Text('共 ${products.length} 件商品', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 10),
                      // 收藏商品网格：每个卡片右上角有关闭按钮可取消收藏
                      Expanded(
                        child: GridView.builder(
                          itemCount: products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: ratio,
                          ),
                          itemBuilder: (_, i) {
                            final p = products[i];
                            return Stack(
                              children: [
                                ProductCard(product: p, onTap: () => onProductTap(p), onAddToCart: () => onAddToCart(p)),
                                // 右上角取消收藏按钮
                                Positioned(
                                  top: 4, right: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                      onPressed: () => onRemoveFavorite(p),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
