import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../widgets/custom_text.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart> _cartFuture;
  // Local quantity map to track +/- changes per product id
  final Map<int, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    // Enhancement 3: Fetch cart by user ID
    _cartFuture = CartService().getCartByUserId(1);
  }

  void _increment(int productId) {
    setState(() {
      _quantities[productId] = (_quantities[productId] ?? 0) + 1;
    });
  }

  void _decrement(int productId, int currentQty) {
    final qty = _quantities[productId] ?? currentQty;
    if (qty > 1) {
      setState(() {
        _quantities[productId] = qty - 1;
      });
    }
  }

  double _computeSubtotal(List<CartProduct> products) {
    return products.fold(0.0, (sum, p) {
      final qty = _quantities[p.id] ?? p.quantity;
      return sum + (p.price * qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Cart>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: CustomText(
                text: 'Error: ${snapshot.error}',
                fontSize: 14.sp,
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CustomText(
                text: 'No cart data found.',
                fontSize: 14.sp,
              ),
            );
          }

          final Cart cart = snapshot.data!;

          // Initialise quantities map on first build
          for (final p in cart.products) {
            _quantities.putIfAbsent(p.id, () => p.quantity);
          }

          final double subtotal = _computeSubtotal(cart.products);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: cart.products.length,
                  itemBuilder: (context, index) {
                    final product = cart.products[index];
                    final qty = _quantities[product.id] ?? product.quantity;
                    return _CartItemCard(
                      product: product,
                      quantity: qty,
                      onIncrement: () => _increment(product.id),
                      onDecrement: () => _decrement(product.id, qty),
                    );
                  },
                ),
              ),
              _CartSummary(subtotal: subtotal),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatefulWidget {
  const _CartItemCard({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartProduct product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  State<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<_CartItemCard> {
  bool _isLoading = false;

  // Enhancement 1: Tap item → fetch full product → navigate to detail_screen
  Future<void> _navigateToDetail(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final fullProduct =
          await ProductService().getProductById(widget.product.id);
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: fullProduct),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load product details: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : () => _navigateToDetail(context),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  widget.product.thumbnail,
                  width: 64.w,
                  height: 64.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image,
                    size: 40.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Title, price, discount info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.product.title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: '\$${widget.product.price.toStringAsFixed(2)}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontColor: const Color(0xFF655A7C),
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text:
                          '${widget.product.discountPercentage.toStringAsFixed(0)}% off • \$${(widget.product.price * widget.quantity).toStringAsFixed(2)} total',
                      fontSize: 11.sp,
                      fontColor: Colors.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Quantity controls — functional +/- buttons
              if (_isLoading)
                SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Column(
                  children: [
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: widget.onIncrement,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      text: '${widget.quantity}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 6.h),
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: widget.onDecrement,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: const Color(0xFF655A7C),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Subtotal:',
                fontSize: 14.sp,
                fontColor: Colors.grey,
              ),
              CustomText(
                text: '\$${subtotal.toStringAsFixed(2)}',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontColor: const Color(0xFF655A7C),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Delivery Fee:',
                fontSize: 14.sp,
                fontColor: Colors.grey,
              ),
              CustomText(
                text: '\$0.00',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontColor: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order confirmed!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF655A7C),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: CustomText(
                text: 'Confirm Order',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
