// 收藏页面
// 展示已收藏商品网格，支持取消收藏（点击关闭按钮）和加入购物车。
import 'package:flutter/material.dart';
import '../models.dart';
import '../responsive.dart';
import '../widgets/product_card.dart';

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
        // 空状态或商品网格
        child: products.isEmpty
            ? const Center(child: Text('还没有收藏商品', style: TextStyle(color: Colors.grey)))
            : respWrap(
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 收藏数量统计
                      Text('共 ${products.length} 件商品', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 10),
                      // 收藏商品网格
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
