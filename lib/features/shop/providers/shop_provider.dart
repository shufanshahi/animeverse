import 'package:animeverse/core/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for banner carousel
final shopBannerListProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return bannerList;
});

// Provider for product list
final productListProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return productList;
});

// Provider for selected product (when user clicks on a product)
final selectedProductProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// Provider for cart items
final cartItemsProvider = StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});

// Cart notifier class to manage cart state
class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  void addToCart(Map<String, dynamic> product) {
    final existingProduct = state.firstWhere(
      (item) => item['id'] == product['id'],
      orElse: () => <String, dynamic>{},
    );

    if (existingProduct.isEmpty) {
      state = [...state, {...product, 'quantity': 1}];
    } else {
      state = state.map((item) {
        if (item['id'] == product['id']) {
          return {...item, 'quantity': item['quantity'] + 1};
        }
        return item;
      }).toList();
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item['id'] != productId).toList();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    state = state.map((item) {
      if (item['id'] == productId) {
        return {...item, 'quantity': quantity};
      }
      return item;
    }).toList();
  }

  double get totalAmount {
    return state.fold(0.0, (total, item) {
      final price = item['newPrice'] as String;
      final quantity = item['quantity'] as int;
      final numericPrice = double.parse(price.replaceAll(RegExp(r'[^0-9.]'), ''));
      return total + (numericPrice * quantity);
    });
  }

  void clearCart() {
    state = [];
  }
}
