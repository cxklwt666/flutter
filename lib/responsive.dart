// 响应式布局工具模块（屏幕适配核心）
// 实现原理：
//   1. 通过 LayoutBuilder 获取父容器宽度，调用本模块函数动态计算布局参数
//   2. 断点策略：600px以下视为手机，600-900px视为平板，900px以上视为桌面
//   3. respWrap 在桌面端用 Center+ConstrainedBox 限制最大宽度1200px，避免内容过宽
import 'package:flutter/material.dart';

// 商品网格列数：手机2列、平板3列、桌面4列
int gridColumns(double w) => w < 600 ? 2 : (w < 900 ? 3 : 4);

// 商品卡片宽高比：手机0.7，平板/桌面0.75
double gridRatio(double w) => w < 600 ? 0.7 : 0.75;

// 页面左右留白宽度
double contentPadding(double w) => w < 600 ? 16.0 : (w < 900 ? 24.0 : 32.0);

// 页面内部横向间距（购物车/详情页使用）
double innerHPadding(double w) => w < 600 ? 16.0 : 24.0;

// 桌面端居中包裹：宽度超过900px时居中，最大宽度1200px
Widget respWrap(Widget child) {
  return LayoutBuilder(builder: (_, c) {
    final w = c.maxWidth;
    if (w < 900) return child;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  });
}
