import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../widgets/custom_text.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: AspectRatio(
                  aspectRatio: 1.15,
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported, size: 72),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: product.title,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontColor: colorScheme.onSurface,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: product.category.toUpperCase(),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontColor: colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade700, size: 18.sp),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: '${product.rating.toStringAsFixed(1)} / 5.0',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontColor: colorScheme.onSurface,
                  ),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: '\$${product.price.toStringAsFixed(2)}',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontColor: colorScheme.primary,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _InfoCard(
                title: 'Description',
                child: CustomText(
                  text: product.description,
                  fontSize: 14.sp,
                  fontColor: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              _InfoCard(
                title: 'Product Info',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Brand', value: product.brand ?? 'N/A'),
                    _InfoRow(label: 'Stock', value: '${product.stock}'),
                    _InfoRow(
                      label: 'Availability',
                      value: product.availabilityStatus,
                    ),
                    _InfoRow(
                      label: 'Discount',
                      value: '${product.discountPercentage.toStringAsFixed(1)}%',
                    ),
                    _InfoRow(
                      label: 'Warranty',
                      value: product.warrantyInformation,
                    ),
                    _InfoRow(
                      label: 'Shipping',
                      value: product.shippingInformation,
                    ),
                    _InfoRow(
                      label: 'Return Policy',
                      value: product.returnPolicy,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _InfoCard(
                title: 'Dimensions',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Width', value: '${product.dimensions.width}'),
                    _InfoRow(label: 'Height', value: '${product.dimensions.height}'),
                    _InfoRow(label: 'Depth', value: '${product.dimensions.depth}'),
                    _InfoRow(label: 'Weight', value: '${product.weight}'),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              _InfoCard(
                title: 'Reviews',
                child: product.reviews.isEmpty
                    ? Text(
                        'No reviews available.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                      )
                    : Column(
                        children: product.reviews
                            .map(
                              (review) => Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: review.reviewerName,
                                            fontWeight: FontWeight.bold,
                                            fontColor: colorScheme.onSurface,
                                          ),
                                          Row(
                                            children: List.generate(
                                              review.rating,
                                              (index) => Icon(
                                                Icons.star,
                                                size: 16.sp,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      CustomText(
                                        text: review.comment,
                                        fontColor: colorScheme.onSurface,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: review.date,
                                        fontSize: 11.sp,
                                        fontStyle: FontStyle.italic,
                                        fontColor: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} added to cart')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontColor: colorScheme.onSurface,
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: CustomText(
              text: '$label:',
              fontWeight: FontWeight.w600,
              fontColor: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              fontColor: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}